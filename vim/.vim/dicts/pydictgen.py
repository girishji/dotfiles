#!/usr/bin/env python3
"""
Create dictionary of Python module attributes.
Dictionary is written to stdout.

Base on: https://github.com/vim-scripts/Pydiction
"""

import inspect
import keyword
import re
import sys
import types


def get_python_version():
    return sys.version_info[0:3]


def my_import(name):
    """Make __import__ import "package.module" formatted names."""
    mod = __import__(name)
    components = name.split('.')
    for comp in components[1:]:
        mod = getattr(mod, comp)
    return mod


def get_submodules(module_name, submodules):
    """Build a list of all the submodules of modules."""
    try:
        imported_module = my_import(module_name)
    except ImportError:
        return submodules

    mod_attrs = dir(imported_module)

    for mod_attr in mod_attrs:
        try:
            if isinstance(getattr(imported_module, mod_attr), types.ModuleType):
                submodules.append(module_name + '.' + mod_attr)
        except AttributeError as e:
            print(e)

    return submodules


def get_format(imported_module, mod_attr, use_prefix):
    format = ''

    if use_prefix:
        format_noncallable = '%s.%s'
        format_callable = '%s.%s('
    else:
        format_noncallable = '%s'
        format_callable = '%s('

    try:
        attr_val = getattr(imported_module, mod_attr)
        if callable(attr_val) and not (inspect.isclass(attr_val) and issubclass(attr_val, BaseException)):
            # If an attribute is callable, show an opening parentheses:
            format = format_callable
        else:
            format = format_noncallable
    except AttributeError as e:
        print(e)

    return format


def remove_duplicates(seq):
    """
    Remove duplicates from a sequence while perserving order.
    """
    seq2 = []
    seen = set()
    for i in seq:
        if i not in seen:
            seq2.append(i)
        seen.add(i)
    return seq2


def write_dictionary(module_name, module_list, skip_prefix=False, skip_qualified=False):
    """Print the module attributes."""
    python_version = '%s.%s.%s' % get_python_version()

    try:
        imported_module = my_import(module_name)
    except ImportError:
        return

    if module_name.count('.'):
        # ignore private submodules xxx._yyy
        second_part = module_name[module_name.rfind('.') + 1:]
        if re.match(r'_\w+', second_part):
            return

    mod_attrs = dir(imported_module)
    # remove private attributes and magic methods (__xxx__ and _xxx())
    mod_attrs = [m for m in mod_attrs if not (re.match(r'_\w+', m) or re.match(r'__\w+__[)(]*', m))]
    # sort such that methods starting with lower case letters are at the top.
    pattern = r'[a-z]+\w*.*'
    favored = [m for m in mod_attrs if re.match(pattern, m)]
    rest = [m for m in mod_attrs if not re.match(pattern, m)]
    mod_attrs = favored + rest

    # If a module was passed on the command-line we'll call it a root module
    if module_name in module_list:
        try:
            module_version = '%s/' % imported_module.__version__
        except AttributeError:
            module_version = ''
        module_info = '(%spy%s/%s/root module) ' % (
            module_version, python_version, sys.platform)
    else:
        module_info = ''

    if not skip_prefix:
        write_to.write('--- import %s %s---\n' % (module_name, module_info))
        write_to.write('%s\n' % module_name)
        for mod_attr in mod_attrs:
            format = get_format(imported_module, mod_attr, True)
            if format != '':
                write_to.write(format % (module_name, mod_attr) + '\n')

    # Generate submodule names by themselves, for when someone does
    # "from foo import bar" and wants to complete bar.baz.
    # This works the same no matter how many .'s are in the module.
    if module_name.count('.'):
        # Get the "from" part of the module. E.g., 'xml.parsers'
        # if the module name was 'xml.parsers.expat':
        first_part = module_name[:module_name.rfind('.')]
        # Get the "import" part of the module. E.g., 'expat'
        # if the module name was 'xml.parsers.expat'
        second_part = module_name[module_name.rfind('.') + 1:]
        write_to.write('--- from %s import %s ---\n' %
                       (first_part, second_part))
        write_to.write('%s\n' % second_part)
        for mod_attr in mod_attrs:
            format = get_format(imported_module, mod_attr, True)
            if format != '':
                write_to.write(format % (second_part, mod_attr) + '\n')

    # Generate non-fully-qualified module names:
    if not skip_qualified:
        write_to.write('--- from %s import * ---\n' % module_name)
        for mod_attr in mod_attrs:
            format = get_format(imported_module, mod_attr, False)
            if format != '':
                write_to.write(format % mod_attr + '\n')


def main(module_list, skip_qualified=False):

    submodules = []

    for module_name in module_list:
        try:
            my_import(module_name)
        except ImportError as err:
            print("Couldn't import: %s. %s" % (module_name, err))
            module_list.remove(module_name)

    # Step through each command line argument:
    for module_name in module_list:
        # print("Trying module: %s" % module_name)
        submodules = get_submodules(module_name, submodules)

        # Step through the current module's submodules:
        for submodule_name in submodules:
            submodules = get_submodules(submodule_name, submodules)

    # Add the top-level modules to the list too:
    for module_name in module_list:
        submodules.append(module_name)

    submodules = remove_duplicates(submodules)
    submodules.sort()

    # Step through all of the modules and submodules to create the dict file:
    for submodule_name in submodules:
        write_dictionary(submodule_name, module_list, skip_qualified=skip_qualified)


if __name__ == "__main__":
    if get_python_version() < (3, 0):
        sys.exit("You need at least Python 3.0")

    write_to = sys.stdout

    with open('python.dict.manual') as f:
        for line in f:
            write_to.write(line)

    write_to.write('--- reserved words (py{}) ---\n'.format('.'.join(map(str, get_python_version()))))
    for kw in sorted(keyword.kwlist):
        write_to.write(kw + '\n')

    write_dictionary('builtins', ['builtins'], skip_prefix=True)

    modules = 'itertools functools collections'
    main(modules.split())
    modules = 'heapq copy random re bisect time math os sys inspect operator traceback pprint string doctest md5 sha keyword'
    main(modules.split(), skip_qualified=True)

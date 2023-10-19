return {
  s({ trig = 'printv', dscr = 'Print lua var/table' }, { t 'print(vim.inspect(', i(1, 'var'), t '))' }),
  s("localv", fmt([[local {} = require('{}')]], { f(function(args, _, _)
    local parts = vim.split(args[1][1], '.', true)
    return parts[#parts] or ""
  end, { 1 }), i(1) })),
}

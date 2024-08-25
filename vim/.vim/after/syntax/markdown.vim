unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml
syntax clear markdownError

" Prevent '*' in code fragments being interpreted as italic delimiters
syn clear markdownItalic
syn clear markdownItalicDelimiter

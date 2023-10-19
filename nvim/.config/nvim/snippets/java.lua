-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

local pkgname = function()
  local fpath = vim.split(vim.fn.expand("%:p"), '/', true)
  return fpath[#fpath - 2] .. '.' .. fpath[#fpath - 1]
end

return {
  -- package
  s({ trig = "package", dscr = 'package name' },
    { t "package ", i(1), f(pkgname), t ';' }, { key = "java" }),

  -- file skeleton
  s({ trig = "filesk", dscr = 'file skeleton' },
    fmt([[
    package {};

    public class {} {{
      {}
    }}
    ]], {
      f(pkgname),
      f(function()
        fname = vim.split(vim.fn.expand("%:t"), '.', true)
        return fname[1]
      end),
      i(1)
    }), { key = "java" }),

  -- record
  s("record", { t 'record ', i(1, 'Name'), t '(', i(2, 'Vars'), t ') { }' }, { key = "java" }),

  -- public static class
  s({ trig = "classs", dscr = 'static class' }, fmt([[{} static class {} {{
    {}
    }}
    ]], {
    c(1, {
      t("public"),
      t("private"),
    }),
    i(2, 'Name'),
    i(0) }), { key = "java" }),

  -- public class
  s({ trig = "class", dscr = 'class' }, {
    c(1, {
      t("public "),
      t("private "),
    }),
    t 'class ',
    i(2, 'myClass '),
    c(3, {
      t ' ',
      sn(nil, { t ' extends ', i(1) }),
      sn(nil, { t ' implements ', i(1) }),
    }),
    t({ "{", "\t" }),
    i(0),
    t({ "", "}" }), -- NOTE: table inside t() results in newline being inserted before '}'
  }, { key = "java" }),

}

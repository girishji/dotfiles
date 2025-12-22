" ------------------------------------------------------------
" Formatting
" ------------------------------------------------------------

" setl path-=/usr/include

setlocal formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4,\ SpaceBeforeParens:\ false}'
nnoremap <buffer> <leader>F gggqG<CR>


" ------------------------------------------------------------
" Loop helpers
" ------------------------------------------------------------

iab <buffer> ff; <C-o>:FFI
command! -nargs=* FFI call FF("int", "", <f-args>)

iab <buffer> ffc; <C-o>:FFC
command! -nargs=* FFC call FF("int", "(int)", <f-args>)

iab <buffer> ffs; <C-o>:FFS
command! -nargs=* FFS call FF("size_t", "", <f-args>)

function! FF(type, cast, i, x) abort
  execute 'normal! a' .
        \ 'for (' . a:type . ' ' . a:i . ' = 0; ' .
        \ a:i . ' < ' . a:cast . a:x . '; ++' . a:i . ') {'
  execute "normal o\<space>\<BS>\<Esc>"
  execute "normal o}\ekA"
endfunction


" ------------------------------------------------------------
" Iterator helpers
" ------------------------------------------------------------

iabbr <buffer> ffit;  <C-o>:FFIT
command! -nargs=* FFIT call FFIT(0, <f-args>)

iabbr <buffer> ffitr; <C-o>:FFITR
command! -nargs=* FFITR call FFIT(1, <f-args>)

function! FFIT(reverse, a, ...) abort
  let it = a:0 ? a:1 : 'it'

  if !a:reverse
    execute 'normal! a' .
          \ 'for (auto ' . it . ' = ' . a:a .
          \ '.begin(); ' . it . ' != ' . a:a .
          \ '.end(); ' . it . '++) {'
  else
    execute 'normal! a' .
          \ 'for (auto ' . it . ' = ' . a:a .
          \ '.rbegin(); ' . it . ' != ' . a:a .
          \ '.rend(); ' . it . '++) {'
  endif

  execute "normal o\<space>\<BS>\<Esc>"
  execute "normal o}\ekA"
endfunction


" ------------------------------------------------------------
" Abbreviations (unchanged)
" ------------------------------------------------------------

iabbr <buffer> alle .begin(), .end()<Esc>BBi<C-R>=Eatchar()<CR>

iabbr <silent><buffer> fori;  for (int i = 0; i < (int); i++) {<C-o>o}<Esc>kf;;i<C-R>=Eatchar()<CR>
iabbr <silent><buffer> forj;  for (int j = 0; j < (int); j++) {<C-o>o}<Esc>kf;;i<C-R>=Eatchar()<CR>
iabbr <silent><buffer> fork;  for (int k = 0; k < (int); k++) {<C-o>o}<Esc>kf;;i<C-R>=Eatchar()<CR>
iabbr <silent><buffer> fora;  for (const auto& el : ) {<C-o>o}<Esc>kf:la<C-R>=Eatchar()<CR>

iabbr <buffer> if; if (int t{}; cin >> t) {<C-o>o}<Esc>kfti<C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" Types
" ------------------------------------------------------------

iabbr <silent><buffer> vi;    vector<int>
iabbr <silent><buffer> vvi;   vector<vector<int>>
iabbr <silent><buffer> vs;    vector<string>
iabbr <silent><buffer> vpii;  vector<pair<int, int>>
iabbr <silent><buffer> mii;   map<int, int>

iabbr <buffer> pii pair<int, int><C-R>=Eatchar()<CR>
iabbr <buffer> pair; make_pair(<C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" Convenience
" ------------------------------------------------------------

iabbr <silent><buffer> in; #include <bits/stdc++.h>
      \ <CR>using namespace std;
      \ <CR>using namespace string_view_literals;
      \ <CR>namespace rg = ranges;
      \ <CR>namespace rv = ranges::views;
      \ <CR>using i64 = int64_t;
      \ <CR>#define F first
      \ <CR>#define S second
      \ <CR><CR><C-R>=Eatchar()<CR>

iabbr <silent><buffer> mn; int main() {<CR>}<Esc>O<C-R>=Eatchar()<CR>
iabbr <silent><buffer> c; cout <<  << endl;<Esc>8hi<C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" Algorithms / ranges / utilities
" ------------------------------------------------------------

iabbr <buffer> sort_projection; ranges::sort(v, {}, &pair<int,int>::first);<C-R>=Eatchar()<CR>
iabbr <buffer> reduce; use fold_left

iabbr <buffer> fold_left; ranges::fold_left(v, 0,
      \ [](int acc, const auto& cur) {
      \ <CR>return acc + cur;
      \ <CR>})<C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" I/O helpers
" ------------------------------------------------------------

iabbr <buffer> pr; print("{}\n", );<Left><Left><C-R>=Eatchar()<CR>

iabbr <buffer> pr_map; for (const auto& [k, v] : ) {
      \ <CR>cout << k << ": " << v << endl;
      \ <CR>}<Esc>12Bi<C-R>=Eatchar()<CR


" ------------------------------------------------------------
" Regex
" ------------------------------------------------------------

iabbr <buffer> regex; smatch matches;
      \ <CR>regex pat{R"(\\w{2}\\s*\\d{5}(-\\d{4})?)"};
      \ <CR>if (regex_search(line, matches, pat)) {
      \ <CR>cout << matches[0] << endl;
      \ <CR>}<C-R>=Eatchar()<CR


" ------------------------------------------------------------
" Iterators
" ------------------------------------------------------------

iabbr <buffer> it_prev; prev(m.end())
iabbr <buffer> it_next; next(m.begin())


" ------------------------------------------------------------
" Remove / erase
" ------------------------------------------------------------

iabbr <buffer> erase_remove; v.erase(remove_if(v.begin(), v.end(),
      \ [](auto& x) { return x > 5; }), v.end());<C-R>=Eatchar()<CR

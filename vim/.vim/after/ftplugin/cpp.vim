vim9script

# setl path-=/usr/include
# setl makeprg=clang++\ -include"$HOME/.clang-repl-incl.h"\ -std=c++23\ -stdlib=libc++\ -fexperimental-library\ -o\ /tmp/a.out\ %\ &&\ /tmp/a.out
# NOTE: brew installs gcc in /opt/homebrew/bin. Currently g++-14 is installed. Note that g++ takes you to clang, os use g++-14.
setl makeprg=g++-14\ -std=c++23\ -Wall\ -Wextra\ -Wconversion\ -DONLINE_JUDGE\ -O2\ -lstdc++exp\ -o\ /tmp/a.out\ %\ &&\ /tmp/a.out

# Use 'gq', or 'gggqG<cr>' to format the whole file.
setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4,\ SpaceBeforeParens:\ false}'
# setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4}'
nnoremap <buffer> <leader>F gggqG<cr>

nnoremap <buffer> <leader>m :make %<cr>

iabbr <silent><buffer> fori; for(int i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forj; for(int j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fork; for(int k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fori;; for(unsigned long i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forj;; for(unsigned long j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fork;; for(unsigned long k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fora; for(auto& x : ) {<c-o>o}<esc>kf:la<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_iter; for(auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_each; ranges::for_each(, [](int& n) {});<esc>16hi<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> print_for_each; ranges::for_each(, [](const int& n) {cout << n;});cout<<endl;<esc>F(;a<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> print_range_copy; ranges::copy(x, ostream_iterator<int>(cout, " "));cout<<endl;<esc>Fxcw<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> all; a.begin(), a.end()<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> max_element; ranges::max_element(<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> distance; ranges::distance(<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> r; ranges::<C-R>=abbr#Eatchar()<CR>

iabbr <silent><buffer> ul; unsigned long
iabbr <silent><buffer> ll; signed long long
iabbr <silent><buffer> vi; vector<int>
iabbr <silent><buffer> vii; vector<vector<int>>
iabbr <silent><buffer> vs; vector<string>
iabbr <silent><buffer> pi; pair<int, int>

iabbr <silent><buffer> in; #include <bits/stdc++.h>
            \<cr>using namespace std;<cr><c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> mn; int main() {<cr>}<esc>O<c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> c; cout <<  << endl;<esc>8hi<c-r>=abbr#Eatchar()<cr>

iabbr <buffer> reverse; reverse(str.begin(), str.end()); // in place, no return value<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> freopen; freopen("file", "r", stdin);<cr>while(cin >> i1 >> i2) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> freopen2; freopen("file", "r", stdin);<cr>for(string line; getline(cin, line); ) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> stringstream; stringstream ss(line);<cr>while(ss >> i1 >> i2) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline; getline(cin, line)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline2; while(getline(cin, line)) {<cr>stringstream ss(line);<cr>if(ss >> i1 >> i2)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> forv; for(const auto& x : std::vector{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> forv2; for(const auto& x : std::vector<int>{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> all_of; all_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> any_of; any_of(v.cbegin(), v.cend(), DivisibleBy(7)))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> none_of; none_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pairwise; pairwise = ranges::zip(numbers, numbers \| ranges::drop(1));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing_strictly; = ranges::adjacent_find(vec, std::greater_equal<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing; = ranges::adjacent_find(vec, std::greater<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing_strictly; = ranges::adjacent_find(vec, std::less_equal<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing; = ranges::adjacent_find(vec, std::less<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function; function<void()> f_display_42 = []() { print_num(42); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function2; function<int(int)> fac = [&](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> iterator; vector<int>::iterator it = vec.begin();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> distance; distance(v.begin(), v.end()) // returns number of hops from begin to end<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex; regex pat {R"(\s+(\w+))"};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex_iterator; for(sregex_iterator p(str.begin(), str.end(), pat); p!=sregex_iterator(); ++p) cout << (∗p)[0] << '\n';<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> smallest_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> min_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> largest_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> convert_a_SINGLE_digit_to_char; '0' + 5<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> convert_a_char_to_a_digit; ch - '0'<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> check_if_a_char_is_digit_0123456789; int std::isdigit(int ch);<c-r>=abbr#Eatchar()<cr>

# if exists(":LspDocumentSymbol") == 2
#     nnoremap <buffer> <leader>/ <cmd>LspDocumentSymbol<CR>
# endif

# if exists("g:loaded_vimcomplete")
#     g:VimCompleteOptionsSet({
#         lsp: { enable: true, maxCount: 50, priority: 11 },
#     })
# endif

# cppman to view cppreference.com documentation
# command -complete=custom,ListCppKeywords -nargs=1 Cppman :term ++close cppman <args>
# def ListCppKeywords(ArgLead: string, CmdLine: string, CursorPos: number): string
#     return system($'cppman -f {ArgLead}')
# enddef

# nnoremap <buffer> <leader>H :Cppman<space>
# cabbr <expr> hh  abbr#ExpandCmd('hh') ? 'Cppman <c-r>=abbr#abbr#Eatchar()<cr>' : 'hh'

# fuzzy search cppman
# runtime! after/ftplugin/man.vim
# if exists('g:loaded_scope')
#     import 'fuzzyscope.vim' as fuzzy
# def CppmanFind()
#     def GetItems(lst: list<dict<any>>, prompt: string): list<any>
#         if prompt->empty()
#             var items_dict = [{text: ''}]
#             return [items_dict, [items_dict]]
#         else
#             var parts = prompt->split()
#             if parts->len() == 1
#                 if prompt[prompt->len() - 1] == ' '
#                     return [lst, [lst]]
#                 else
#                     var items = system($'cppman -f {parts[0]}')->split("\n")->slice(0, 200) # max 200 items
#                     var items_dict = items->mapnew((_, v) => {
#                         return {text: v, keyword: v->slice(0, v->stridx(' '))}
#                     })
#                     return [items_dict, [items_dict]]
#                 endif
#             else # parts count > 1
#                 var pattern = parts->slice(1)->join()
#                 return [lst, lst->matchfuzzypos(pattern, {key: "keyword"})]
#             endif
#         endif
#     enddef

#     fuzzy.FilterMenuPopup.new().PopupCreate('cppreference', [],
#         (res, key) => {
#             exe $":Man {res.keyword}"
#         },
#         (winid) => {
#             win_execute(winid, 'syn match FilterMenuDirectorySubtle " - .*$"')
#             hi def link FilterMenuDirectorySubtle Comment
#         },
#         GetItems, false, &lines - 6, (&columns * 0.75)->float2nr())
# enddef
# nnoremap <buffer> <leader>fh <scriptcmd>CppmanFind()<CR>

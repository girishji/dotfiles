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

# Type 'ff; e 10<cr>' and it will insert 'for (int e = 0; e < 10; ++e) {<cr>.'
iab <buffer> ff; <c-o>:FFI
command! -nargs=* FFI call FF("int", "", <f-args>)
iab ffc; <c-o>:FFC
command! -nargs=* FFC call FF("int", "(int)", <f-args>)
iab ffs; <c-o>:FFS
command! -nargs=* FFS call FF("size_t", "", <f-args>)
def FF(type: string, cast: string, i: string, x: string)
    exe 'normal! a' .. $'for ({type} {i} = 0; {i} < {cast}{x}; ++{i}) {{'
    exe "normal o\<space>\<BS>\e"  # \e is <esc>
    exe "normal o}\ekA"
enddef

iabbr <buffer> ffi; <c-o>:FFIT
command! -nargs=* FFIT call FFIT(<f-args>)
def FFIT(a: string, it: string = "it")
    exe 'normal! a' .. $'for (auto {it} = {a}.begin(); {it} != {a}.end(); {it}++) {{'
    exe "normal o\<space>\<BS>\e"  # \e is <esc>
    exe "normal o}\ekA"
enddef

iabbr <silent><buffer> for_it; for (auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>

# Type 'all; a<cr>' and it will insert 'a.begin(), a.end(), '
iab <buffer> all; <c-o>:ALL
command! -nargs=* ALL call ALL(<f-args>)
def ALL(x: string)
    exe 'normal! a' .. $'{x}.begin(), {x}.end(), '
enddef

iabbr <silent><buffer> fori; for (int i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forj; for (int j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fork; for (int k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foriu; for (unsigned long i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forju; for (unsigned long j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forku; for (unsigned long k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fora; for (const auto& el : ) {<c-o>o}<esc>kf:la<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_it; for (auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_each; ranges::for_each(, [](int& n) {});<esc>16hi<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> max_element; ranges::max_element(<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> distance; ranges::distance(<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> r; ranges::<C-R>=abbr#Eatchar()<CR>

iabbr <silent><buffer> ul; unsigned long
iabbr <silent><buffer> ll; signed long long
iabbr <silent><buffer> vi; vector<int>
iabbr <silent><buffer> vii; vector<vector<int>>
iabbr <silent><buffer> vs; vector<string>

iabbr <silent><buffer> in; #include <bits/stdc++.h>
            \<cr>using namespace std;
            \<cr>#define F first
            \<cr>#define S second
            \<cr><cr><c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> mn; int main() {<cr>}<esc>O<c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> c; cout <<  << endl;<esc>8hi<c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> fr; first<c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> sc; second<c-r>=abbr#Eatchar()<cr>

iabbr <buffer> reverse; reverse(str.begin(), str.end()); // in place, no return value<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> freopen; freopen("file", "r", stdin);<cr>while (cin >> i1 >> i2) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> freopen2; freopen("file", "r", stdin);<cr>for (string line; getline(cin, line); ) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> stringstream; stringstream ss(line);<cr>while (ss >> i1 >> i2) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline; getline(cin, line)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline2; while (getline(cin, line)) {<cr>stringstream ss(line);<cr>if (ss >> i1 >> i2)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_vector; for (const auto& x : std::vector{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_container; for (const auto& x : std::vector<int>{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> all_of; all_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> any_of; any_of(v.cbegin(), v.cend(), DivisibleBy(7)))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> none_of; none_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pairwise; pairwise = ranges::zip(numbers, numbers \| ranges::views::drop(1));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing_strictly; = ranges::adjacent_find(vec, std::greater_equal<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing; = ranges::adjacent_find(vec, std::greater<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing_strictly; = ranges::adjacent_find(vec, std::less_equal<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing; = ranges::adjacent_find(vec, std::less<int>()) == vec.end();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function; function<void()> f_display_42 = []() { print_num(42); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function2; function<int(int)> fac = [&](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> iterator; vector<int>::iterator it = vec.begin();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> distance; distance(v.begin(), v.end()) // returns number of hops from begin to end<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex; regex pat {R"(\s+(\w+))"};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex_iterator; for (sregex_iterator p(str.begin(), str.end(), pat); p!=sregex_iterator(); ++p) cout << (∗p)[0] << '\n';<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> smallest_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> min_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> largest_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>

# float and double
iabbr <buffer> comp_zero; if (b == 0.0f) // 0.0 for double
iabbr <buffer> comp_equal; std::fabs((a / b) - (c / d)) < epsilon;<c-r>=abbr#Eatchar()<cr>

# Drop the first N
iabbr <buffer> drop; \| ranges::views::drop(N)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> drop_while; for (int n : v \| std::views::drop_while([](int i) { return i < 3; }))<c-r>=abbr#Eatchar()<cr>

# Views
iabbr <buffer> string_view; constexpr std::string_view src = " \f\n\t\r\vHello, C++20!\f\n\t\r\v ";<c-r>=abbr#Eatchar()<cr>

# Conversions and checks
iabbr <buffer> conv_SINGLE_digit_to_char; '0' + 5<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_char_to_a_digit; ch - '0'<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> check_if_char_is_digit_0123456789; int std::isdigit(int ch);<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_int_binary; bitset<32> binary(num); // num is int
iabbr <buffer> conv_int_string; string str = std::to_string(num); // num is int
iabbr <buffer> conv_int_string2; stringstream ss; ss << num; string str = ss.str();<c-r>=abbr#Eatchar()<cr>

# string
iabbr <buffer> string_iterate; for (char c : str) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> string_iterate2; for (size_t i = 0; i < str.length(); ++i) {<cr>char c = str[i];<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> string_iterate3; for (auto it = str.begin(); it != str.end(); ++it) {<cr>char c = *it;<c-r>=abbr#Eatchar()<cr>

# bitset
iabbr <buffer> bitset; std::bitset<8> bits(42);  // Binary: 00101010
            \<cr>if (bits.test(0)) cout << "Bit 0 is 1" << endl;
            \<cr>std::cout << "Number of 1 bits: " << bits.count() << std::endl;
            \<cr>std::cout << "First set bit index: " << bits._Find_first() << std::endl;
            \<cr>// use << >> & \| bit operations just like an int
iabbr <buffer> bitset_iterate; for (size_t i = 0; i < bits.size(); ++i) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> bitset_iterate2; for (bool bit : bits) {<c-r>=abbr#Eatchar()<cr>

# printing containers
iabbr <buffer> pr_container; for (const auto& el : container) { cout << el << " "; } cout << endl;<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_map; for (const auto& [key, value] : map) { cout << key << ": " << value << endl; }<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_map_container; for (const auto& [key, container] : map) {
            \<cr>cout << key << ": { ";
            \<cr>for (const auto& value : container) {
            \<cr>cout << value << " ";
            \<cr>}
            \<cr>cout << "}" << std::endl;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
# using for_each or ranges::copy is verbose
iabbr <buffer> pr_for_each; ranges::for_each(, [](const int& n) {cout << n;});cout<<endl;<esc>F(;a<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_range_copy; ranges::copy(x, ostream_iterator<int>(cout, " "));cout<<endl;<esc>Fxcw<C-R>=abbr#Eatchar()<CR>

# map iterate
iabbr <buffer> map_iterate; for (const auto& [key, value] : map) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_map; for (const auto& [key, value] : map) {<c-r>=abbr#Eatchar()<cr>

# python like defaultdict
iabbr <buffer> map_default; Value& operator[](const Key& key) {
            \<cr>if (!data.contains(key)) {
            \<cr>data[key] = default_factory(); // []() { return 0; }
            \<cr>return data[key];

# python like get (which returns a default val
iabbr <buffer> pget; auto it = map.find(key);
            \<cr>if (it != map.end()) { return it->second; }
            \<cr>return default_value;
iabbr <buffer> map_get; auto it = map.find(key);
            \<cr>if (it != map.end()) { return it->second; }
            \<cr>return default_value;

# tuple
iabbr <buffer> tuple; tuple<int, string, double> myTuple = {42, "World", 2.718};
            \<cr>auto myTuple = make_tuple(42, "World", 2.718);
            \<cr>auto [a, b, c] = myTuple;
            \<cr>cout << std::get<0>(myTuple) << endl; // 42

# pair
iabbr <buffer> pii; pair<int, int>
iabbr <buffer> pair; make_pair(<c-r>=abbr#Eatchar()<cr>

# for: break from nested loops (alternative: use a function and "return" from deeply nested loop)
iabbr <buffer> for_break; for (auto [i, stopOuter] = std::tuple{0, false}; i < 10 && !stopOuter; ++i) {
            \<cr>for (auto [j, stopMiddle] = std::tuple{0, false}; j < 10 && !stopMiddle; ++j) {
            \<cr>for (int k = 0; k < 10; ++k) {
            \<cr>if (i == 2 && j == 3 && k == 4) {
            \<cr>stopMiddle = true; // Break middle loop
            \<cr>stopOuter = true;  // Break outer loop
            \<cr>break;
            \<cr>}<c-r>=abbr#Eatchar()<cr>

# for loops with mixed type variable initialization
iabbr <buffer> for_mixed; for (auto v = make_pair(0, 'c'); v.first < 10; ++v.first) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_mixed2; for (auto v = make_tuple(0, false, 'c'); get<0>(v) < 10; ++get<0>(v)) {<c-r>=abbr#Eatchar()<cr>

# if exists(":LspDocumentSymbol") == 2
#     nnoremap <buffer> <leader>/ <cmd>LspDocumentSymbol<CR>
# endif

# if exists("g:loaded_vimcomplete")
#     g:VimCompleteOptionsSet({
#         lsp: { enable: true, maxCount: 50, priority: 11 },
#     })
# endif

vim9script

# setl path-=/usr/include

# Use 'gq', or 'gggqG<cr>' to format the whole file.
setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4,\ SpaceBeforeParens:\ false}'
# setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4}'
nnoremap <buffer> <leader>F gggqG<cr>

if exists('g:loaded_devdocs')
    nnoremap <leader>; <cmd>DevdocsFind<CR>
endif

# make and execute
# setl makeprg=clang++\ -include"$HOME/.clang-repl-incl.h"\ -std=c++23\ -stdlib=libc++\ -fexperimental-library\ -o\ /tmp/a.out\ %\ &&\ /tmp/a.out
# NOTE: brew installs gcc in /opt/homebrew/bin. Currently g++-14 is installed. Note that g++ takes you to clang, os use g++-14.
setl makeprg=g++-14\ -std=c++23\ -Wall\ -Wextra\ -Wconversion\ -DONLINE_JUDGE\ -O2\ -lstdc++exp\ -o\ /tmp/a.out\ %\ &&\ /tmp/a.out
nnoremap <buffer> <leader>m :make %<cr>
# make only (no execution) -- now you can do :cw
def MakeOnly()
    var saved = &makeprg
    try
        setl makeprg=g++-14\ -std=c++23\ -Wall\ -Wextra\ -Wconversion\ -DONLINE_JUDGE\ -O2\ -lstdc++exp\ -o\ /tmp/a.out\ %
        :make %
    finally # can also use :defer
        exec $'setl makeprg={saved}'
    endtry
enddef
nnoremap <buffer> <leader>M <scriptcmd>MakeOnly()<cr>

# Abbreviations:
# - They do not axpand after '.', so 'iabbr fr; first' for x.fr; (x.first) does not work
# - When naming, ignore vowels inless they indicate type (ex. vi; -> vector<int>)
# - Append a ';' so abbrevs are distinct and do not expand unexpectedly

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

# 'ffit' -> for (auto it ...)
iabbr <buffer> ffit; <c-o>:FFIT
command! -nargs=* FFIT call FFIT(false, <f-args>)
iabbr <buffer> ffitr; <c-o>:FFITR
command! -nargs=* FFITR call FFITR(true, <f-args>)
def FFIT(reverse: bool, a: string, it: string = "it")
    if !reverse
        exe 'normal! a' .. $'for (auto {it} = {a}.begin(); {it} != {a}.end(); {it}++) {{'
    else
        exe 'normal! a' .. $'for (auto {it} = {a}.rbegin(); {it} != {a}.rend(); {it}++) {{'
    endif
    exe "normal o\<space>\<BS>\e"  # \e is <esc>
    exe "normal o}\ekA"
enddef

iabbr <silent><buffer> forit; for (auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foritr; for (auto it = .rbegin(); it != .rend(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>

# Type 'all; a<cr>' and it will insert 'a.begin(), a.end(), '
iab <buffer> all; <c-o>:ALL
command! -nargs=* ALL call ALL(<f-args>)
def ALL(x: string)
    exe 'normal! a' .. $'{x}.begin(), {x}.end()'
enddef

# print .first and .second of a pair
iab <buffer> pr_pair; <c-o>:PRPAIR
command! -nargs=* ALL call PRPAIR(<f-args>)
def PRPAIR(x: string)
    exe 'normal! a' .. $'{x}.first << " " << {x}.second'
enddef

# for
iabbr <silent><buffer> fori; for (int i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forj; for (int j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fork; for (int k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foriu; for (unsigned long i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forju; for (unsigned long j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forku; for (unsigned long k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fora; for (const auto& el : ) {<c-o>o}<esc>kf:la<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_it; for (auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> for_each; ranges::for_each(, [](int& n) {});<esc>16hi<C-R>=abbr#Eatchar()<CR>

# Types
iabbr <silent><buffer> u64; std::uint64_t
iabbr <silent><buffer> ul; unsigned long
iabbr <silent><buffer> ll; signed long long
iabbr <silent><buffer> vi; vector<int>
iabbr <silent><buffer> vii; vector<vector<int>>
iabbr <silent><buffer> vs; vector<string>
iabbr <silent><buffer> setp; set<pair<int, int>>
iabbr <silent><buffer> sp; set<pair<int, int>>
iabbr <silent><buffer> seti; set<int>
iabbr <silent><buffer> si; set<int>
iabbr <silent><buffer> mapii; map<int, int>
iabbr <silent><buffer> mii; map<int, int>
# pair
iabbr <buffer> pii; pair<int, int>
iabbr <buffer> pair; make_pair(<c-r>=abbr#Eatchar()<cr>
# tuple
iabbr <buffer> tuple; tuple<int, string, double> myTuple = {42, "World", 2.718};
            \<cr>auto myTuple = make_tuple(42, "World", 2.718);
            \<cr>auto [a, b, c] = myTuple;
            \<cr>cout << std::get<0>(myTuple) << endl; // 42
# optional
iabbr <buffer> optional; optional<t> // takes std::nullopt also

# Convenience
iabbr <silent><buffer> in; #include <bits/stdc++.h>
            \<cr>using namespace std;
            \<cr>using u64 = std::uint64_t;
            \<cr>#define F first
            \<cr>#define S second
            \<cr><cr><c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> mn; int main() {<cr>}<esc>O<c-r>=abbr#Eatchar()<cr>
iabbr <silent><buffer> c; cout <<  << endl;<esc>8hi<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_iota; for (auto _ : views::iota(0, 10)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_iota2; for (int i : views::iota(1) \| views::take(9)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_iota3; ranges::for_each(views::iota(0, 10), [](int i) { cout << i << ' '; });<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_iota4; for (auto _ : views::iota(0) \| rv::take(5)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> iota; auto square_view = views::iota(0)  // infinite range
            \<cr>\| views::transform(square)  // auto square = [](int x) {return x*x;};
            \<cr>\| views::take(5);
iabbr <buffer> for_reverse; for (auto i : views::iota(0, 9) \| views::reverse) {<c-r>=abbr#Eatchar()<cr>

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
iabbr <buffer> pairwise; pairwise = ranges::zip(numbers, numbers \| views::drop(1));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing_strictly; = ranges::adjacent_find(vec, std::greater_equal<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing; = ranges::adjacent_find(vec, std::greater<int>()) == vec.end()// see ..fn_obj less_equal;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing_strictly; = ranges::adjacent_find(vec, std::less_equal<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing; = ranges::adjacent_find(vec, std::less<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> recursive_lambda; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> lambda_recursive; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> iterator; vector<int>::iterator it = vec.begin();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> distance; distance(v.begin(), v.end()) // returns number of hops from begin to end<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex; regex pat {R"(\s+(\w+))"};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex_iterator; for (sregex_iterator p(str.begin(), str.end(), pat); p!=sregex_iterator(); ++p) cout << (∗p)[0] << '\n';<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> smallest_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> min_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> largest_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>

# Misc
iabbr <buffer> using; using in_list_t = std::list<int>;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> struct; struct disk_element {<cr>int id{ -1 };<cr>};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> lambda; auto fn = [&x, *y](int x) -> char { }<cr>};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_element; ranges::max_element(<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> distance; ranges::distance(<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> r; ranges::<C-R>=abbr#Eatchar()<CR>

# float and double
iabbr <buffer> comp_zero; if (b == 0.0f) // 0.0 for double
iabbr <buffer> comp_equal; std::fabs((a / b) - (c / d)) < epsilon;<c-r>=abbr#Eatchar()<cr>

# Drop/Take the first N
iabbr <buffer> drop; \| views::drop(N)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> drop_while; for (int n : v \| std::views::drop_while([](int i) { return i < 3; }))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> take; \| views::take(N)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> take_while; for (int n : v \| std::views::take_while([](int i) { return i < 3; }))<c-r>=abbr#Eatchar()<cr>

# Views, complete views:: in dictionary
iabbr <buffer> string_view; constexpr std::string_view src = " \f\n\t\r\vHello, C++20!\f\n\t\r\v ";<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> map_values; map \| views::values<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> map_keys; map \| views::keys<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> split_smth; views::split(word, delim) // see doc views::split<c-r>=abbr#Eatchar()<cr>

# Conversions and checks
iabbr <buffer> conv_SINGLE_digit_to_char; '0' + 5<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_char_to_a_digit; ch - '0'<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> check_if_char_is_digit_0123456789; int std::isdigit(int ch);<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_int_binary; bitset<32> binary(num); // num is int
iabbr <buffer> conv_int_string; string str = std::to_string(num); // num is int
iabbr <buffer> conv_int_string2; stringstream ss; ss << num; string str = ss.str();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_str_int; stoi(str)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_str_int2; istringstream(str) >> num;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_str_ull; stoull(str)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_str_int2; istringstream(str) >> ulongnum;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> conv_str_chars; while (auto ch : str) OR vector<char>(s.begin(), s.end())<c-r>=abbr#Eatchar()<cr>
# convert a view to a container
iabbr <buffer> conv_view_container; auto squared = numbers // a vector
            \<cr>\| views::transform( [](int n) { return n * n; } )
            \<cr>\| ranges::to<std::deque>();
iabbr <buffer> ranges_to; ranges::to<std::deque>();

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
iabbr <buffer> pr_cont; for (const auto& el : container) { cout << el << " "; }; cout << endl;<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_map; for (const auto& [key, value] : map) { cout << key << ": " << value << endl; }<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_map_cont; for (const auto& [key, container] : map) {
            \<cr>cout << key << ": { ";
            \<cr>for (const auto& value : container) {
            \<cr>cout << value << " ";
            \<cr>}
            \<cr>cout << "}" << std::endl;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_vec_cont; for (const auto& cont : vec_cont) {
            \<cr>cout << "{ ";
            \<cr>for (const auto& value : cont) {
            \<cr>cout << value << " ";
            \<cr>}
            \<cr>cout << "}" << std::endl;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
# using for_each or ranges::copy is verbose
iabbr <buffer> pr_for_each; ranges::for_each(, [](const int& n) {cout << n;});cout<<endl;<esc>F(;a<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_range_copy; ranges::copy(x, ostream_iterator<int>(cout, " "));cout<<endl;<esc>Fxcw<C-R>=abbr#Eatchar()<CR>
# using views and std::print
iabbr <buffer> pr; print("{}\n", );<left><left><c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_view; print("{}\n", views::zip(v1, v2) OR v2 \| views::pairwise);<c-r>=abbr#Eatchar()<cr>

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
# iabbr <buffer> for_mixed; for (auto v = make_pair(0, 'c'); v.first < 10; ++v.first) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_mixed; for (auto v = pair{0, 'c'}; v.first < 10; ++v.first) {<c-r>=abbr#Eatchar()<cr>
# iabbr <buffer> for_mixed2; for (auto v = make_tuple(0, false, 'c'); get<0>(v) < 10; ++get<0>(v)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_mixed2; for (auto v = tuple{0, false, 'c'}; get<0>(v) < 10; ++get<0>(v)) {<c-r>=abbr#Eatchar()<cr>

# swap
# Swaps the values of the elements the given iterators are pointing to.
iabbr <buffer> swap_iter_contents; iter_swap(it1, it2);<c-r>=abbr#Eatchar()<cr>
# Swaps the values a and b. Or Swaps the arrays a and b. Equivalent to std::swap_ranges(a, a + N, b).
# a, b = b, a  (like in python)
iabbr <buffer> swap; swap(a, b); // a, b are int or array<c-r>=abbr#Eatchar()<cr>
# Exchanges elements between range [first1, last1) and another range of std::distance(first1, last1) elements starting at first2
iabbr <buffer> swap_range; swap_ranges(v.begin(), v.begin() + 3 (// end of range), l.begin());<c-r>=abbr#Eatchar()<cr>

# Exchange/swap values while modifying also
# i, j = j, -i -> so that if you start with (0, 1), you get all 4 directions in 2D space.
# tie() just uses references, otherwise like swap() which uses copies
# int i = 4, j = 8;
iabbr <buffer> swap_modify; tie(i, j) = tuple{j, -i};<c-r>=abbr#Eatchar()<cr>

# iterator: do not do (map.end() - 1), but std::prev(map.end())
iabbr <buffer> it_prev; prev(m.end());
iabbr <buffer> it_prev2; prev2(m.end(), 2);
iabbr <buffer> it_next; next(m.begin());
iabbr <buffer> it_next2; next(m.begin(), 2);

# reduce, fold_left, accumulate
# reduce, accumulate -> difference is that reduce can be parallelized (out of order execution)
# Caution: both reduce and accumulate do not evaluate 'unsigned long long' correctly. Don't use them.
iabbr <buffer> fold_left; ranges::fold_left(v, 0, [](){})<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> fold_left_; int sum = std::ranges::fold_left(v.begin(), v.end(), 0, std::plus<int>());
            \<cr>int mul = std::ranges::fold_left(v, 1, std::multiplies<int>()); // (2)
            \<cr>std::vector<std::pair<char, float>> data {{'A', 2.f}, {'B', 3.f}, {'C', 3.5f}};
            \<cr>// get the product of the std::pair::second of all pairs in the vector:
            \<cr>float sec = std::ranges::fold_left(data \| std::ranges::views::values, 2.0f, std::multiplies<>());
            \<cr>std::string str = std::ranges::fold_left(v, "A", [](std::string s, int x) { return s + ':' + std::to_string(x); });
# iabbr <buffer> accumulate; accumulate(myMap.begin(), myMap.end(), 0,
#             \<cr>[](int sum, const auto& pair) { return sum + pair.first; } );<c-r>=abbr#Eatchar()<cr>
# iabbr <buffer> reduce; reduce(myMap.begin(), myMap.end(), 0,
#             \<cr>[](int sum, const auto& pair) { return sum + pair.first; } );<c-r>=abbr#Eatchar()<cr>
# T transform_reduce( ExecutionPolicy&& policy,
#                    ForwardIt first, ForwardIt last, T init,
#                    BinaryOp reduce, UnaryOp transform );
# iabbr <buffer> transform_reduce; transform_reduce(
#             \<cr>myMap.begin(), myMap.end(), 0,
#             \<cr>std::plus<>(),
#             \<cr>[](const auto& pair) { return pair.first; } );<c-r>=abbr#Eatchar()<cr>

# Operators (to cout and cin)
iabbr <buffer> op<< friend std::ostream& operator<<(std::ostream& os, const MyStruct& obj) {
            \<cr>os << obj.x << " " << obj.y;
            \<cr>return os;<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> op>> friend std::istream& operator>>(std::istream& is, MyStruct& obj) {
            \<cr>is >> obj.x >> obj.y;
            \<cr>return is;<cr>}<c-r>=abbr#Eatchar()<cr>

# Templates
iabbr <buffer> templ_typename; template<typename T>
            \<cr>class Less_than {
            \<cr>const T val; // value to compare against
iabbr <buffer> templ_val; template<int N>
            \<cr>auto blink = [](int foo) -> u64 {
            \<cr>for (auto _ : flux::ints(0, N)) {}};
            \<cr>auto const part1 = blink<25>;

# Algorithms
# (0, 0), (0, 1), (0, 2), ... (1, 0), (1, 1), ...
iabbr <buffer> product; views::cartesian_product(views::iota(0, m), views::iota(0, n))<c-r>=abbr#Eatchar()<cr>
# emulates 2 loops: for (i = 0; i < m; i++) { for (j = 0; j < n; j++) ...
iabbr <buffer> for2loops; for (auto [i, j] : views::cartesian_product(views::iota(0, m), views::iota(0, n))) {<c-r>=abbr#Eatchar()<cr>
# emulates 2 loops: for (i = 0; i < m; i++) { for (j = 0; j < n; j++) ...
# iabbr <buffer> for2loops_; for (int k = 0; k < m * n; ++k)<c-r>=abbr#Eatchar()<cr>


vim9script

# setl path-=/usr/include

# Use 'gq', or 'gggqG<cr>' to format the whole file.
setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4,\ SpaceBeforeParens:\ false}'
# setl formatprg=clang-format\ -style='{BasedOnStyle:\ Google,\ IndentWidth:\ 4}'
nnoremap <buffer> <leader>F gggqG<cr>

# make and execute
# setl makeprg=clang++\ -include"$HOME/.clang-repl-incl.h"\ -std=c++23\ -stdlib=libc++\ -fexperimental-library\ -o\ /tmp/a.out\ %\ &&\ /tmp/a.out
#
# NOTE: brew installs gcc in /opt/homebrew/bin. Currently g++-14 is installed.
#       Note that g++ is linked to clang, so use g++-14.
#
nnoremap <buffer> <leader>M :setl makeprg=sh\ -c\ \"g++-14\ -std=c++23\ -Wall\ -Wextra\ -Wconversion\ -DONLINE_JUDGE\ -O2\ -lstdc++exp\ -o\ /tmp/a.out\ %\ \&\&\ /tmp/a.out\"<cr>:make %<cr>
nnoremap <buffer> <leader>m :setl makeprg=sh\ -c\ \"g++-14\ -std=c++23\ -Wall\ -Wextra\ -Wconversion\ -DONLINE_JUDGE\ -O2\ -lstdc++exp\ -o\ /tmp/a.out\ %\"<cr>:make %<cr>

# Abbreviations:
# - When naming, ignore vowels inless they indicate type (ex. vi; -> vector<int>)
# - Appending a ';' is problematic, since it is not a keyword. abbrev will not
#   expand if there is '(' or '.' before the abbrev. So use ';' in cases where
#   there is bound to be a space before abbrev.

# Type 'ff; e 10<cr>' and it will insert 'for (int e = 0; e < 10; ++e) {<cr>.'
iab <buffer> ff; <c-o>:FFI
command! -nargs=* FFI call FF("int", "", <f-args>)
iab <buffer> ffc; <c-o>:FFC
command! -nargs=* FFC call FF("int", "(int)", <f-args>)
iab <buffer> ffs; <c-o>:FFS
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

# Type 'all; a<cr>' and it will insert 'a.begin(), a.end(), '
# iab <buffer> all; <c-o>:ALL
# command! -nargs=* ALL call ALL(<f-args>)
# def ALL(x: string)
#     exe 'normal! a' .. $'{x}.begin(), {x}.end()'
# enddef
iabbr <buffer> alle .begin(), .end()<esc>BBi<C-R>=abbr#Eatchar()<CR>

# for
iabbr <silent><buffer> fori; for (int i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forj; for (int j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fork; for (int k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foriu; for (unsigned long i = 0; i < ; i++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forju; for (unsigned long j = 0; j < ; j++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forku; for (unsigned long k = 0; k < ; k++) {<c-o>o}<esc>kf;;i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> fora; for (const auto& el : ) {<c-o>o}<esc>kf:la<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foreach; ranges::for_each(, [](int& n) {});<esc>16hi<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> forit; for (auto it = .begin(); it != .end(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>
iabbr <silent><buffer> foritr; for (auto it = .rbegin(); it != .rend(); it++) {<c-o>o}<esc>kf.i<C-R>=abbr#Eatchar()<CR>


# Types
# iabbr <silent><buffer> u64 std::uint64_t
# iabbr <silent><buffer> ul unsigned long
# iabbr <silent><buffer> ll signed long long
iabbr <silent><buffer> vi; vector<int>
iabbr <silent><buffer> vvi; vector<vector<int>>
iabbr <silent><buffer> vs; vector<string>
iabbr <silent><buffer> vpii; vector<pair<int, int>>
iabbr <silent><buffer> setp; set<pair<int, int>>
iabbr <silent><buffer> seti; set<int>
iabbr <silent><buffer> si; set<int>
iabbr <silent><buffer> mapii; map<int, int>
iabbr <silent><buffer> mii; map<int, int>
# pair
iabbr <buffer> pii pair<int, int><c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pss pair<string, string><c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pair; make_pair(<c-r>=abbr#Eatchar()<cr>
# tuple
iabbr <buffer> tiic; tuple<int, int, char><c-r>=abbr#Eatchar()<cr>
iabbr <buffer> tccc; tuple<char, char, char><c-r>=abbr#Eatchar()<cr>
iabbr <buffer> tuple; tuple<int, string, double> myTuple = {42, "World", 2.718};
            \<cr>auto myTuple = make_tuple(42, "World", 2.718);
            \<cr>auto [a, b, c] = myTuple;
            \<cr>cout << std::get<0>(myTuple) << endl; // 42
# optional
iabbr <buffer> optional; std::optional<std::vector<int>> functionWithOptionalVector() {
            \<cr>if (some_condition) {
            \<cr>return std::vector<int>{1, 2, 3};
            \<cr>}
            \<cr>return std::nullopt; <cr>}
            \<cr>// Checking if a value exists
            \<cr>if (maybeInt1) {
            \<cr>std::cout << "Has value: " << *maybeInt1 << std::endl; <CR> }
            \<cr>// Throws if no value
            \<cr>int value = maybeInt1.value();
            \<cr>// Safe access with default
            \<cr>int safeValue = maybeInt1.value_or(0);

# Convenience
iabbr <silent><buffer> in; #include <bits/stdc++.h>
            \<cr>using namespace std;
            \<cr>using namespace std::string_view_literals;
            \<cr>namespace rg = std::ranges;
            \<cr>namespace rv = std::ranges::views;
            \<cr>using i64 = std::int64_t;
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
iabbr <buffer> istringstream; istringstream iss(line);<cr>while (iss >> i1 >> i2) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline; getline(cin, line)<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> getline2; while (getline(cin, line)) {<cr>stringstream ss(line);<cr>if (ss >> i1 >> i2)<c-r>=abbr#Eatchar()<cr>
# iabbr <buffer> for_vector; for (const auto& x : std::vector{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_vector; for (const auto& x : {1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_container; for (const auto& x : std::vector<int>{1, 2}) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> all_of; all_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> any_of; any_of(v.cbegin(), v.cend(), DivisibleBy(7)))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> none_of; none_of(v.cbegin(), v.cend(), [](int i) { return i % 2 == 0; }));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pairwise; pairwise = views::zip(numbers, numbers \| views::drop(1));<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> zip; pairwise = views::zip(<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing_strictly; = ranges::adjacent_find(vec, std::greater_equal<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> increasing; = ranges::adjacent_find(vec, std::greater<int>()) == vec.end()// see ..fn_obj less_equal;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing_strictly; = ranges::adjacent_find(vec, std::less_equal<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> decreasing; = ranges::adjacent_find(vec, std::less<int>()) == vec.end();// see ..fn_obj less_equal<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> function; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> recursive_lambda; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> lambda_recursive; function<int(int)> fac = [&fac](int n) { return (n < 2) ? 1 : n * fac(n - 1); };<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> iterator; vector<int>::iterator it = vec.begin();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> distance; distance(v.begin(), v.end()) // returns number of hops from begin to end<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> smallest_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> min_int; std::numeric_limits<int>::min();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> largest_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_int; std::numeric_limits<int>::max();<c-r>=abbr#Eatchar()<cr>

# Math
iabbr <buffer> abs; std::abs(<c-r>=abbr#Eatchar()<cr>

# Misc
iabbr <buffer> using; using in_list_t = std::list<int>;<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> struct; struct disk_element {<cr>int id{ -1 };<cr>};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> lambda; auto fn = [&x, *y](int x) -> char { }<cr>};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> max_element; ranges::max_element(<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> max_element2; auto maxPair = *std::ranges::max_element(myMap, [](const auto& a, const auto& b) {
            \<cr>return a.second < b.second; // Compare by map values
            \<cr>});
            \<cr>cout << "Key with the maximum value: " << maxPair.first << endl;
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
iabbr <buffer> split_str2; views::split(word, delim_sv)
            \<cr>constexpr auto delim{"^_^"sv};
            \<cr>for (const auto word : std::views::split(words, delim))
            \<cr>string s(string_view{word});
            \<cr>std::cout << std::quoted(std::string_view(word)) << ' ';
            \<cr>if (isdigit(string_view(word).front()))
            \<cr>prog.push_back(stoi(string_view(word).data()));
iabbr <buffer> split_str; istringstream iss(line);
            \<cr>string fr, to;
            \<cr>getline(iss, fr, '-');  // delim has to be char (not string)
            \<cr>while(getline(iss, fr, '-')) {
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
iabbr <buffer> conv_char_string; s += ch; string(1, ch); s.push_back(ch);

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
iabbr <buffer> prcnt; for (const auto& t : ) { cout << t << " "; }; cout << endl;<esc>12Bi<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_cont; for (const auto& el : ) { cout << el << " "; }; cout << endl;<esc>12Bi<C-R>=abbr#Eatchar()<CR>
iabbr <buffer> pr_map; for (const auto& [key, value] : ) { cout << key << ": " << value << endl; }<esc>12Bi<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_map_cont; for (const auto& [key, container] : map) {
            \<cr>cout << key << ": { ";
            \<cr>for (const auto& value : container) {
            \<cr>cout << value << " ";
            \<cr>}
            \<cr>cout << "}" << std::endl;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_vec_vec; for (const auto& cont : vec_cont) {
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
# pair (place this outside main()) - it is in global namespace
iabbr <buffer> pr_pair_fn; std::ostream& operator<<(std::ostream& os, const std::pair<int, int>& p) {
            \<cr>os << '(' << p.first << ", " << p.second << ')';
            \<cr>return os;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> pr_vector_fn; template<typename T>
            \<cr>std::ostream& operator<<(std::ostream& os, const std::vector<T>& v) {
            \<cr>ranges::for_each(v, [&os](const T& n) { os << n << " "; });
            \<cr>return os;
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> format; cout << format("{} {}\n", x, y);

# operator
iabb <buffer> operator_plus; pair<int, int> operator+(const pair<int, int>& lhs, const pair<int, int>& rhs) {
            \<cr>return make_pair(lhs.first + rhs.first, lhs.second + rhs.second);
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabb <bufer> operator_mult; pair<int, int> operator*(const pair<int, int>& l, int n) {
            \<cr>return make_pair(l.F * n, l.S * n);
            \<cr>}<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> operator<<; std::ostream& operator<<(std::ostream& os, const std::pair<int, int>& p) {
            \<cr>os << '(' << p.first << ", " << p.second << ')';
            \<cr>return os;
            \<cr>}<c-r>=abbr#Eatchar()<cr>

# map
iabb <buffer> map_init; map<std::string, int> ages = { {"Alice", 30}, {"Bob", 25}, {"Charlie", 35} };

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
iabbr <buffer> swap_modify2; swap(i, j), j = -j<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> swap_modify; tie(i, j) = tuple{j, -i};<c-r>=abbr#Eatchar()<cr>

# iterator: do not do (map.end() - 1), but std::prev(map.end())
iabbr <buffer> it_prev; prev(m.end());
iabbr <buffer> it_prev2; prev2(m.end(), 2);
iabbr <buffer> it_next; next(m.begin());
iabbr <buffer> it_next2; next(m.begin(), 2);

# reduce, fold_left, accumulate
# reduce, accumulate -> difference is that reduce can be parallelized (out of order execution)
# Caution: both reduce and accumulate do not evaluate 'unsigned long long' correctly. Don't use them.
iabbr <buffer> reduce; use fold_left
iabbr <buffer> fold_left; ranges::fold_left(v, 0, [](int acc, const pair<int, int>& (or auto&) cur) {
            \<cr>return acc + cur...; (or return std::max(acc, cur);)
            \<cr>})<c-r>=abbr#Eatchar()<cr>
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
#
# cartesian_product
# (0, 0), (0, 1), (0, 2), ... (1, 0), (1, 1), ...
iabbr <buffer> product; views::cartesian_product(views::iota(0, m), views::iota(0, n))<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> cartesian_product; views::cartesian_product(views::iota(0, m), views::iota(0, n))<c-r>=abbr#Eatchar()<cr>
# emulates 2 loops: for (i = 0; i < m; i++) { for (j = 0; j < n; j++) ...
iabbr <buffer> for2loops; for (auto [i, j] : views::cartesian_product(views::iota(0, m), views::iota(0, n))) {<c-r>=abbr#Eatchar()<cr>
# emulates 2 loops: for (i = 0; i < m; i++) { for (j = 0; j < n; j++) ...
# iabbr <buffer> for2loops_; for (int k = 0; k < m * n; ++k)<c-r>=abbr#Eatchar()<cr>
#
# Iterate over unique keys (elements) in a sorted range
iabbr <buffer> for_uniqe_keys; for (auto it = p.begin(); it != p.end();
            \<cr>it = ranges::upper_bound(it, p.end(), it->first, {}, &plot_loc_t::first)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_uniqe_keys2; for (auto it = data.begin(); it != data.end();
            \<cr>it = ranges::upper_bound(it, data.end(), *it)) {<c-r>=abbr#Eatchar()<cr>
# Iterate over subrange of identical keys in a sorted range
iabbr <buffer> for_subrange_equal_key; for (const auto& el : ranges::equal_range(p, it->first, {}, &plot_loc_t::first)) {<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> for_subrange_equal_key2; for (auto& el : ranges::equal_range(data, key)) {<c-r>=abbr#Eatchar()<cr>

# Sort using projection, pair.first
iabbr <buffer> sort_projection; pair<int, int> v; ranges::sort(v, {}, &pair<int, int>::first);<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> sort_projection2; pair<int, int> v; ranges::sort(v, ranges::less{}, &pair<int, int>::first);<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> sort_descending_projection; pair<int, int> v; ranges::sort(v, ranges::greater{}, &pair<int, int>::first);<c-r>=abbr#Eatchar()<cr>

# regex
iabbr <buffer> regex; smatch matches;
            \<cr>regex pat {R"(\w{2}\s∗\d{5}(−\d{4})?)"};
            \<cr>if (regex_search(line, matches, pat)) {
            \<cr>cout << lineno << ": " << matches[0] << '\n'; // the complete match
            \<cr>if (1<matches.size() && matches[1].matched) // if there is a sub-pattern
            \<cr>int x = std::stoi(matches[1].str());
iabbr <buffer> regex2; regex pat {R"(\s+(\w+))"};<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex_iterator; for (sregex_iterator p(str.begin(), str.end(), pat); p!=sregex_iterator(); ++p) cout << (∗p)[0] << '\n';<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> regex_array; vector<regex> pat{
            \<cr>regex(R"(Button A: X\+(\d+), Y\+(\d+))"),
            \<cr>regex(R"(Button B: X\+(\d+), Y\+(\d+))")};

# concat
iabbr <buffer> concat_vec; vec1.insert(vec1.end(), vec2.begin(), vec2.end());<c-r>=abbr#Eatchar()<cr>
iabbr <buffer> concat_vec2; copy(vec.begin(),vec.end(),back_inserter(res)); // append to res
iabbr <buffer> concat_vec3; unique_copy(vec.begin(),vec.end(),back_inserter(res)); // append to res
iabbr <buffer> concat_str; s1 = s1 + s2;<c-r>=abbr#Eatchar()<cr>

# find
iabbr <buffer> find_ranges; // find searches for an element equal to value (using operator==).
            \<cr>if (ranges::find(v, 5) != v.end())
            \<cr>std::cout << "v contains: 5" << '\n';
iabbr <buffer> find_if_ranges; // find_if searches for an element for which predicate p returns true.
            \<cr>auto indices = views::cartesian_product(views::iota(0, 4), views::iota(0, 5));
            \<cr>auto it = std::ranges::find_if(indices, [&](const auto& idx) { // use 'auto', not pair<int,int>
            \<cr>auto [i, j] = idx;
            \<cr>return matrix[i][j] == target;
            \<cr>});
            \<cr>if (it != indices.end()) cout << *it;
iabbr <buffer> find_if_not_ranges; // find_if_not searches for an element for which predicate q returns false.
            \<cr>// see find_if_ranges

# join vector into a string
iabbr <buffer> join_vec_str2 ostringstream oss;
            \<cr>ranges::copy(numbers, ostream_iterator<int>(oss, ","));
            \<cr>string s = oss.str(); oss.pop_back();
iabbr <buffer> join_vec_str; ostringstream oss;
            \<cr>for (const auto& n : vec) { oss << n << ","; };
            \<cr>string s = oss.str(); oss.pop_back();

# slice vector
iabbr <buffer> slice_vec; vector<int>(vec.begin() + i, vec.begin() + j)

# min max
iabbr <buffer> min; ranges::min() ranges::min({"foo"sv, "bar"sv, "hello"sv}, {}, &std::string_view::size)
            \<cr>min( const T& a, const T& b, Comp comp = {}, Proj proj = {} );
            \<cr>ranges::min(1, 9999)
            \<cr>ranges::min('a', 'b')
iabbr <buffer> max; ranges::max() ranges::max({"foo"sv, "bar"sv, "hello"sv}, {}, &std::string_view::size)
            \<cr>max( const T& a, const T& b, Comp comp = {}, Proj proj = {} );
            \<cr>ranges::max(1, 9999)
            \<cr>ranges::max('a', 'b')


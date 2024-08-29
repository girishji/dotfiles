#include <iostream>
#include <string>
#include <string_view>
// #include <list>
#include <vector>
#include <utility>  // for 'pair' and 'tuple'
#include <fstream>
#include <map>
#include <set>
#include <deque>
#include <unordered_map>
#include <unordered_set>
// #include <stack>
#include <algorithm>
#include <iterator>
#include <ranges>

using namespace std;
using namespace std::literals::string_literals;  // can convert 'const char[]' to string: "foo"s
using namespace std::literals::string_view_literals;  // can use string_view: "foo"sv

// namespace rv = std::ranges::views;  // shortcut

// constexpr float min = numeric_limits<float>::min(); // smallest positive float

typedef signed long long ll;

// #undef _P
// #define _P(...) (void)printf(__VA_ARGS__)
// #define FOR(x,to) for(x=0;x<(to);x++)
// #define FORR(x,arr) for(auto& x:arr)
// #define ITR(x,c) for(__typeof(c.begin()) x=c.begin();x!=c.end();x++)
// #define ALL(a) (a.begin()),(a.end())
#define ZERO(a) memset(a,0,sizeof(a))
#define MINUS(a) memset(a,0xff,sizeof(a))

/* A simple range check adapter for vector (from A Tour of C++). Otherwise,
 * out-of-bounds when using [] will place garbage value without giving error.
 */
// template<typename T>
// class Vec : public std::vector<T> { 
//     public:
//         using vector<T>::vector; // use the constructors from vector (under the name Vec) 

//         T& operator[](int i) // range check
//         { return vector<T>::at(i); }

//         const T& operator[](int i) const 
//         { return vector<T>::at(i); } // range check const objects
// };

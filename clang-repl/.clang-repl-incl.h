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
#include <stack>
#include <algorithm>
#include <iterator>
#include <ranges>

using namespace std;
using namespace std::literals::string_literals;  // can convert 'const char[]' to string: "foo"s
using namespace std::literals::string_view_literals;  // can use string_view: "foo"sv

constexpr int IMIN = numeric_limits<int>::min(); // smallest positive int
constexpr int IMAX = numeric_limits<int>::max();
constexpr long long LMIN = numeric_limits<long long>::min();
constexpr long long LMAX = numeric_limits<long long>::max();

typedef signed long long ll;
typedef vector<int> vi;
typedef vector<vector<int>> vii;
typedef pair<int,int> pi;

// #define F first
// #define S second
#define PB push_back
#define MP make_pair
#define FOR(i,a,b) for (int i = (a); i <= (b); i++)
#define FORREV(i,a,b) for (int i = (a); i <= (b); i--)
// #define FOR(x,to) for(x=0;x<(to);x++)
#define FORR(x,arr) for(auto& x:arr)
#define ITR(x,c) for(__typeof(c.begin()) x=c.begin();x!=c.end();x++)
#define ALL(a) (a.begin()),(a.end())
// #define ZERO(a) memset(a,0,sizeof(a))
// #define MINUS(a) memset(a,0xff,sizeof(a))

// find type of a variable
// ex:
//   vector<string> v{"hello", " "};
//   TYPEOF(v);
// https://stackoverflow.com/questions/81870/is-it-possible-to-print-a-variables-type-in-standard-c
//
#define TYPEOF(v) (cout << type_name<decltype(v)>() << endl)
template <class T>
constexpr std::string_view type_name()
{
    using namespace std;
    string_view p = __PRETTY_FUNCTION__;
    return string_view(p.data() + 34, p.size() - 34 - 1);
}


// #undef _P
// #define _P(...) (void)printf(__VA_ARGS__)

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

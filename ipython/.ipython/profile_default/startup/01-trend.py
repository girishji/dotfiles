# Jesse Livermore: How to Trade in Stocks

from enum import Enum
import math

class Color:
    CYAN            = '\033[36m'
    WHITE           = '\033[37m'
    GREEN           = '\033[92m'
    YELLOW          = '\033[93m'
    RED             = '\033[91m'
    ENDC            = '\033[0m'
    BOLD            = '\033[1m'
    ITALIC          = '\033[3m'
    UNDERLINE       = '\033[4m'
    RED_UNDERLINE   = '\033[4;58:5:202m'  # 202 is orange-red
    WHITE_UNDERLINE = '\033[4;58:5:255m'  # 255 is white
    RED_BOLD        = '\033[1;31m'

# class Trend:

#     self.Columns = ['Date', 'SecondaryRally', 'NaturalRally', 'UpwardTrend',
#                    'DownwardTrend', 'NaturalReaction', 'SecondaryReaction']

#     def display(self, rec):
#         cell = '{:>18}'
#         hformat = Color.BOLD + cell * (len(Columns)) + Color.ENDC
#         print(hformat.format(*Columns))
#         rformat = cell + Color.WHITE + cell * 2 + Color.ENDC + cell + Color.RED + cell + Color.ENDC + Color.WHITE + cell * 2 + Color.ENDC
#         for strs in rec:
#             print(rformat.format(*(strs[1:])))


# def _do_trend(symbol, period):

#     def rec_append(*args):
#         for col in range(len(Columns)):
#             record[col].append(args[col])

#     C = Enum('Column', Columns)
#     record = [[None] for _ in range(len(Columns))]
#     max_volatility = 0.2  # ±20% allowed in natural oscillation of prices
#     price = daily(symbol, period)
#     chart = {'date': [], 'price': []}

#     # look for breakout above/below trading range
#     for ndays in range(2, len(price)):
#         high = max(float(price[i]['high']) for i in range(ndays))
#         low = min(float(price[i]['low']) for i in range(ndays))
#         price_delta = max_volatility * low
#         if (high - low) >= price_delta:
#             start = ndays
#             last_high = price[ndays - 1]['high']
#             last_low = price[ndays - 1]['low']
#             chart['date'].append(args[0])
#             if math.isclose(high, float(last_high), rel_tol=1e-5):
#                 rec_append(price[ndays - 1]['day'], '', '', last_high, '', '', '')
#                 chart['price'].append(last_high)
#             elif math.isclose(low, float(last_low), rel_tol=1e-5):
#                 rec_append(price[ndays - 1]['day'], '', '', '', last_low, '', '')
#                 chart['price'].append(last_low)
#             else:
#                 raise ValueError
#             break
#     else:
#         print('Breakout price not found')
#         return

#     # establish key prices
#     # for day in range(start, len(price)):



# # Trend is best evaluated for a group, with 2 stocks.
# # ex. trend('aapl', 'msft', 200)
# def trend(*args):
#     if len(args) < 1:
#         return
#     if args[-1].isnumeric():
#         period = args[-1]
#         symbols = args[:-1]
#     else:
#         period = None
#         symbols = args
#     record = {sym: _do_trend(sym, period) for sym in symbols}
#     for sym in record:
#         _display(record[sym])

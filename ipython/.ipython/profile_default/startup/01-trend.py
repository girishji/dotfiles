# Jesse Livermore: How to Trade in Stocks

from enum import Enum

# ESC[38;5;{ID}m	Set foreground color.
ENDC            = '\033[0m'
RED             = '\033[38;5;196m'
GRAY            = '\033[38;5;100m'
WHITE           = '\033[38;5;255m'
GREEN           = '\033[38;5;82m'
RED_UL          = '\033[4;58:5:196m'
WHITE_UL        = '\033[4;58:5:255m'
GREEN_UL        = '\033[4;58:5:82m'
BLACK_UL        = '\033[4;58:5:233m'


# look for breakout above/below trading range
# tolerance: % above resistance or below support
def _breakout(df, tolerance = 20):
    prev_high, prev_low = df.loc[df.index[0], ['high', 'low']]
    for idx, day in enumerate(df.index[1:]):
        high, low = df.loc[day, ['high', 'low']]
        if high > prev_high * (1 + tolerance / 100):
            return idx + 1, 'UpwardTrend', high
        if low < prev_low * (1 - tolerance / 100):
            return idx + 1, 'DownwardTrend', low
        prev_high = max(prev_high, high)
        prev_low = min(prev_low, low)
    print('Breakout price not found')
    raise ValueError


def _colorize(s, color, ul_color = None, underline = False):
    if ul_color:
        return color + (ul_color + s) if underline else (s + ul_color) + ENDC
    else:
        return color + s + ENDC


def _update(ledger, day, price, state, underline = False):
    if state == 'DownwardTrend':
        ledger.at[day, state] = _colorize(str(price), RED, GREEN_UL, underline)
    elif state == 'UpwardTrend':
        ledger.at[day, state] = _colorize(str(price), GREEN_, RED_UL, underline)
    elif state == 'NaturalReaction':
        ledger.at[day, state] = _colorize(str(price), GRAY, RED_UL, underline)
    elif state == 'NaturalRally':
        ledger.at[day, state] = _colorize(str(price), GRAY, GREEN__UL, underline)
    else:
        ledger.at[day, state] = _colorize(str(price), GRAY)


def trend(symbol, period = 200, tolerance = 20):
    df = get_daily_data(symbol, period)
    Columns = [
        _colorize('SecondaryRally', GRAY),
        _colorize('NaturalRally', GRAY, GREEN__UL),
        _colorize('UpwardTrend', GREEN_, RED_UL),
        _colorize('DownwardTrend', RED, GREEN__UL),
        _colorize('NaturalReaction', GRAY, RED_UL),
        _colorize('SecondaryReaction', GRAY)
        ]
    ledger = pd.DataFrame('', index=df.index, columns=Columns)
    day_idx, prev_state, prev_price = _breakout(df)
    _update(ledger, df.index[day_idx], prev_price, prev_state)
    prev_rec_day = df.index[day_idx]
    # State = Enum('State', Columns)
    # LEntry = namedtuple('LEntry', 'day price state')
    # prev = Entry(df.index[0], df.at[df.index[0], 'low'])
    # ledger.at[df.index[0], 'UpwardTrend'] = prev.price

    for day in df.index[day_idx + 1:]:
        high, low = df.loc[day, ['high', 'low']]
        match prev_state:
            case 'UpwardTrend':  #4a
                if high >= prev_price:
                    prev_price, prev_rec_day = high, day
                elif low < prev_price * (1 - tolerance / 100):
                    pivotal_pt_high = ledger.at[prev_rec_day, prev_state]
                    _update(ledger, prev_rec_day, pivotal_pt_high, prev_state, underline=True)
                    prev_price, prev_state, prev_rec_day = low, 'NaturalReaction', day
                _update(ledger, day, prev_price, prev_state)
            case 'NaturalReaction':  # 4b
                if low <= prev_price:
                    prev_price, prev_rec_day = low, day
                elif high > prev_price * (1 + tolerance / 100):
                    pivotal_pt_low = ledger.at[prev_rec_day, prev_state]
                    _update(ledger, prev_rec_day, pivotal_pt_low, prev_state, underline=True)
                    prev_price, prev_state, prev_rec_day = high, 'NaturalRally/UpwardTrend', day
                _update(ledger, day, prev_price, prev_state)
            case 'DownwardTrend':  # 4c
                if low <= prev_price:
                    prev_price, prev_rec_day = low, day
                elif high > prev_price * (1 + tolerance / 100):
                    pivotal_pt_low = ledger.at[prev_rec_day, prev_state]
                    _update(ledger, prev_rec_day, pivotal_pt_low, prev_state, underline=True)
                    prev_price, prev_state, prev_rec_day = high, 'NaturalRally', day
                _update(ledger, day, prev_price, prev_state)
            case 'NaturalRally':  # 4d
                if high >= prev_price:
                    prev_price, prev_rec_day = high, day
                elif low < prev_price * (1 - tolerance / 100):
                    pivotal_pt_high = ledger.at[prev_rec_day, prev_state]
                    _update(ledger, prev_rec_day, pivotal_pt_high, prev_state, underline=True)
                    prev_price, prev_state, prev_rec_day = low, 'NaturalReaction/DownwardTrend', day
                _update(ledger, day, prev_price, prev_state)
            case _:
                pass
            # invalidate NaturalRally after trend



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


# Jesse Livermore: How to Trade in Stocks

import pandas as pd
from collections import namedtuple

ENDC            = '\033[0m'
RED             = '\033[38;5;196m'
GRAY            = '\033[38;5;100m'
WHITE           = '\033[38;5;255m'
GREEN           = '\033[38;5;82m'
RED_UL          = '\033[4;58:5:196m'
WHITE_UL        = '\033[4;58:5:255m'
GREEN_UL        = '\033[4;58:5:82m'
BLACK_UL        = '\033[4;58:5:233m'


def trend(symbol, period = 200, reversal = 15, breach = 7):
    # def init():
    #     prev = next(df.itertuples())
    #     for day in df[1:].itertuples():
    #         if day.high > prev.high:
    #             return day, 'UpwardTrend'
    #         if day.low < prev.low:
    #             return day, 'DownwardTrend'
    #         prev = day
    #     raise ValueError()

    # look for breakout above/below trading range
    # breach: % above resistance or below support
    # def breakout(df, breach = 20):
    #     prev_high, prev_low = df.loc[df.index[0], ['high', 'low']]
    #     for idx, day in enumerate(df.index[1:]):
    #         high, low = df.loc[day, ['high', 'low']]
    #         if high > prev_high * (1 + breach / 100):
    #             return idx + 1, 'UpwardTrend', high
    #         if low < prev_low * (1 - breach / 100):
    #             return idx + 1, 'DownwardTrend', low
    #         prev_high = max(prev_high, high)
    #         prev_low = min(prev_low, low)
    #     print('Breakout price not found')
    #     raise ValueError


    def do_trend(dir):
        upward = dir == 'Upward'
        downward = dir != 'Upward'
        if (upward and day.high > prev.high) or (downward and day.low < prev.low):  # continuation
            df.at[day.Index, state] = day.high if upward else day.low
            prev = day
        elif (upward and day.low < prev.high * (1 - reversal)) or (downward and day.high > prev.low * (1 + reversal)):  # reversal
            pivotal_pt.high, pivotal_pt.low = (df.at[prev.Index, state], None) if upward else (None, df.at[prev.Index, state])
            df.at[prev.Index, 'Underlined'] = True
            prev, state = day, 'NaturalReaction' if upward else 'NaturalRally'
            df.at[day.Index, state] = day.low if upward else day.high
            breach_zone_visited = False


    def do_natural_reversal(dir):
        reaction = dir == 'Reaction'
        rally = dir != 'Reaction'
        if (reaction and day.low < prev.low) or (rally and day.high > prev.high):  # continuation
            if (reaction and pivotal_pt.low is not None and day.low < pivotal_pt.low * (1 - breach)) or \
                    (rally and pivotal_pt.high is not None and day.high > pivotal_pt.high * (1 + breach)):
                # DownwardTrend->NaturalRally->NaturalReaction or vice-versa, and breach
                prev, state = day, 'DownwardTrend' if reaction else 'UpwardTrend'
                df.at[day.Index, state] = day.low if reaction else day.high
                pivotal_pt = PivotalPt()
                df.at[day.Index, 'EnterTrade'] = day.close
            else:  # no breach
                df.at[day.Index, state] = day.low if reaction else day.high
                prev = day
                if (reaction and pivotal_pt.low * (1 - breach) <= day.low < pivotal_pt.low * (1 + breach)) or \
                        (rally and pivotal_pt.high * (1 - breach) < day.high <= pivotal_pt.high * (1 + breach)):
                    breach_zone_visited = True
        elif (reaction and day.high > prev.low * (1 + reversal)) or \
                (rally and day.low < prev.high * (1 - reversal)):  # reversal
            if breach_zone_visited:
                df.at[day.Index, 'ExitTrade'] = day.close  # trend has ended
                breach_zone_visited = False
            if (reaction and pivotal_pt.high is not None and day.high > pivotal_pt.high * (1 + breach)) or \
                    (rally and pivotal_pt.low is not None and day.low < pivotal_pt.low * (1 - breach)):
                # UpwardTrend->NaturalReaction or DownwardTrend->NaturalRally->NaturalReaction) or vice-versa, and breach after reaction
                prev, state = day, 'UpwardTrend' if reaction else 'DownwardTrend'
                df.at[day.Index, state] = day.high if reaction else day.low
                pivotal_pt = PivotalPt()
                df.at[day.Index, 'EnterTrade'] = day.close  # either continuation of trend or trend reversal
            elif (reaction and pivotal_pt.low is None) or (rally and pivotal_pt.high is None):
                # UpwardTrend->NaturalReaction (or vice-versa), or Initialization
                if reaction:
                    pivotal_pt.low = df.at[prev.Index, state]
                else:
                    pivotal_pt.high = df.at[prev.Index, state]
                df.at[prev.Index, 'Underlined'] = True
                prev, state = day, 'NaturalRally' if reaction else 'NaturalReaction'
                df.at[day.Index, state] = day.high if reaction else day.low
                breach_zone_visited = False
            else:  # both pivotal_pt high and low are present (DownwardTrend->NaturalRally->NaturalReaction or vice-versa)
                if (reaction and day.high < pivotal_pt.high) or (rally and day.low > pivotal_pt.low):
                    prev, state = day, 'SecondaryRally' if reaction else 'SecondaryReaction'
                df.at[day.Index, state] = day.high if reaction else day.low  # update SecondaryX or NaturalX column


    def do_secondary_reversal(dir):
        reaction = dir == 'Reaction'
        rally = dir != 'Reaction'
        if (day.high > pivotal_pt.high * (1 + breach)):
            prev, state = day, 'UpwardTrend'
            df.at[day.Index, state] = day.high
            pivotal_pt = PivotalPt()
            df.at[day.Index, 'EnterTrade'] = day.close
        elif (day.low < pivotal_pt.low * (1 - breach)):
            prev, state = day, 'DownwardTrend'
            df.at[day.Index, state] = day.low
            pivotal_pt = PivotalPt()
            df.at[day.Index, 'EnterTrade'] = day.close
        elif (reaction and day.low < prev.low) or (rally and day.high > prev.high):  # continuation
            df.at[day.Index, state] = day.low if reaction else day.high
            prev = day


    df = get_daily_data(symbol, period)
    columns = ['SecondaryRally', 'NaturalRally', 'UpwardTrend', 'DownwardTrend', 'NaturalReaction', 'SecondaryReaction',
               'Underlined', 'EnterTrade', 'ExitTrade']
    df[columns] = pd.NA
    PivotalPt = namedtuple('PivotalPt', ('high', 'low'), defaults=(None,) * 2)
    pivotal_pt = PivotalPt()
    prev, state = next(df.itertuples()), None
    for day in df[prev.Index:].itertuples():
        match state:
            case 'UpwardTrend':
                do_trend('Upward')
            case 'DownwardTrend':
                do_trend('Downward')
            case 'NaturalReaction':
                do_natural_reversal('Reaction')
            case 'NaturalRally':
                do_natural_reversal('Rally')
            case 'SecondaryReaction':
                do_secondary_reversal('Reaction')
            case 'SecondaryRally':
                do_secondary_reversal('Rally')
            case _:
                if day.high > prev.high:
                    state = 'UpwardTrend'
                elif day.low < prev.low:
                    state = 'DownwardTrend'
                prev = day
 

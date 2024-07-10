# Jesse Livermore: How to Trade in Stocks

import pandas as pd
from collections import namedtuple


def trend(symbol, period=None, reversal=10, breach=5):
    reversal /= 100
    breach /= 100
    df = data_daily(symbol, period)
    columns = ['SecondaryRally', 'NaturalRally', 'UpwardTrend', 'DownwardTrend', 'NaturalReaction', 'SecondaryReaction',
               'Underlined', 'EnterTrade', 'ExitTrade']
    df[columns] = pd.NA
    PivotalPt = namedtuple('PivotalPt', ('high', 'low'), defaults=(None,) * 2)
    pivotal_pt = PivotalPt()
    prev, state = next(df.itertuples()), None

    for day in df[prev.Index:].itertuples():
        if state == 'UpwardTrend' or state == 'DownwardTrend':
            upward, downward = (state == 'UpwardTrend'), (state != 'UpwardTrend')
            if (upward and day.high > prev.high) or (downward and day.low < prev.low):  # continuation
                df.at[day.Index, state] = day.high if upward else day.low
                prev = day
            elif (upward and day.low < prev.high * (1 - reversal)) or (downward and day.high > prev.low * (1 + reversal)):  # reversal
                pivotal_pt = PivotalPt(df.at[prev.Index, state], None) if upward else PivotalPt(None, df.at[prev.Index, state])
                df.at[prev.Index, 'Underlined'] = True
                prev, state = day, 'NaturalReaction' if upward else 'NaturalRally'
                df.at[day.Index, state] = day.low if upward else day.high
                breach_zone_visited = False

        elif state == 'NaturalRally' or state == 'NaturalReaction':
            reaction, rally = (state == 'NaturalReaction'), (state != 'NaturalReaction')
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
                    if pivotal_pt.low is not None and pivotal_pt.high is not None and \
                            ((reaction and pivotal_pt.low * (1 - breach) <= day.low < pivotal_pt.low * (1 + breach)) or \
                            (rally and pivotal_pt.high * (1 - breach) < day.high <= pivotal_pt.high * (1 + breach))):
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
                        pivotal_pt = PivotalPt(pivotal_pt.high, df.at[prev.Index, state])
                    else:
                        pivotal_pt = PivotalPt(df.at[prev.Index, state], pivotal_pt.low)
                    df.at[prev.Index, 'Underlined'] = True
                    prev, state = day, 'NaturalRally' if reaction else 'NaturalReaction'
                    df.at[day.Index, state] = day.high if reaction else day.low
                    breach_zone_visited = False
                else:  # both pivotal_pt high and low are present (DownwardTrend->NaturalRally->NaturalReaction or vice-versa)
                    if (reaction and day.high < pivotal_pt.high) or (rally and day.low > pivotal_pt.low):
                        prev, state = day, 'SecondaryRally' if reaction else 'SecondaryReaction'
                    df.at[day.Index, state] = day.high if reaction else day.low  # update SecondaryX or NaturalX column

        elif state == 'SecondaryRally' or state == 'SecondaryReaction':
            reaction, rally = (state == 'SecondaryReaction'), (state != 'SecondaryReaction')
            if (day.high > pivotal_pt.high * (1 + breach)):  # breach
                prev, state = day, 'UpwardTrend'
                df.at[day.Index, state] = day.high
                pivotal_pt = PivotalPt()
                df.at[day.Index, 'EnterTrade'] = day.close
            elif (day.low < pivotal_pt.low * (1 - breach)):  # breach
                prev, state = day, 'DownwardTrend'
                df.at[day.Index, state] = day.low
                pivotal_pt = PivotalPt()
                df.at[day.Index, 'EnterTrade'] = day.close
            elif (reaction and day.low < prev.low) or (rally and day.high > prev.high):  # continuation
                df.at[day.Index, state] = day.low if reaction else day.high
                prev = day

        else:
            if day.high > prev.high or day.low < prev.low:
                state = 'UpwardTrend' if day.high > prev.high else 'DownwardTrend'
                df.at[day.Index, state] = day.high if state == 'UpwardTrend' else day.low
                df.at[day.Index, 'EnterTrade'] = day.close
            prev = day

    ENDC     = '\033[0m'
    RED      = '\033[38;5;196m'
    GRAY     = '\033[38;5;100m'
    GREEN    = '\033[38;5;82m'
    RED_UL   = '\033[4;58:5:196m'
    GREEN_UL = '\033[4;58:5:82m'
    for color, column, ul in zip([GRAY, GRAY, GREEN, RED, GRAY, GRAY], columns,
                                 [None, RED_UL, RED_UL, GREEN_UL, GREEN_UL, None]):
        df[color + column + (ul if ul is not None else '') + ENDC] = df[[column, 'Underlined']].apply(lambda x: color + \
            (ul if ul is not None and pd.notna(x.iloc[1]) else '') + \
            (str(x.iloc[0]) if pd.notna(x.iloc[0]) else '') + \
            (ul if ul is not None and pd.isna(x.iloc[1]) else '') + ENDC, axis=1)
    pd.set_option('display.max_rows', 500)
    pd.set_option('display.max_columns', None)
    pd.set_option('display.width', 1000)
    print(df.iloc[:, 14:])
    # columns_color = [GRAY + 'SecondaryRally' + ENDC, GRAY + 'NaturalRally' + GREEN_UL + ENDC,
    #                  GREEN + 'UpwardTrend' + RED_UL + ENDC, RED + 'DownwardTrend' + GREEN_UL + ENDC,
    #                  GRAY + 'NaturalReaction' + RED_UL + ENDC, GRAY + 'SecondaryReaction' + ENDC]
    # print(df.iloc[:, 14:][columns_color].dropna(thresh=1))  # don't drop if at least one non-NA
    # return df


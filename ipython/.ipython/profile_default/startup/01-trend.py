# Jesse Livermore: How to Trade in Stocks

print('h2')

def daily(symbol, period = 30):
    return Data(symbol, period).daily()

def trend(symbol, period = 200):
    data = Data(symbol, period)
    # ts = data.daily()
    # days = [pd.to_datetime(list(day)[0]) for day in ts]
    # close = [list(day.values())[0]['4. close'] for day in ts]
    # df =  pd.DataFrame({'Day': days, 'Close': close})
    # print(df)

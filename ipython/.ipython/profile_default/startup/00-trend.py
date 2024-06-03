# Jesse Livermore: How to Trade in Stocks

from pathlib import Path
import json, time
import requests
import pandas as pd

class Data:
    def __init__(self, symbol, period):
        self.symbol = symbol
        self.period = period

    def url(self):
        # alphavantage
        # apikey = 'O3JZ3KGZUD27FKIX'
        apikey = 'Y37YPCEUCE6OZ8XM'
        # apikey = 'demo'
        # outputsize = 'compact'
        outputsize = 'full'
        return 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&' + \
            f'symbol={self.symbol}&apikey={apikey}&outputsize={outputsize}'

    def daily(self):
        p = Path(f'/tmp/{self.symbol}.json')
        now = time.time()
        if not p.is_file() or (p.is_file() and p.stat().st_mtime < now - 86400):
            r = requests.get(self.url())
            data = r.json()
            with p.open('w') as f:
                json.dump(data, f)
        else:
            with p.open() as f:
                data = json.load(f)
        ts = data["Time Series (Daily)"]
        tsfull = [{day: ts[day]} for day in ts.keys()]
        return list(reversed(tsfull[:self.period]))


def daily(symbol, period = 30):
    return Data(symbol, period).daily()

def trend(symbol, period = 200):
    data = Data(symbol, period)
    ts = data.daily()
    days = [pd.to_datetime(list(day)[0]) for day in ts]
    close = [list(day.values())[0]['4. close'] for day in ts]
    df =  pd.DataFrame({'Day': days, 'Close': close})
    print(df)

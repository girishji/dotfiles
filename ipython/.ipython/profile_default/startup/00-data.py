# Daily quotes

from pathlib import Path
import json, time
import requests

print('h1')

class Data:

    def url(self, symbol):
        # alphavantage
        # apikey = 'O3JZ3KGZUD27FKIX'
        apikey = 'Y37YPCEUCE6OZ8XM'
        # apikey = 'demo'
        # outputsize = 'compact'
        outputsize = 'full'
        return 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&' + \
            f'symbol={symbol}&apikey={apikey}&outputsize={outputsize}'

    def daily(self, symbol, period):
        p = Path(f'/tmp/{symbol}.json')
        now = time.time()
        if not p.is_file() or (p.is_file() and p.stat().st_mtime < now - 86400):
            r = requests.get(self.url(symbol))
            data = r.json()
            with p.open('w') as f:
                json.dump(data, f)
        else:
            with p.open() as f:
                data = json.load(f)
        ts = data["Time Series (Daily)"]
        tsfull = [{day: ts[day]} for day in ts.keys()]
        return list(reversed(tsfull[:period]))

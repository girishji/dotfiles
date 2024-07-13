# Daily quotes

from functools import partial
import json
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
from pathlib import Path
import requests
import time
from typing import Any, Dict, Optional
import plotille

class AlphaVantageAPI:
    BASE_URL = 'https://www.alphavantage.co/query'

    def __init__(self, api_key: str, output_size: str = 'full'):
        self.api_key = api_key  # 'O3JZ3KGZUD27FKIX', 'Y37YPCEUCE6OZ8XM', 'demo'
        self.output_size = output_size  # 'compact', 'full'

    def get_url(self, symbol: str) -> str:
        return f"{self.BASE_URL}?function=TIME_SERIES_DAILY&symbol={symbol}&apikey={self.api_key}&outputsize={self.output_size}"

class DataFetcher:
    CACHE_DURATION = 43200  # 12 hours (in seconds)

    def __init__(self, api: AlphaVantageAPI):
        self.api = api

    def fetch_data(self, symbol: str) -> Dict[str, Any]:
        cache_file = Path(f'/tmp/{symbol}.json')
        now = time.time()

        if not cache_file.is_file() or (cache_file.stat().st_mtime < now - self.CACHE_DURATION):
            response = requests.get(self.api.get_url(symbol))
            response.raise_for_status()
            data = response.json()

            with cache_file.open('w') as f:
                json.dump(data, f)
        else:
            with cache_file.open() as f:
                data = json.load(f)

        return data["Time Series (Daily)"]

class DataProcessor:
    @staticmethod
    def create_dataframe(data: Dict[str, Any], period: Optional[int] = None) -> pd.DataFrame:
        prices = np.array([[float(p) for p in item.values()] for item in reversed(data.values())])
        dates = pd.to_datetime(list(reversed(data.keys())))
        df = pd.DataFrame(prices, index=dates, columns=['open', 'high', 'low', 'close', 'volume'])
        return df.tail(period) if period else df

def data_daily(symbol: str, period: Optional[int] = None, api_key: str = 'Y37YPCEUCE6OZ8XM') -> pd.DataFrame:
    api = AlphaVantageAPI(api_key)
    fetcher = DataFetcher(api)
    processor = DataProcessor()

    data = fetcher.fetch_data(symbol)
    return processor.create_dataframe(data, period)

def plot_daily_candles(symbol: str, period: Optional[int] = 140, api_key: str = 'Y37YPCEUCE6OZ8XM'):
    df = data_daily(symbol, period, api_key)
    candles = [Candle(o, h, l, c)
               for o, h, l, c in zip(df.open.tolist(), df.high.tolist(), df.low.tolist(), df.close.tolist())]
    g = CandleStickGraph(candles, 25)
    print(g.draw())

def plot_daily(symbol: str, period: Optional[int] = 200, price_type: str = 'close', api_key: str = 'Y37YPCEUCE6OZ8XM'):
    '''plot daily close'''
    df = data_daily(symbol, period, api_key)
    fig = plotille.Figure()
    fig.set_x_limits(min_=0, max_=period)
    fig.width = 128
    fig.height = 27
    fig.x_ticks_fkt = lambda min_, _: df.index[round(min_)].strftime('%b %d')
    fig.plot(range(period), df[price_type])
    print(fig.show())

def plot_daily_png(symbol: str, period: Optional[int] = None, price_type: str = 'close', api_key: str = 'Y37YPCEUCE6OZ8XM'):
    df = data_daily(symbol, period, api_key)
    df[price_type].plot()
    plt.title(f"Closing Prices for {symbol}")
    plt.xlabel("Date")
    plt.ylabel("Price")
    plt.show()

# if __name__ == "__main__":
#     # Example usage
#     symbol = "AAPL"
#     df = get_daily_data(symbol, period=30)
#     print(df.head())
#     plot_close(symbol, period=30)

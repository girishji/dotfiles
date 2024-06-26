# Daily quotes

from pathlib import Path
import json
import time
import requests
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from typing import Optional, Dict, Any
from functools import lru_cache

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

def get_daily_data(symbol: str, period: Optional[int] = None, api_key: str = 'Y37YPCEUCE6OZ8XM') -> pd.DataFrame:
    api = AlphaVantageAPI(api_key)
    fetcher = DataFetcher(api)
    processor = DataProcessor()

    data = fetcher.fetch_data(symbol)
    return processor.create_dataframe(data, period)

def plot_data(symbol: str, period: Optional[int] = None, api_key: str = 'Y37YPCEUCE6OZ8XM'):
    df = get_daily_data(symbol, period, api_key)
    df['close'].plot()
    plt.title(f"Closing Prices for {symbol}")
    plt.xlabel("Date")
    plt.ylabel("Price")
    plt.show()

# if __name__ == "__main__":
#     # Example usage
#     symbol = "AAPL"
#     df = get_daily_data(symbol, period=30)
#     print(df.head())
#     plot_data(symbol, period=30)

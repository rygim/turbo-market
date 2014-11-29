json.array!(@stock_prices) do |stock_price|
  json.extract! stock_price, :id, :stock, :date, :open, :high, :close, :volume, :adj_close
  json.url stock_price_url(stock_price, format: :json)
end

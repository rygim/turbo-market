class StockPrice < ActiveRecord::Base

	def self.find_current_prices
		response = RestClient.get "http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,#{ticker_symbols}&f=nsl1op&e=.csv"
	end

	def self.get_all_prices_from_stock(stock)
		ticker_symbol = stock.ticker_symbol

		stock_prices = StockPrice.all.where(stock: stock)
		

    	response = RestClient.get "http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,#{ticker_symbols}&f=nsl1op&e=.csv"
  	end
end

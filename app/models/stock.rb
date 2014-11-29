class Stock < ActiveRecord::Base
  validates_uniqueness_of :ticker_symbol
  attr_accessor :price
  attr_accessor :previous_close

  def self.all_with_ws_prices
  	@stocks = Stock.all

  	ticker_symbols = @stocks.uniq.collect do |stock|
  		stock.ticker_symbol
  	end

  	response = RestClient.get "http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,#{ticker_symbols.join(',')}&f=nsl1op&e=.csv"

  	@stocks.collect do |stock|
  		row = response.each_line.collect do |line|
  			line.gsub("\r\n",'').gsub('"', '').split(',')
  		end

		logger.debug "row"
  		logger.debug row

  		filtered_row = row.select { |line| line[1] == stock.ticker_symbol }

		logger.debug "filtered_row for #{stock.ticker_symbol}"
	    logger.debug filtered_row

  		stock.price = filtered_row[0][2]
  		stock.previous_close = filtered_row[0][4]

  		stock
  	end
  end
  
end

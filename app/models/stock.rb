class Stock < ActiveRecord::Base
  validates_uniqueness_of :ticker_symbol
  attr_accessor :price
  attr_accessor :previous_close
  attr_accessor :history

  def self.with_stock_ticker_ws(ticker_symbol)
    stock = Stock.where(ticker_symbol: ticker_symbol).take

    ticker_symbol =  stock.ticker_symbol
    response = get_prices_from_ws(ticker_symbol)
    populate_from_web_service(stock, response)
    add_history_from_web_service(stock)
  end

  def self.all_with_ws_prices
    stocks = Stock.all
    ticker_symbols =  stocks.collect {|stock| stock.ticker_symbol}.join(',')

    response = get_prices_from_ws(ticker_symbols)
    stocks.collect do |stock|
      populate_from_web_service(stock, response)
  	end
  end

  def self.get_prices_from_ws (ticker_symbols)
    response = RestClient.get "http://download.finance.yahoo.com/d/quotes.csv?s=%40%5EDJI,#{ticker_symbols}&f=nsl1op&e=.csv"
  end

  def self.populate_from_web_service(stock, ws_response)
    row = ws_response.each_line.collect do |line|
      line.gsub("\r\n",'').gsub('"', '').split(',')
    end

    filtered_row = row.select { |line| line[line.size - 4] == stock.ticker_symbol }.first

    stock.price = filtered_row[filtered_row.size - 3].to_f
    stock.previous_close = filtered_row[filtered_row.size - 1].to_f
    stock
  end 

  def self.add_history_from_web_service(stock)
    response = RestClient.get "http://ichart.yahoo.com/table.csv?s=#{stock.ticker_symbol}&a=5&b=1&c=2014"
    stock.history = []
    response.each_line.collect do |line|
      stock.history.push(line.gsub("\n", '').split(','))
    end
    stock.history.shift
    stock
  end


  def price_change
    ((@price - @previous_close) * 100.0).round / 100.0
  end


  
end

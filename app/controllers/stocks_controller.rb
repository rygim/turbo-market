class StocksController < ApplicationController
  def index
  	@stocks = Stock.all_with_ws_prices
  	@messages = []
  	@open_positions = []
  	@closed_positions = []
  	@stocks_to_check = []
  end

  def create
  	@stock = Stock.create(stock_params)
  	if @stock.save
  		respond_to do |format|
  			format.html { render text: "please submit as json" }
  			format.json { render text: "created stock #{@stock.ticker_symbol}" }
 		  end
  	end
  end

  def show
    @ticker_symbol = params[:ticker_symbol]
  end

  def stock
    @stock = Stock.with_stock_ticker_ws(params[:ticker_symbol])
  end

  private

  def stock_params
  	params.require(:stock).permit(:ticker_symbol)
  end
end

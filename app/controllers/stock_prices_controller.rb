class StockPricesController < ApplicationController
  before_action :set_stock_price, only: [:show, :edit, :update, :destroy]

  # GET /stock_prices
  # GET /stock_prices.json
  def index
    @stock_prices = StockPrice.all_with_prices
  end

  # GET /stock_prices/1
  # GET /stock_prices/1.json
  def show
  end

  # GET /stock_prices/new
  def new
    @stock_price = StockPrice.new
  end

  # GET /stock_prices/1/edit
  def edit
  end

  # POST /stock_prices
  # POST /stock_prices.json
  def create
    @stock_price = StockPrice.new(stock_price_params)

    respond_to do |format|
      if @stock_price.save
        format.html { redirect_to @stock_price, notice: 'Stock price was successfully created.' }
        format.json { render :show, status: :created, location: @stock_price }
      else
        format.html { render :new }
        format.json { render json: @stock_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stock_prices/1
  # PATCH/PUT /stock_prices/1.json
  def update
    respond_to do |format|
      if @stock_price.update(stock_price_params)
        format.html { redirect_to @stock_price, notice: 'Stock price was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock_price }
      else
        format.html { render :edit }
        format.json { render json: @stock_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_prices/1
  # DELETE /stock_prices/1.json
  def destroy
    @stock_price.destroy
    respond_to do |format|
      format.html { redirect_to stock_prices_url, notice: 'Stock price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_price
      @stock_price = StockPrice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_price_params
      params.require(:stock_price).permit(:stock, :date, :open, :high, :close, :volume, :adj_close)
    end
end

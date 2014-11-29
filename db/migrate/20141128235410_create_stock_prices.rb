class CreateStockPrices < ActiveRecord::Migration
  def change
    create_table :stock_prices do |t|
      t.integer :stock
      t.timestamp :date
      t.decimal :open
      t.decimal :high
      t.decimal :close
      t.integer :volume
      t.decimal :adj_close

      t.timestamps
    end
  end
end

class CreateStocksDetails < ActiveRecord::Migration
  def change
    create_table :stocks_details do |t|
      t.integer :stock_id
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.float :adj_close

      
    end
    add_index :stocks_details, [:stock_id]
  end
end

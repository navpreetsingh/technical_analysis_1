class StocksDetail < ActiveRecord::Base
  attr_accessible :adj_close, :close, :date, :high, :low, :open, :stock_id, :volume
  belongs_to :stock
end

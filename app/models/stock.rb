class Stock < ActiveRecord::Base
  attr_accessible :stock_name
    has_many :stocks_details
end

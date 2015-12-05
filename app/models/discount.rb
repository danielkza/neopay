class Discount < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :currency
end

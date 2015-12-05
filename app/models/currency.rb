class Currency < ActiveRecord::Base
  has_many :transfers
  has_many :discounts
end

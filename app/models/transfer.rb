class Transfer < ActiveRecord::Base
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
  belongs_to :related_merchant, class_name: 'Merchant'
  belongs_to :discount
  belongs_to :currency
end

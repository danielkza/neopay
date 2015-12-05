class Referral < ActiveRecord::Base
  belongs_to :old_user, class_name: 'User'
  belongs_to :new_user, class_name: 'User'
  belongs_to :transfer
  belongs_to :merchant
end

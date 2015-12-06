class Session < ActiveRecord::Base
  validates_presence_of :phone, :data
  validates_uniqueness_of :phone
end

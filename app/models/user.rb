class User < ActiveRecord::Base
  validates_uniqueness_of :phone, :ssn
  validates_presence_of :phone

  has_many :in_transfers, class_name: 'Transfer', foreign_key: :to_user_id
  has_many :out_transfers, class_name: 'Transfer', foreign_key: :from_user_id
  has_one :merchant
  has_one :referring_user, through: :referrals, foreign_key: :new_user_id
  has_many :referrals, class_name: 'Referral', foreign_key: :old_user_id
  belongs_to :default_currency, class_name: 'Currency'

  def balance(currency)
    currency ||= default_currency

    in_t = in_transfers.where(currency: currency).pluck(:amount).reduce(0, :+)
    out_t = out_transfers.where(currency: currency).pluck(:amount).reduce(0, :+)
    in_t - out_t
  end

  def transfer_to(other, amount, currency=nil, discount=nil, merchant=nil)
    transaction do
      currency ||= other.default_currency

      if balance(currency) < amount
        false
      else
        Transfer.create(from_user: self, currency: currency, to_user: other, amount: amount, discount: discount,
                        merchant: merchant)
      end
    end
  end
end

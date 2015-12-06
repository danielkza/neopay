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

  def transfer_to(other_number, amount, msg, currency=nil, discount=nil, merchant=nil)
    currency ||= default_currency
    return false if balance(currency) < amount

    transaction do
      msg_text = <<EOF
Welcome to NeoPay! You have received a transfer of #{currency.symbol} #{amount} from #{self.name},
with the following message:

#{msg}

You will soon be able to redeem it by following a few simple steps.

At any time during our conversation you can type HELP and receive an options menu.
Now we can start your service.

Now please tell me - what is your full name?
EOF
      message = Message.create_with_new_user(self, other_number, msg_text)
      other_user = message.to

      Transfer.create(from_user: self, to_user: other_user, currency: currency, amount: amount)
    end
  end
end

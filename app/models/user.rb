class User < ActiveRecord::Base
  validates_uniqueness_of :phone
  validates_uniqueness_of :ssn, allow_nil: true
  validates_presence_of :phone

  has_many :in_transfers, class_name: 'Transfer', foreign_key: :to_user_id
  has_many :out_transfers, class_name: 'Transfer', foreign_key: :from_user_id
  has_one :merchant
  has_one :referring_user, through: :referrals, foreign_key: :new_user_id
  has_many :referrals, class_name: 'Referral', foreign_key: :old_user_id
  belongs_to :default_currency, class_name: 'Currency'

  def balance(currency=nil)
    currency ||= default_currency
    currency ||= Currency.first

    in_t = in_transfers.where(currency: currency).pluck(:amount).reduce(0, :+)
    out_t = out_transfers.where(currency: currency).pluck(:amount).reduce(0, :+)
    in_t - out_t
  end

  def transfer_to(other_number, amount, msg=nil, currency=nil, discount=nil, merchant=nil)
    currency ||= default_currency
    currency ||= Currency.first

    return false if balance(currency) < amount

    transaction do
      to_user = User.find_by_phone(other_number)
      if to_user.nil?
        to_user = User.create!(phone: other_number)
        Referral.create!(old_user_id: self.id, new_user_id: to_user.id)
      end

      unless msg.nil?
        if Transfer.exists?(to_user: to_user)
          msg = <<EOF
You have received a transfer of #{currency.symbol} #{amount} from #{self.name},
with the following message:

#{msg}

EOF
        else
          msg = <<EOF
Welcome to NeoPay! You have received a transfer of #{currency.symbol} #{amount} from #{self.name},
with the following message:

#{msg}

You will soon be able to redeem it by following a few simple steps. Just reply to this message whenever you're ready.

Reply with "cancel" at any time if you wish to continue at a different time.
EOF
        end

        Message.create(from_num: self.phone, to_num: to_user.phone, text: msg)
      end

      Transfer.create(from_user: self, to_user: to_user, currency: currency, amount: amount)
    end
  end

  def as_json(options={})
    super(options).merge(balance: balance(default_currency))
  end
end

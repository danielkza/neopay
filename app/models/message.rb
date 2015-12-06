class Message < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  def create_with_new_user(from_user, to_number, text)
    transaction do
      to_user = User.find_by_phone(to_number)
      if to_user.nil?
        to_user = User.create!(phone: to_number)
        Referral.create!(old_user_id: from_user.id, new_user_id: to_user.id)
      end

      Message.create!(from: from_user, to: to_user, text: text)
    end
  end
end

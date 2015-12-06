class UsersController < ApplicationController
  before_action :json_only
  before_action :set_user, only: [:show, :update, :add_money, :transfer_money]

  def show
    respond_to do |f|
      f.json { render json: User.all, status: :ok}
    end
  end

  def update
    respond_to do |f|
      if @user.update(user_update_params)
        f.json { render json: @user, status: :ok }
      else
        f.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_amount
    amount = BigDecimal.new(params[:amount])
    if amount <= 0
      respond_to do |f|
        f.json { render json: {status: '422', errors: ['Invalid amount']}, status: :unprocessable_entity }
      end

      nil
    end

    amount
  end

  def add_money
    amount = get_amount
    return if amount.nil?

    sys_user = User.find(1)

    payment_params = {
      "token" => params[:card_token],
      "amount" => amount * 100,
      "currency"  => "USD",
      "description" => "NeoPay recharge"
    }

    payment = Simplify::Payment.create(payment_params)
    if payment['paymentStatus'] == 'APPROVED'
      sys_user.transfer_to(@user, amount)

      respond_to do |f|
        f.json { render json: @user, status: :ok, location: @user }
      end
    end
  end

  def transfer_money
    amount = get_amount
    return if amount.nil?

    respond_to do |f|
      if !@user.transfer_to(params[:other_number], amount, params[:message])
        f.json { render json: @user.errors, status: :unprocessable_entity }
      else
        f.json { render nothing: true, status: :ok }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.default_currency = Currency.first

    respond_to do |f|
      if @user.save
        f.json { render json: @user, status: :created, location: @user }
      else
        f.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :phone, :ssn, :ref_user_id)
  end

  def user_update_params
    params.require(:user).permit(:conversation_state, :name, :ssn)
  end
end

class SessionsController < ApplicationController
  before_filter :set_session, only: [:show, :update]

  def show
    respond_to do |f|
      unless @session.nil?
        f.json { render json: @session, status: :ok }
      else
        f.json { render nothing: true, status: :not_found }
      end
    end
  end

  def update
    if @session.nil?
      @session = Session.create(phone: params[:phone], data: params[:data])
    else
      @session.update(data: params[:data])
    end

    respond_to do |f|
      if @session.persisted?
        f.json { render json: @session, status: :ok }
      else
        f.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_session
    @session = Session.find_by_phone(params[:phone])
  end
end

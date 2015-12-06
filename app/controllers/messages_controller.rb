class MessagesController < ApplicationController
  def get_messages
    limit = params[:limit] || 5

    messages = Message.order(:created_at).limit(limit)
    messages.each(&:destroy)

    respond_to do |f|
      f.json { render json: messages, status: :ok }
    end
  end
end

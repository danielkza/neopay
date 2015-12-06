class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def json_only
    render :nothing => true, :status => 406 unless params[:format] == 'json'
  end
end

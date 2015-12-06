class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  def json_only
    return if params[:format] == "json" || request.headers["Accept"] =~ /json/
    render :nothing => true, :status => 406
  end
end

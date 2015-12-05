class User < ActiveRecord::Base
  devise_for :database_authenticatable, :trackable
end

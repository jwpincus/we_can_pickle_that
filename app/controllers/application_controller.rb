class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :set_cart

  def set_cart
    @cart = Cart.new(session[:cart])
  end

  def current_user
    # if session[:user_id]
    #   User.find(session[:user_id])
    # else
    #   User.new(username: "GUEST")
    # end
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end

end

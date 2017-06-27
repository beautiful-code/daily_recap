# frozen_string_literal: true

class ApplicationController < ActionController::Base
  #TODO add authencticate_user in before action
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def authenticate_user
    if (current_user.nil?)
      url="/auth/google_oauth2"
      redirect_to(url)
    end
  end

end

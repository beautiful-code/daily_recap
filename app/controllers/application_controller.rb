# frozen_string_literal: true

class ApplicationController < ActionController::Base
  #TODO add authenticate_user in before action
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  #TODO add empty line after evry action
  #TODO add authenticate_user in before_action for ApplicationController
  def authenticate_user
    if (current_user.nil?)
      url="/auth/google_oauth2"
      #TODO add flash message "please login to continue"
      redirect_to(url)
    end
  end

end

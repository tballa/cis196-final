class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  helper_method def logged_in?
    session[:user_id]
  end

  helper_method def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  helper_method def admin?
    User.find(session[:user_id]).admin if logged_in?
  end
end

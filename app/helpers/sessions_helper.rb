#require 'pry'
module SessionsHelper

  def login user
     session[:user_id] = user.id
  end

  def current_user
    #@current_user ||= User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    
    elsif (user_id = cookies.signed[:user_id])
    #raise # The tests still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login user
        @current_user = user
      end
    end

       #binding.pry
  end
  
  def current_user?(user)
    user == current_user
  end

  
  def logged_in?
    !current_user.nil?
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def logout
   forget(current_user)
   session.delete(:user_id)
   @current_user = nil
  end
  
  def forget(user)
    user.forget
    cookies.delete([:user_id])
    cookies.delete([:remember_token])
  end

end

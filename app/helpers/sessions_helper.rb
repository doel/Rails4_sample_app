module SessionsHelper

  def login user
     session[:user_id] = user.id
  end

  def current_user
    #@current_user ||= User.find_by(id: session[:user_id])
    if ( user_id = session[:user_id])
      @current_user = User.find_by(id: user_id)
    elsif ( user_id = cookie.signed[:user_id])
      user = User.find_by(id: user_id)
       if user && user.authenticate?(cookie[:remember_token])
       login user
       @current_user = user
    end
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def remember(user)
    user.remember
    cookie.permanent.signed[:user_id] = user.id
    cookie.permanent[:remember_token] = user.remember_token
  end

  def logout
   forget(current_user)
   session.delete(:user_id)
   @current_user = nil
  end
  
  def forget(user)
    user.forget
    cookie[:user_id].delete
    cookie[:remember_token].delete
  end

end

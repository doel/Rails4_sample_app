class SessionsController < ApplicationController
  def new

  end

  def create
    user =  User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password"
      render "new"
    end
  end

  def destroy
     logout if logged_in?
    if session[:user_id].nil?
      redirect_to root_url
    else
     flash.now[:danger] = "Logout unseccessful. please try again"
    end
  end
end

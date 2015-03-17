class SessionsController < ApplicationController
  def new

  end

  def create
    user =  User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
      login user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
      else
      message = "Acount Not Activated."
      message += " Please Check your email for activation link."
      flash[:warning] = message
      redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password"
      render "new"
    end
  end

  def destroy
     logout if logged_in?
     redirect_to root_url
  end
end

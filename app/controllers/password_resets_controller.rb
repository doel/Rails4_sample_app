class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_password_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password_reset link. Request to reset your password within 2 hours!"
      redirect_to root_url
    else
      flash[:danger] = "Email address not found. Requets to activativate your account or SignUp."
      redirect_to root_url
    end
    
  end

  def edit
    
  end
  
  def update
    
    if password_blank?
      puts "11111111"
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      login @user
      flash[:success] = "#{@user.name}, your password has been reset successfully."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
  def get_user
    @user=User.find_by(email: params[:email])
  end
  
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset_password, params[:id]))
    #redirect_to root_url
    end
  end
  
  def check_expiration
    
    if @user.password_token_expired?
      flash[:danger] = "Password Token has expired, click on reset password & try with the new token."
      redirect_to root_url
    end
  end
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def password_blank?
    params[:user][:password].blank?
    #redirect_to new_password_reset_url
  end
end

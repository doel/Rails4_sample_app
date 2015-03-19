require 'pry'
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
    post users_path, user: {name: "", email: "doel", password: "123456", passowrd_confirmation: "456123"}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
    post users_path, user: {name: "doel",
                                         email: "doel@a.com",
                                         password: "123456",
                                         passowrd_confirmation: "123456",
                                         activated: false,
                                        activated_at: Time.zone.now 
    }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    binding.pry
    assert_not user.activated?
    #Try to login before activation
    log_in_as(user)
    assert_not is_logged_in?
    
    #Try login with invalid activation code
    get edit_account_activation_path("inavlid token")
    assert_not is_logged_in?
    
    #Try login with invalid email, valid token
    get edit_account_activation_path(user.activation_token, email: "inavlid email")
    assert_not is_logged_in?
    
    #Try login with ivalid crentials
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end

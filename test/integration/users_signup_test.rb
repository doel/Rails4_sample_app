require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
    post users_path, user: {name: "", email: "doel", password: "123456", passowrd_confirmation: "456123"}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
    post_via_redirect users_path, user: {name: "doel",
                                         email: "doel@a.com",
                                         password: "123456",
                                         passowrd_confirmation: "123456"}
    end
    #assert_template 'users/show'
    #assert is_logged_in?
  end

end

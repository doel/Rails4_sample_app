require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
    post users_path, user: {name: "", email: "doel", password: "123", passowrd_conformation: "456"}
    end
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
    post_via_redirect users_path, user: {name: "doel",
                                         email: "doel@a.com",
                                         password: "123",
                                         passowrd_conformation: "123"}
    end
    assert_template 'users/show'
    assert is_logged_in?
  end

end

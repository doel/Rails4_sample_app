require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:doel)
    @other_user = users(:okay)
  end
  
  test "redirect to login url from edit if user is not logged_in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "redirect to login url from update if user is not logged_in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "redirect to root url if different user wants to edit information" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_url
  end
  
  test "redirect to root url if different user wants to update information" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_redirected_to root_url
  end
  
  test "redirect to root url if not logged in" do
    get :index
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

end

require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:okay)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    #get :edit
    #assert_template edit_password_reset_url(@user)
  end

end

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
   @user = users(:doel)
  end

  test "flash message should not to redirected" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {name: "", email: ""}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "successful login pages and logout" do
    get login_path
    post login_path, session: {email: @user.email, password: 'password'}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
  end
  
  test 'to verify remember me is checked or not in the login page' do
    logged_in_as(@user, remember_token: '1')
    assert_not_nil cookies['remember_token']
  end
  
  test 'to verify remember me is not checked in the login page' do
    logged_in_as(@user, remember_token: '0')
    assert_nil cookies['remember_token']
  end
end

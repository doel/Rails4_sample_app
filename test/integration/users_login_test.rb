require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "flash message should not to redirected" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {name: "", email: ""}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

end

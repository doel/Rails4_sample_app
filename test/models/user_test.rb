require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
   @user=User.create(name: "doel", email: "doels11@gmail.com", password: "hihi123", password_confirmation: "hihi123")
  end

  test "test_validity" do
   assert @user.valid?, "#{@user.errors.full_messages} is the issue"
  end
  
  test "name_should_be_prsent" do 
    @user.name = ""
    assert_not @user.valid?
  end

  test "password should have a min length of 6" do
    @user.password = @user.password_confirmation = "a"*5
   assert_not @user.valid?
  end
  
  test "email can't be blank" do
     @user.email = ""
     assert_not @user.valid?
  end

   test "email should not be very long" do
     @user.email = 'doel'*251 + '@example.com'
     assert_not @user.valid?
   end
  
   test "validity of user email" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid "
    end
   end

   test "invalidity of user email" do
    invalid_addresses = %w[user@example,com USER@@foo.COM 123@foo.bar#rg first,last@foo.jp alice++/0bob@baz.cn]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
   end

  test "authenticated? should be false if digest is nil" do
    assert_not @user.authenticated?(nil)
    assert_not @user.authenticated?('')
  end
end

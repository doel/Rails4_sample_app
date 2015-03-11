ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  # Add more helper methods to be used by all tests here...

  def is_logged_in?
   !session[:user_id].nil?
  end
  
  def log_in_as(user, options={})
    remember_token = options[:remember_token] || '1'
    password = options[:password] || 'password'
    if integration_test?
      post login_path, session: {email: user.email, password: password, remember_token: remember_token}
    else
      session[:user_id] = user.id
    end
  end
  
  def integration_test?
    defined?(post_via_redirect)
  end
end

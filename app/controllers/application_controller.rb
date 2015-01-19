class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hello
   render text: "hello #{ENV['C9_FULLNAME']}, Welcome in #{ENV['RAILS_ENV']} environment"
  end
end

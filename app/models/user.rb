#require "pry"

class User < ActiveRecord::Base
  attr_accessor(:remember_token, :activation_token)
  before_save :downcase_email 
  before_create :create_activation_digest
  
  
  
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\.-]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_blank: true

# encryption of the string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #retunrs a random token
  def User.new_token
   SecureRandom.urlsafe_base64
  end

  #saves the encrpted token in remember_digest in db
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #returns true if the remember_token in the cookie matched the remember_digest in db
  def authenticated?(attribute, token)
    
    digest = send("#{attribute}_digest")
    
    return false if digest.blank? 
    #ry.binding
    
    #BCrypt::Password.new will fail with invalid_hash as the new hash not having the valid_hash? coming tru for BCrypt gem.
    #It should be passed all the params as in cost and salt, so that it can be successfully be parsed. Otherwise use create.
    #https://github.com/codahale/bcrypt-ruby/blob/master/lib/bcrypt/password.rb
    # alias is_password, :== 
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #private
  
  def downcase_email
    self.email = email.downcase 
  end

  def create_activation_digest
    self.activation_token =  User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end

end

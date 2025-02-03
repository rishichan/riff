require "bcrypt"

module AuthHelper
  extend Grape::API::Helpers
  def valid_email?(email)
    email_regexp = /\A(?:[a-zA-Z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#\$%&'*+\/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\$\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|$(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9][0-9]|[1-9]?[0-9])\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1][0-9][0-9]|[1-9]?[0-9])$)\z/
    email.match?(email_regexp)
  end

  def hash_pass(pass)
    BCrypt::Password.create(pass)
  end

  SECRET_KEY = ENV["SECRET_KEY"]
  def generateJwt(email)
    JWT.encode(email, SECRET_KEY)
  end
end

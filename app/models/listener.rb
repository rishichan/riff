class Listener < ApplicationRecord
  validates :email,
  presence: { message: "Email cannot be blank" },
  uniqueness: { message: "This email is already registered" },
  format: { 
    with: URI::MailTo::EMAIL_REGEXP,
    message: "Please enter a valid email address" 
  }
  validates :username,
    presence: { message: "Username cannot be blank" },
    uniqueness: { message: "This username is already taken" }  
  validates :password_digest,
    presence: { message: "Password cannot be blank" }
end
require_relative "../helpers/auth_helper"
module V1
  class Artists < Grape::API
    helpers AuthHelper

    resource :artist do
      get do
        "hello for artist"
      end

      params do
        requires :username, type: String, desc: "Username"
        requires :email, type: String, desc: "Email"
        requires :password_digest, type: String, desc: "Password"
      end
      post :signup do
        puts params

        # checking email format
        return error!("Invalid email", 400) if !valid_email?(params[:email])

        # checking if email already exists
        existing_email = Artist.find_by(email: params[:email])
        return error!("Email already exists", 400) if existing_email

        # checking if username already exists
        existing_username = Artist.find_by(username: params[:username])
        return error!("Username taken", 400) if existing_username

        pass = hash_pass(params[:password_digest])

        verificationToken = generateJwt(params[:email])
        verificationToken

        artist = Artist.create!(
          username: params[:username],
          email: params[:email],
          emailVerified: false,
          password_digest: pass,
        )
        artist.save()
        puts artist
      end
    end
  end
end

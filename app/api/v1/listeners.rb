require_relative "../helpers/auth_helper"
require_relative "../helpers/listener_helper"

module V1
  class Listeners < Grape::API
    helpers AuthHelper
    helpers ListenerHelper

    resource :listener do
      # Signup a listener
      params do
        requires :email, type: String, desc: "Email"
        requires :password_digest, type: String, desc: "Password"
        requires :username, type: String, desc: "Username"
      end
      post :signup do
        signup_listener(params)
      end

      # Verify listener email
      params do
        requires :token, type: String, desc: "Verification token"
      end
      get :verify_email do
        verify_listener_email(params[:token])
      end

      # Login a listener
      params do
        requires :username, type: String, desc: "Username"
        requires :password_digest, type: String, desc: "Password"
      end
      post :login do
        login_listener(params, session, cookies)
      end

      before { authenticate_user(:listener) }
      # Health check(after authentication)
      get :health do
        { message: "Listener service is running" }
      end

      # Update an listener
      params do
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      patch :update do
        update_listener(params.merge(current_user_id: @current_user_id))
      end

      # Logout a listener
      get :logout do
        cookies.delete(:listener_session, path: '/api/v1/listener')
        cookies.delete(:music_session_listener, path: '/api/v1/music')
        { message: "Logged out" }
      end

      # Delete a listener account
      params do
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      delete :delete_account do
        byebug
        res = delete_listener(params.merge(current_user_id: @current_user_id))
        byebug
        cookies.delete(:listener_session, path: '/api/v1/listener')
        cookies.delete(:music_session_listener, path: '/api/v1/music')
        res
      end

      # Subscribe to an artist
      params do
        requires :artist_id, type: Integer, desc: "Artist ID"
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      post :subscribe do
        subscribe_artist(params)
      end

      # Unsubscribe from an artist
      params do
        requires :artist_id, type: Integer, desc: "Artist ID"
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      post :unsubscribe do
        unsubscribe_artist(params)
      end

      params do
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      get :history do
        get_user_history(params)
      end
    end
  end
end

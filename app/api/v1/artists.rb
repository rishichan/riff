require_relative "../helpers/auth_helper"
require_relative "../helpers/artist_helper"

module V1
  class Artists < Grape::API
    helpers AuthHelper
    helpers ArtistHelper

    resource :artist do
      # Signup an artist
      params do
        requires :email, type: String, desc: "Email"
        requires :password_digest, type: String, desc: "Password"
        requires :username, type: String, desc: "Username"
      end
      post :signup do
        signup_artist(params)
      end

      # Verify artist email
      params do
        requires :token, type: String, desc: "Verification token"
      end
      get :verify_email do
        verify_artist_email(params[:token])
      end

      # Login an artist
      params do
        requires :username, type: String, desc: "Username"
        requires :password_digest, type: String, desc: "Password"
      end
      post :login do
        login_artist(params, session, cookies)
      end

      before { authenticate_user(:artist) }
      # Health check(after authentication)
      get :health do
        { message: "Artist service is running" }
      end

      # Update an artist
      params do
        requires :artist_id, type: Integer, desc: "Artist ID"
      end
      patch :update do
        update_artist(params.merge(current_user_id: @current_user_id))
      end

      # Logout an artist
      get :logout do
        cookies.delete(:artist_session, path: '/api/v1/artist')
        cookies.delete(:music_session_artist, path: '/api/v1/music')
        { message: "Logged out" }
      end

      # Delete an artist account
      params do
        requires :artist_id, type: Integer, desc: "Artist ID"
      end
      delete :delete_account do
        res = delete_artist(params.merge(current_user_id: @current_user_id))
        cookies.delete(:artist_session, path: '/api/v1/artist')
        cookies.delete(:music_session_artist, path: '/api/v1/music')
        res
      end

      resource :music do
        # Upload music
        params do
          requires :file, type: File, desc: "Music file to upload"
          requires :title, type: String, desc: "Music title"
          requires :artist_id, type: Integer, desc: "Artist ID"
        end
        post :upload do
          upload_music(params)
        end

        # Update music
        params do
          requires :artist_id, type: Integer, desc: "Artist ID"
          requires :music_id, type: Integer, desc: "Music ID"
        end
        patch :update do
          update_music(params.merge(current_user_id: @current_user_id))
        end

        # Delete music
        params do
          requires :music_id, type: Integer, desc: "Music ID"
        end
        delete :delete do
          delete_music(params.merge(current_user_id: @current_user_id))
        end
      end
    end
  end
end

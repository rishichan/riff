require_relative "../helpers/auth_helper"
require_relative "../helpers/music_helper"

module V1
  class Musics < Grape::API
    helpers AuthHelper
    helpers MusicHelper

    resource :music do
      before do
        is_listener = auth_for_music(:listener)
        is_artist = auth_for_music(:artist)
        error!('Unauthorized', 401) unless is_listener || is_artist
      end      

      # Health check(after authentication)
      get :health do
        { message: "Music service is running" }
      end

      # Get music by artist id
      params do
        requires :artist_id, type: Integer, desc: "Artist ID"
      end
      get do
        get_music(params[:artist_id])
      end

      # get top 10 music (according to streams)
      get :top do
        get_top_music()
      end

      # get music by keyword
      params do
        requires :keyword, type: String, desc: "Keyword"
      end
      get :search do
        search_music(params[:keyword])
      end
    end

    resource :history do
      # add history
      params do
        requires :music_id, type: Integer, desc: "Music ID"
        requires :listener_id, type: Integer, desc: "Listener ID"
      end
      post do
        add_history(params)
      end
    end
  end
end

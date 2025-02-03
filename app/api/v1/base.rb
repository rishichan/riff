module V1
  class Base < Grape::API
    format :json # Responses will be in JSON format
    version "v1", using: :path

    mount V1::Artists
    mount V1::Listeners
    mount V1::Musics
  end
end

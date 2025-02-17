# api/v1/base.rb
module V1
  class Base < Grape::API
    format :json
    version "v1", using: :path

    helpers do
      def session
        env["rack.session"]
      end
    end

    mount V1::Artists
    mount V1::Listeners
    mount V1::Musics
  end
end

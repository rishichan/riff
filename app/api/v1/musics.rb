module V1
  class Musics < Grape::API
    resource :music do
      get do
        "hello music"
      end
    end
  end
end

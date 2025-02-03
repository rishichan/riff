module V1
  class Artists < Grape::API
    resource :artist do
      get do
        "hello for artist"
      end
    end
  end
end

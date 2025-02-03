module V1
    class Listeners < Grape::API
      resource :listener do
        get do
          "hello for listener"
        end
      end
    end
end

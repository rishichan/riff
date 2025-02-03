# app/api/base.rb
class Base < Grape::API
  prefix :api

  mount V1::Base
end

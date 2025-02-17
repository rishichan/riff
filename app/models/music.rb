class Music < ApplicationRecord
  belongs_to :artist, foreign_key: "artist_id"
end

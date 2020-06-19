class Album < ActiveRecord::Base
  has_many :photos, foreign_key: "albumid"
end

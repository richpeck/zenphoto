class Comment < ActiveRecord::Base
  belongs_to :photo, foreign_key: 'ownerid'
end

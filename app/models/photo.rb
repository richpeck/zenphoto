class Photo < ActiveRecord::Base
  self.table_name = ActiveRecord::Base.table_name_prefix + "images"
  belongs_to :album, foreign_key: 'albumid'
  has_many :comments, foreign_key: 'ownerid'
end

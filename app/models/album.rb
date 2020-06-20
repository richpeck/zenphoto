class Album < ActiveRecord::Base
  has_many :photos, foreign_key: "albumid"

  belongs_to :parent, class_name: "Album", foreign_key: "parentid"
  has_many :children, class_name: "Album", foreign_key: "parentid"

end

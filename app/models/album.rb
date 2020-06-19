class Album < ActiveRecord::Base

  # => Photos
  has_many :photos, foreign_key: "albumid"

  # => Acts As Tree
  include ActsAsTree
  acts_as_tree order: :title, foreign_key: :parentid
  
end

############################################################
############################################################
##      ____                             __  _            ##
##     / __ \_________  ____  ___  _____/ /_(_)__  _____  ##
##    / /_/ / ___/ __ \/ __ \/ _ \/ ___/ __/ / _ \/ ___/  ##
##   / ____/ /  / /_/ / /_/ /  __/ /  / /_/ /  __(__  )   ##
##  /_/   /_/   \____/ .___/\___/_/   \__/_/\___/____/    ##
##                  /_/                                   ##
##                                                        ##
############################################################
############################################################
## Since some properties are used on multiple databases, we need to store them as individual objects, and link pages as they are called
## This way, we're able to create as many properties as required, and have them transferrable between databases
## --
## All properties need to be scoped to users (multi tenant)
############################################################
############################################################

## Properties ##
## id | user_id | type | name | created_at | updated_at ##
class CreateProperties < ActiveRecord::Migration::Base # => lib/active_record/migration/base.rb
  def up
    create_table table, options do |t|
      t.references :user              # => user_id
      t.integer    :type, default: 0  # => type
      t.string     :name              # => name
      t.timestamps                    # => created_at, updated_at
      # => No index (no need to manage uniqueness)
    end
  end
end

####################################################################
####################################################################

##########################################
##########################################
##     ____  __          __             ##
##    / __ \/ /_  ____  / /_____  _____ ##
##   / /_/ / __ \/ __ \/ __/ __ \/ ___/ ##
##  / ____/ / / / /_/ / /_/ /_/ (__  )  ##
## /_/   /_/ /_/\____/\__/\____/____/   ##
##                                      ##
##########################################
##########################################

# => Load
# => Initializes dependencies (Bundler)
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENV.fetch("RACK_ENV", 'development') if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##########################################
##########################################

# => This is a rip of the "python.py" from the ZP -> Wordpress plugin
# => I've built it for Ruby, so we can create dumps of each of the albums in the target database

# => The whole aim of this is to download all the photo + album data, and save it to XML files
# => These XML files can then be imported into Wordpress

##########################################
##########################################

# => CONSTANTS
MYSQL_HOST = '50.87.216.108'
MYSQL_PORT = 3306
MYSQL_USER = 'davenpo6_pcfixes'
MYSQL_PASSWORD = 'Password123!'

ZENPHOTO_DB = 'davenpo6_znp01'
ZENPHOTO_TABLE_PREFIX ='zp_'
ZENPHOTO_ALBUM_ROOT_URL = 'https://davenporthorses.org/photos/albums'

WORDPRESS_ROOT_URL = 'https://davenporthorses.org'

OUTPUT_FILEPATH = './'

##########################################
##########################################

# => Extras
NS_EXCERPT = "http://wordpress.org/export/1.2/excerpt/"
NS_CONTENT = "http://purl.org/rss/1.0/modules/content/"
NS_WFW = "http://wellformedweb.org/CommentAPI/"
NS_DC = "http://purl.org/dc/elements/1.1/"
NS_WP = "http://wordpress.org/export/1.2/"

EXCERPT = "{%s}" % NS_EXCERPT
CONTENT = "{%s}" % NS_CONTENT
WFW = "{%s}" % NS_WFW
DC = "{%s}" % NS_DC
WP = "{%s}" % NS_WP

NSMAP = {
    'excerpt': NS_EXCERPT,
    'content': NS_CONTENT,
    'wfw': NS_WFW,
    'dc': NS_DC,
    'wp': NS_WP,
    }

##########################################
##########################################

# => Connect
ActiveRecord::Base.establish_connection adapter: 'mysql2', database: ZENPHOTO_DB , host: MYSQL_HOST, username: MYSQL_USER, password: MYSQL_PASSWORD, port: MYSQL_PORT
ActiveRecord::Base.table_name_prefix = "zp_"

# => Require
# => Pull in model classes (Photo, Album) created by Activerecord
require_all 'lib'

##########################################
##########################################

# => Fire
# => This fires the script (no inputs = all albums)
@album = Album.first

# => XML
@builder = Builder::XmlMarkup.new

# => Photos
@album.photos.each do |photo|
  @builder.item do |p|
    p.title photo.title
  end
end

p @builder

##########################################
##########################################

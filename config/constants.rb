##########################################################
##########################################################
##      ____                 _              _           ##
##    /  __ \               | |            | |          ##
##    | /  \/ ___  _ __  ___| |_ __ _ _ __ | |_ ___     ##
##    | |    / _ \| '_ \/ __| __/ _` | '_ \| __/ __|    ##
##    | \__/\ (_) | | | \__ \ || (_| | | | | |_\__ \    ##
##     \____/\___/|_| |_|___/\__\__,_|_| |_|\__|___/    ##
##                                                      ##
##########################################################
##########################################################

## ENV ##
## Allows us to define before the App directory ##
ENVIRONMENT = ENV.fetch('RACK_ENV', 'development')

## DB ##
MYSQL_HOST         = ENV.fetch('MYSQL_HOST', '')
MYSQL_USER         = ENV.fetch('MYSQL_USER', '')
MYSQL_PASS         = ENV.fetch('MYSQL_PASS', '')
MYSQL_PORT         = ENV.fetch('MYSQL_PORT', '')
MYSQL_DB           = ENV.fetch('MYSQL_DB',   '')
MYSQL_TABLE_PREFIX = ENV.fetch('MYSQL_TABLE_PREFIX', '')

## Auth ##
## Used to provide HTTP basic auth ##
AUTH = {
    user: ENV.fetch('AUTH_USER', ''),
    pass: ENV.fetch('AUTH_PASS', '')
}

## Paths ##
ZENPHOTO_ALBUM_ROOT_URL = 'https://davenporthorses.org/photos/albums'
WORDPRESS_ROOT_URL      = 'https://davenporthorses.org'

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

##########################################################
##########################################################

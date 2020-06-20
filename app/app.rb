##########################################################
##########################################################
##             ____  __          __                     ##
##            / __ \/ /_  ____  / /_____  _____         ##
##           / /_/ / __ \/ __ \/ __/ __ \/ ___/         ##
##          / ____/ / / / /_/ / /_/ /_/ (__  )          ##
##         /_/   /_/ /_/\____/\__/\____/____/           ##
##                                                      ##
##########################################################
##########################################################
##              Main Sinatra app.rb file                ##
## Allows us to define, manage and serve various routes ##
##########################################################
##########################################################
## Simple test to see if we can replicate the "Notion.so" functionality
## I believe the core aspect of the system (Pages) can be replicated using AR + React frontend
##########################################################
##########################################################

# => Constants
# => Should be loaded by Bundler, but this has to do for now
require_relative '../config/constants'

##########################################################
##########################################################

# => Load
# => This replaces individual requires with bundled gems
# => https://stackoverflow.com/a/1712669/1143732
require 'bundler/setup'

# => Pulls in all Gems
# => Replaces the need for individual gems
Bundler.require :default, ENVIRONMENT if defined?(Bundler) # => ENVIRONMENT only used here, can do away with constant if necessary

##########################################################
##########################################################

# => ActiveRecord
# => Because AR does't have the right table prefix, need to set here
# => [needed before model declaration]
ActiveRecord::Base.table_name_prefix = "zp_"

##########################################################
##########################################################

# => Models
# => This allows us to load all the models (which are not loaded by default)
require_all 'app'

##########################################################
##########################################################

## Sinatra ##
## Based on - https://github.com/kevinhughes27/shopify-sinatra-app ##
class App < Sinatra::Base

  ##########################################################
  ##########################################################
  ##              ______            _____                 ##
  ##             / ____/___  ____  / __(_)___ _           ##
  ##            / /   / __ \/ __ \/ /_/ / __ `/           ##
  ##           / /___/ /_/ / / / / __/ / /_/ /            ##
  ##           \____/\____/_/ /_/_/ /_/\__, /             ##
  ##                                  /____/              ##
  ##########################################################
  ##########################################################

    # => Helpers
    # => Allows us to manage the system at its core
    helpers Sinatra::RequiredParams # => Required Parameters (ensures we have certain params for different routes)

    # => Rack (Flash/Sessions etc)
    # => Allows us to use the "flash" object (rack-flash3)
    # => Required to get redirect_with_flash working
    use Rack::Deflater # => Compresses responses generated at server level

    # => HTMLCompressor
    # => Used to minify HTML output (removes bloat and other nonsense)
    use HtmlCompressor::Rack,
      compress_css: false,        # => already done by webpack
      compress_javascript: false, # => already done by webpack
      enabled: true,
      preserve_line_breaks: false,
      remove_comments: true,
      remove_form_attributes: false,
      remove_http_protocol: false,
      remove_https_protocol: false,
      remove_input_attributes: true,
      remove_intertag_spaces: true,
      remove_javascript_protocol: true,
      remove_link_attributes: true,
      remove_multi_spaces: true,
      remove_quotes: true,
      remove_script_attributes: true,
      remove_style_attributes: true,
      simple_boolean_attributes: true,
      simple_doctype: false

  ##########################################################
  ##########################################################

    # => Required for CSRF
    # => https://cheeyeo.uk/ruby/sinatra/padrino/2016/05/14/padrino-sinatra-rack-authentication-token/
    set :protect_from_csrf, true

  ##########################################################
  ##########################################################

    # => General
    # => Allows us to determine various specifications inside the app
    set :haml, { layout: :'layouts/application' } # https://stackoverflow.com/a/18303130/1143732
    set :views, Proc.new { File.join(root, "views") } # required to get views working (defaulted to ./views)
    set :public_folder, File.join(root, "..", "public") # Root dir fucks up (public_folder defaults to root) http://sinatrarb.com/configuration.html#root---the-applications-root-directory

  ##########################################################
  ##########################################################

    # => Asset Pipeline
    # => Allows us to precompile assets as you would in Rails
    # => https://github.com/kalasjocke/sinatra-asset-pipeline#customization
    set :assets_prefix, '/dist' # => Needed to access assets in frontend
    set :assets_public_path, File.join(public_folder, assets_prefix.strip) # => Needed to tell Sprockets where to put assets
    set :assets_css_compressor, :sass
    set :assets_js_compressor,  :uglifier
    set :assets_precompile, [/app.(sass|js)$/, /\w+\.(?!png|svg|jpgZgif).+/] # *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2

    # => Register
    # => Needs to be below definitions (for asset management)
    register Padrino::Helpers # => number_to_currency, form helpers etc (https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers.rb#L22)
    register Sinatra::AssetPipeline

    ##########################################################
    ##########################################################

      # => Sprockets
      # => This is for the layout (calling sprockets helpers etc)
      # => https://github.com/petebrowne/sprockets-helpers#setup
      configure do

        # => Paths
        # => Used to add assets to asset pipeline (rquired to ensure sprockets has the paths to serve the assets)
        %w(stylesheets javascripts images).each do |folder|
          sprockets.append_path File.join(root, 'assets', folder)
          sprockets.append_path File.join(root, '..', 'vendor', 'assets', folder)
        end #paths

      end #configure

    ##########################################################
    ##########################################################

    # => Auth
    # => http://recipes.sinatrarb.com/p/middleware/rack_auth_basic_and_digest?#label-HTTP+Basic+Authentication
    use Rack::Auth::Basic, "Protected Area" do |username, password|
      username == AUTH[:user] && password == AUTH[:pass]
    end

  ##############################################################
  ##############################################################
  ##     ____             __    __                         __ ##
  ##    / __ \____ ______/ /_  / /_  ____  ____ __________/ / ##
  ##   / / / / __ `/ ___/ __ \/ __ \/ __ \/ __ `/ ___/ __  /  ##
  ##  / /_/ / /_/ (__  ) / / / /_/ / /_/ / /_/ / /  / /_/ /   ##
  ## /_____/\__,_/____/_/ /_/_.___/\____/\__,_/_/   \__,_/    ##
  ##                                                          ##
  ##############################################################
  ##############################################################
  ## This is the central "management" page that is shown to the user
  ## It needs to include authentication to give them the ability to access it
  ##############################################################
  ##############################################################

  # => Dash
  # => Shows albums & gives options
  get '/' do

    # => Albums
    @albums = Album.all.includes(:photos)

    # => Response
    haml :index

  end ## get

  ##############################################################
  ##############################################################

  # => XML
  # => Creates XML (Wordpress WXR) document from selected album(s)
  post '/' do

    # => Required Params
    # => http://sinatrarb.com/contrib/required_params
    required_params :albums

    # => Album
    @album = Album.find params[:albums].last

    # => XML
    @xml = Builder::XmlMarkup.new

    # => Response
    content_type 'application/octet-stream'
    attachment("album-#{@album.id}.xml")
    @xml

  end ## post

  ##############################################################
  ##############################################################

end ## app.rb

##########################################################
##########################################################

# => http://recipes.sinatrarb.com/p/views/rss_feed_with_builder?
xml.instruct!

# => Channel
# => Outputs channel object (which embeds eveything else)
xml.rss("version" => "2.0", "xmlns:excerpt" => NS_EXCERPT, "xmlns:content" => NS_CONTENT, "xmlns:wfw" => NS_WFW, "xmlns:dc" => NS_DC, "xmlns:wp" => NS_WP) do |rss|

  # => RSS
  rss.channel do |channel|

      # => Channel
      channel.tag!("wp:wxr_version", "1.2")

      # => Album
      # => This outputs the XML required for each album + its accompanying children
      # => https://stackoverflow.com/a/6222049/1143732
      builder :"albums/album", locals: { channel: channel }, layout: false

      # => Photos
      # => Export photos
      @album.photos.each { |photo| builder :"albums/photos", locals: { channel: channel, photo: photo }, layout: false } if @album.photos.any?

  end #channel
end #rss

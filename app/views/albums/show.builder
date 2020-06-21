# => http://recipes.sinatrarb.com/p/views/rss_feed_with_builder?
xml.instruct!

# => Channel
# => Outputs channel object (which embeds eveything else)
xml.rss("version" => "2.0", "xmlns:excerpt" => NS_EXCERPT, "xmlns:content" => NS_CONTENT, "xmlns:wfw" => NS_WFW, "xmlns:dc" => NS_DC, "xmlns:wp" => NS_WP) do |rss|

  # => RSS
  rss.channel do |channel|

      # => Channel
      channel.tag!("wp:wxr_version", "1.2")

      # => Partial
      # => This outputs the XML required for each album + its accompanying children
      # => https://stackoverflow.com/a/6222049/1143732
      #@output << builder :album, locals: { channel: channel, album: @album }, layout: false
      # => Album
      # => Builds the album item (needs photos above to work)
      channel.item do |i|
        date = @album.date || Date.today

        i.title       @album.title.strip || @album.filename
        i.link        [WORDPRESS_ROOT_URL, @album.id].join("/?p=")
        i.pubDate     date
        i.description @album.desc if @album.desc

        i.cdata_value!("dc:creator", "admin")
        i.guid [WORDPRESS_ROOT_URL, @album.id].join("/?p="), "isPermaLink" => "false"

        i.cdata_value!("content:encoded", [@album.desc, "[gallery ids=\"#{@album.photo_ids.join(",")}\"]"].join("\n\n"))

        i.tag!("wp:post_id", @album.id.to_s)
        i.tag!("wp:post_date", date.iso8601)
        i.tag!("wp:post_date_gmt", date.iso8601)
        i.cdata_value!("wp:status", "publish")
        i.tag!("wp:post_type", "post")
        i.tag!("category", "Photos", "domain" => "category", "nicename" => "photos")

        # => Featured
        # => https://wordpress.stackexchange.com/a/140501
        # => This needs the first thumbnail from the above (photos) and outputs it here
        if @album.photos.any?
          i.tag! "wp:postmeta" do |m|
            m.tag!("wp:meta_key", "_thumbnail_id")
            m.cdata_value!("wp:meta_value", @album.photos.first.id.to_s)
          end
        end

      end #item

      # => Photos
      # => Cycle through photos and add to include (needs to include metadata, description + comments)
      if @album.photos.any?
        @album.photos.each do |photo|
          channel.item do |t|
            date = photo.date || Date.today

            t.title photo.title.strip || photo.filename
            t.pubDate date
            t.cdata_value!("dc:creator", "admin")
            t.cdata_value!("description", photo.desc) if photo.desc
            t.cdata_value!("content:encoded", photo.desc) if photo.desc

            t.tag!("wp:post_id", photo.id.to_s)
            t.cdata_value!("wp:post_date", date.iso8601)
            t.cdata_value!("post_date_gmt", date.iso8601)
            t.cdata_value!("wp:status", "inherit")
            t.cdata_value!("wp:post_parent", @album.id.to_s)
            t.cdata_value!("wp:menu_order", photo.sort_order.to_s || '')
            t.cdata_value!("wp:post_type", "attachment")
            t.tag!("wp:attachment_url", [ZENPHOTO_ALBUM_ROOT_URL, @album.folder, photo.filename].join("/"))

            %w(EXIFMake EXIFModel EXIFExposureTime EXIFFNumber EXIFFocalLength EXIFFocalLength35mm EXIFISOSpeedRatings EXIFDateTimeOriginal EXIFExposureBiasValue EXIFMeteringMode EXIFFlash EXIFImageWidth EXIFImageHeight EXIFContrast EXIFSharpness EXIFSaturation EXIFWhiteBalance).each do |meta|
              if photo.send(meta)
                t.tag!("wp:postmeta") do |p|
                  p.tag!("wp:meta_key", "_#{meta}")
                  p.cdata_value!("wp:meta_value", photo.send(meta))
                end
              end
            end

          end #channel
        end #photos
      end #if

  end #channel
end #rss

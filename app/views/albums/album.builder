# => Album
# => Builds the album item (needs photos above to work)
channel.item do |i|
  date = album.date || Date.today

  i.title       album.title.strip || album.filename
  i.link        [WORDPRESS_ROOT_URL, album.id].join("/?p=")
  i.pubDate     date
  i.description album.desc if album.desc

  i.cdata_value!("dc:creator", "admin")
  i.guid [WORDPRESS_ROOT_URL, album.id].join("/?p="), "isPermaLink" => "false"

  i.cdata_value!("content:encoded", [album.desc, "[gallery ids=\"#{album.photo_ids.map{ |id| id + 50000 }.join(",")}\"]"].join("\n\n"))

  i.cdata_value!("wp:post_parent", album.parentid.to_s) if album.parentid
  i.tag!("wp:post_id", (album.id + 50000).to_s)
  i.tag!("wp:post_date", date.iso8601)
  i.tag!("wp:post_date_gmt", date.iso8601)
  i.cdata_value!("wp:status", "publish")
  i.tag!("wp:post_type", "post")
  i.tag!("category", "Photos", "domain" => "category", "nicename" => "photos")

  # => Featured
  # => https://wordpress.stackexchange.com/a/140501
  # => This needs the first thumbnail from the above (photos) and outputs it here
  if album.photos.any?
    i.tag! "wp:postmeta" do |m|
      m.tag!("wp:meta_key", "_thumbnail_id")
      m.cdata_value!("wp:meta_value", (album.photos.first.id + 50000).to_s)
    end
  end

end #item

# => Photos
# => Cycle through photos and add to include (needs to include metadata, description + comments)
if album.photos.any?
  album.photos.each do |photo|
    channel.item do |t|
      date = photo.date || Date.today

      t.title photo.title.strip || photo.filename
      t.pubDate date
      t.cdata_value!("dc:creator", "admin")
      t.cdata_value!("description", photo.desc) if photo.desc
      t.cdata_value!("content:encoded", photo.desc) if photo.desc

      t.tag!("wp:post_id", (photo.id + 50000).to_s)
      t.cdata_value!("wp:post_date", date.iso8601)
      t.cdata_value!("post_date_gmt", date.iso8601)
      t.cdata_value!("wp:status", "inherit")
      t.cdata_value!("wp:post_parent", (album.id + 50000).to_s)
      t.cdata_value!("wp:menu_order", photo.sort_order.to_s || '')
      t.cdata_value!("wp:post_type", "attachment")
      t.tag!("wp:attachment_url", [ZENPHOTO_ALBUM_ROOT_URL, album.folder, photo.filename].join("/"))

      %w(EXIFMake EXIFModel EXIFExposureTime EXIFFNumber EXIFFocalLength EXIFFocalLength35mm EXIFISOSpeedRatings EXIFDateTimeOriginal EXIFExposureBiasValue EXIFMeteringMode EXIFFlash EXIFImageWidth EXIFImageHeight EXIFContrast EXIFSharpness EXIFSaturation EXIFWhiteBalance).each do |meta|
        if photo.send(meta)
          t.tag!("wp:postmeta") do |p|
            p.tag!("wp:meta_key", "_#{meta}")
            p.cdata_value!("wp:meta_value", photo.send(meta))
          end
        end
      end

    end #channel
  end #photo
end #if

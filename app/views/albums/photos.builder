# => Photos
# => Cycle through photos and add to include (needs to include metadata, description + comments)
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

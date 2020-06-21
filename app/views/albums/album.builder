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

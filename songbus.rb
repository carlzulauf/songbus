require 'rubygems'
require 'dbus'
require 'ruby-web-search'
require 'uri'
require 'net/http'

bus = DBus::SessionBus.instance
# get a rb object
player_proxy = bus.introspect("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Player")
 shell_proxy = bus.introspect("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Shell")

player = player_proxy["org.gnome.Rhythmbox.Player"]
shell  = shell_proxy["org.gnome.Rhythmbox.Shell"]

uri = player.getPlayingUri()[0]
song = shell.getSongProperties(uri)[0]
artist = song['artist']; title = song['title']

puts "\n#{artist} - #{title}:\n\n"

query = "#{artist} \"#{title}\" lyrics site:songmeanings.net"

search = RubyWebSearch::Google.search(:query => query, :size => 10)

lyrics_url = nil
search.results.each do |result|
  if result[:url] =~ /songmeanings\.net\/songs\/view\//
    lyrics_url = result[:url]
    break
  end
end

if lyrics_url.nil?
  puts "\n-- NO LYRICS FOUND --\n"
  puts "You might find some at this URL: #{search.results.first[:url]}\n" unless search.results.first.nil?
else
  puts "#{lyrics_url}\n\n"
  raw_html = Net::HTTP.get(URI(lyrics_url))
  if raw_html.nil?
    puts "\n-- UNABLE TO FETCH LYRICS FOR THIS SONG --\n"
  else
    puts raw_html.split("<!-- end ringtones -->")[1].split("<!--ringtones and media links -->")[0].split("<br />").join.strip
    puts
  end
end


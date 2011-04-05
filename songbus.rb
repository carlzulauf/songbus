require 'rubygems'
require 'dbus'
require 'yaml'
require 'ruby-web-search'
require 'uri'
require 'net/http'

bus = DBus::SessionBus.instance
# get a rb object
player_proxy = bus.introspect("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Player")
 shell_proxy = bus.introspect("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Shell")

player = player_proxy["org.gnome.Rhythmbox.Player"]
shell  = shell_proxy["org.gnome.Rhythmbox.Shell"]

uri = player.getPlayingUri()
song = shell.getSongProperties(uri)[0]
artist = song['artist']; title = song['title']

puts "\n#{artist} - #{title}:\n\n\n"

query = "#{artist} \"#{title}\" lyrics site:songmeanings.net"
search = RubyWebSearch::Google.search(:query => query)

if search.results.first.nil?
  puts "\n-- NO LYRICS FOUND --\n"
else
  raw_html = Net::HTTP.get(URI(search.results.first[:url]))
  puts raw_html.split("<!-- end ringtones -->")[1].split("<!--ringtones and media links -->")[0].split("<br />").join.strip
end


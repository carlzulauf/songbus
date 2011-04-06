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

def fetch_lyrics( player, shell )
  uri = player.getPlayingUri()[0]
  song = shell.getSongProperties(uri)[0]
  artist = song['artist']; title = song['title']

  puts "\nCurrently playing: #{artist} - #{title}\n\n"

  query = "#{artist} \"#{title}\" lyrics site:songmeanings.net"

  search = RubyWebSearch::Google.search(:query => query, :size => 10)

  lyrics_urls = []
  search.results.each do |result|
    lyrics_urls << result[:url] if result[:url] =~ /songmeanings\.net\/songs\/view\//
  end
  lyrics_urls
end

lyrics_urls = fetch_lyrics(player, shell)
loop do
  if lyrics_urls.empty?
    puts "\n-- NO LYRICS FOUND --\n\n\n"
  else
    current_url = lyrics_urls.shift
    puts "#{current_url}\n\n"
    raw_html = Net::HTTP.get(URI(current_url))
    if raw_html.nil?
      puts "\n-- UNABLE TO FETCH LYRICS FOR THIS SONG --\n"
    else
      puts raw_html.match(/<title>\s+SongMeanings \|\s+Lyrics \| ([\w\d -]+)\s+<\/title>/)[1].strip
      puts
      puts raw_html.match(/<!-- end ringtones -->(.+)<!--ringtones and media links -->/)[1].strip
      puts
    end
  end

  puts "Commands: (r)efresh lyric, (n)ext lyric, new (s)ong, (q)uit"
  STDOUT.flush
  answer = gets.chomp

  break                                       if answer =~ /^q/i
  lyrics_urls.unshift current_url             if answer =~ /^r/i
  lyrics_urls = fetch_lyrics( player, shell ) if answer =~ /^s/i

end


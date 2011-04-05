# Songbus

Rhythmbox lyrics script

This script grabs the current playing song in Rhythmbox, searches google for the
lyrics on songmeanings.net (good lyrics, but terrible search, so I use google).
Then the script outputs the lyrics to the console, sans bloated formatting and
ads.

*Depends on* `ruby-web-search` (https://github.com/mattetti/ruby-web-search)
which is not currnetly available through rubygems.org. Install this gem first.

*Current version (0.6.0) of* `ruby-dbus` contains a bug which prevents this
script from getting detailed song info from Rhythmbox. Please install my fork
of `ruby-dbus` found here: https://github.com/carlzulauf/ruby-dbus

Install instrucitons*:
    $ bundle install

Usage:
    $ ruby songbus.rb


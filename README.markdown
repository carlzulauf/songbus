# Songbus

Rhythmbox lyrics script

This script grabs the current playing song in Rhythmbox, searches google for the
lyrics on songmeanings.net (good lyrics, but terrible search, so I use google).
Then the script outputs the lyrics to the console, sans bloated formatting and
ads.

*Depends on* `ruby-web-search` (https://github.com/mattetti/ruby-web-search)
which is not currnetly available through rubygems.org. Install this gem first.

Install instrucitons*:

    $ bundle install

Usage:

    $ ruby songbus.rb


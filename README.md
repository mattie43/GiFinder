Welcome to the GiFinder app!

This app allows you to search Giphy through the Giphy API and save gifs in the categories of your choosing. Categories and gifs
are saved to your account, so you can always go back and view them again.

GiFinder is entirely CLI-based, and can display a preview of the gif of your choosing within the CLI.

As the app is written entirely in Ruby, you'll need to contact us for the necessary API keys if you'd like to test this 
yourself, at least for now. (Please only do this if we know who you are -- otherwise, check back in a few weeks for updates).

Install should be relatively straightforward if you're on Mac or Linux: run "bundle install" and then "ruby tools/console.rb".
Unfortunately, since running a Unix-based CLI on Windows is much more complicated, we don't have full instructions for Windows 
installation yet (but it is possible if you know what you're doing).

Feel free to contact us if you have any questions!

***

Many thanks to the authors of the following Ruby gems: 

* bundler
* activerecord
* rake
* sqlite3
* pry
* rest-client
* catpix
* mini_magick
* bcrypt
* tty-prompt
* twitter
* dotenv
* pastel
* tty-box
* launchy
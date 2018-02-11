# Space Day!

Weekend fun with my eldest daughter (she's designing the game, I'm just implementing).  Aspirational goal is multiple levels
of space dodging and planet landing.  Currently you can drive a rocketship around
a starfield, avoid obstacles to get to planets...

![FlyAway](/assets/screenshots/shot1.png)

... and watch cutscenes in between levels. :D

![Landing](/assets/screenshots/shot2.png)

## Setup

To run this on your own machine, check out the repo, and make sure
you have ruby 2.4.1 installed one way or another (rbenv would be a great
  choice).

Space Day is built on top of Gosu, which is dependent on http://www.libsdl.org/,
so before you do anything else you'll need to have that installed. If you're
on a Mac with homebrew, it's just:

`brew install sdl2`

You'll need bundler:

`gem install bundler`

and then you should be able to install dependencies from the root directory
of this project:

`bundle install`

## Playing

To start the game, you can use the script at "bin/play":

`./bin/play`

## Game structure:

* In space, there is apparently no momentum ;)
* arrow keys move, you'll stop when not pressing keys
* Make it to the planet to see the victory scene

# SokoRuby

Sokoban made in [Ruby](https://www.ruby-lang.org) with [Gosu](https://www.libgosu.org/)

## Extend

The code's documented nicely (I hope), so you can follow along pretty easily to
create your own.

## Play

### Get It
Download a zip of the source code here or clone it
`$ git clone https://github.com/Chadowo/sokoruby.git`

after that, if you have already installed gosu
`$ ruby main.rb`

Don't have gosu have installed?, easy as
`$ gem install gosu`

There's also a gemfile if you'd prefer that

`$ bundle install` &
`$ bundle exec ruby main.rb`

### Controls

<kbd>WASD</kbd> - Move yourself

<kbd>R</kbd> - Reset the level

<kbd>Escape</kbd> - Close the game

## Features

- can move
- can push boxes
- can win

## Caveats

- can't push boxes in a row yet
- can't push boxes that are in storage
- no graphics

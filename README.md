# SokoRuby

Sokoban clone made in [Ruby](https://www.ruby-lang.org) with [Gosu](https://www.libgosu.org/)

## Play

### Get It
Download a zip of the source code here or clone it
`$ git clone https://github.com/Chadowo/sokoruby.git`

You'll need gosu to run the game, either install it like this:
`$ gem install gosu`
or use Bundler
`$ bundle install`

after that to run the game

`$ ruby main.rb`

or if you installed gosu with bundler

`$ bundle exec ruby main.rb` 

### Controls

Your objective is for all the boxes (yellow squares) to be on a storage (red squares),
avoid being in a position where you can't move a box and try to solve the level with
the least steps possibles!

<kbd>WASD</kbd> or <kbd>↑←↓→</kbd> - Move yourself

<kbd>R</kbd> - Reset the level

<kbd>Escape</kbd> - Close the game

## Extend

The code's documented nicely (I hope), so you can follow along pretty easily to
create your own or learn from it.

## Features

- can move
- can push boxes
- can win

## Caveats

- can't push boxes in a row yet
- can't push boxes that are in storage
- no graphics

## License

This game is licensed under the [MIT](LICENSE) license

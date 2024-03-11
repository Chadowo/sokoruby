# SokoRuby

Sokoban clone made in [Ruby](https://www.ruby-lang.org) with [Gosu](https://www.libgosu.org/).

## Play

### Get It

Download a zip of the source code here or clone it:

```console
git clone https://github.com/Chadowo/sokoruby.git
```

You'll need gosu to run the game, either install it with gem:

```console
gem install gosu
```

or use Bundler:

```console
bundle install
```

after that to run the game just run the `main.rb` file (if you used bundler to install gosu, then the command
is slightly different, put `bundle exec` before `ruby`).

### Controls

Your objective is for all the boxes (yellow squares) to be on a storage (red squares),
avoid being in a position where you can't move a box and try to solve the level with
the least steps possibles!

<kbd>W</kbd><kbd>A</kbd><kbd>S</kbd><kbd>D</kbd> or <kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd> - Move yourself

<kbd>R</kbd> - Reset the level

<kbd>Escape</kbd> - Close the game

## Extend

The code's documented nicely (I hope), so you can follow along pretty easily to
create your own clone or learn a bit from it.

## Features

- can move
- can push boxes
- can win

## Caveats

- can't push boxes in a row yet
- can't push boxes that are in storage
- no graphics

## License

This game is licensed under the [MIT license](LICENSE).

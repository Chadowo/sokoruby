
require 'gosu'

require_relative 'components/pusher'
require_relative 'components/box'
require_relative 'components/storage'
require_relative 'components/wall'

# Main window of our sokoban game
class SokoRuby < Gosu::Window
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 640

  # We'll use a grid of 32x32
  TILE_WIDTH = 32
  TILE_HEIGHT = 32

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)

    self.caption = 'SokoGosu'

    @gameover = false

    # For now, we only support one pusher per level
    @player = nil

    # So we can easily check if the game is over
    @boxes = []

    # To draw information on the screen
    @font = Gosu::Font.new(32)

    # Sample level to test the game
    #
    # Types of pieces:
    #   0 = Empty
    #   1 = Wall
    #   2 = Box
    #   3 = Storage
    #   4 = Pusher
    #
    @level1 = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]

    # The current level being played
    @gamelevel = populate_level(@level1)
  end

  # Returns a copy of level where the boring numbers are replaced with 
  # fully-fledged game objects
  def populate_level(level)
    level.map do |row|
      row.map do |cell|
        case cell
        when 0
          Empty.new
        when 1 # Wall
          Wall.new
        when 2 # Box
          @boxes = []
          @boxes << Box.new

          # The last one is the one we pushed
          @boxes.last
        when 3 # Pusher
          Storage.new
        when 4 # Pusher
          @player = Pusher.new
        else
          cell
        end
      end
    end
  end

  # Reset the game to the start
  def reset(level)
    @gamelevel = populate_level(level)
    @gameover = false
  end

  # Main update
  def update
    # The player needs to have the game level for movement
    @player.update_map(@gamelevel)

    # Check for game-winning condition
    @gameover = true if @boxes.all?(&:is_on_storage)

    # Keyboard actions
    reset(@level1) if button_down?(Gosu::KB_R)

    close if button_down?(Gosu::KB_ESCAPE)
  end

  def button_down(id)
    # Player input is done here
    @player.button_down?(id) unless @gameover
  end

  def draw
    draw_level(@gamelevel)
    @font.draw_text('R to restart', 5, 0, 0)

    draw_gameover if @gameover
  end

  # Iterate throught the level and draw each piece
  def draw_level(level)
    level.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        case cell
        when Empty
          # Nothing
        when Wall
          Gosu.draw_rect(x * TILE_WIDTH,
                         y * TILE_HEIGHT,
                         TILE_WIDTH,
                         TILE_HEIGHT,
                         Gosu::Color::BLUE)
        when Box
          if cell.is_on_storage
            Gosu.draw_rect(x * TILE_WIDTH,
                           y * TILE_HEIGHT,
                           TILE_WIDTH,
                           TILE_HEIGHT,
                           Gosu::Color::GREEN)
          else
            Gosu.draw_rect(x * TILE_WIDTH,
                           y * TILE_HEIGHT,
                           TILE_WIDTH,
                           TILE_HEIGHT,
                           Gosu::Color::YELLOW)
          end
        when Storage
          Gosu.draw_rect(x * TILE_WIDTH,
                         y * TILE_HEIGHT,
                         TILE_WIDTH,
                         TILE_HEIGHT,
                         Gosu::Color::RED)
        when Pusher
          Gosu.draw_rect(x * TILE_WIDTH,
                         y * TILE_HEIGHT,
                         TILE_WIDTH,
                         TILE_HEIGHT,
                         Gosu::Color::WHITE)
        end
      end
    end
  end

  # Draw a banner congratulating the player
  def draw_gameover
    Gosu.draw_rect(200, 200, 400, 50, Gosu::Color::WHITE)
    @font.draw_text('Congratulations, you win!', 250, 205, 0, 1, 1, Gosu::Color::BLACK)
  end
end

SokoRuby.new.show

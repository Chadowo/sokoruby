
require 'gosu'

require_relative 'components/pusher'
require_relative 'components/box'
require_relative 'components/storage'
require_relative 'components/empty'
require_relative 'components/wall'

require_relative 'components/level'

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
    @level1 = Level.new(
              [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
               [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
             )

    # The current level being played
    @current_level = @level1

    @game_map = @current_level.populate
  end

  # Reset the game to the start
  def reset
    @current_level.reset
    @game_map = @current_level.populate

    @gameover = false
  end

  # Main update
  def update
    # The player needs to have the game level for movement
    @current_level.player.update_map(@game_map)

    # Check for game-winning condition
    @gameover = true if @current_level.finished?

    # Keyboard actions
    reset if button_down?(Gosu::KB_R)
    close if button_down?(Gosu::KB_ESCAPE)
  end

  def button_down(id)
    # Player input is done here
    @current_level.player.button_down?(id) unless @gameover
  end

  def draw
    draw_level
    draw_hud
    draw_gameover if @gameover
  end

  def draw_hud
    @font.draw_text('R to restart', 5, 0, 0)
    @font.draw_text("Steps: #{@current_level.player.steps}", 5, 605, 0)
  end

  # Iterate throught the level and draw each piece
  def draw_level
    @game_map.each_with_index do |row, y|
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


require_relative 'wall'
require_relative 'box'
require_relative 'storage'
require_relative 'empty'

# The entity whose player controls, can push boxes and move around the level
class Pusher 
  def initialize
    @gamemap = nil

    # We can walk throught special tiles like the storage one, however they
    # don't just disappear after the fact
    @on_tile = nil
  end

  # Update the pusher's internal map
  def update_map(map)
    @gamemap = map
  end

  def button_down?(id)
    case id
    when Gosu::KB_W, Gosu::KB_UP # Up
      move(0, -1)
    when Gosu::KB_S, Gosu::KB_DOWN # Down
      move(0, 1)
    when Gosu::KB_A, Gosu::KB_LEFT # Left
      move(-1, 0) 
    when Gosu::KB_D, Gosu::KB_RIGHT # Right
      move(1, 0)
    end
  end

  def move(dx, dy)
    # Our coordinates
    x, y = find_position

    return if x.nil? # If the player moves at the same time the level is reset
                     # then it'll return nil, we can

    destiny = @gamemap[y + dy][x + dx]

    case destiny
    when Empty
      # Were we on a special tile?
      if @on_tile
        @gamemap[y][x] = @on_tile
        @on_tile = nil
      else
        @gamemap[y][x] = Empty.new
      end

      @gamemap[y + dy][x + dx] = self
    when Wall # Impassable
      return
    when Box # Push
      box = @gamemap[y + dy][x + dx]

      # Attempt to move the box
      if push_box(x, y, dx, dy, box)
        # Were we on a special tile?
        if @on_tile
          @gamemap[y][x] = @on_tile
          @on_tile = nil
        else
          @gamemap[y][x] = Empty.new
        end

        # Move
        @gamemap[y + dy][x + dx] = self
      end
    when Storage # Passable, however it is not empty
      @on_tile = destiny # Save the storage

      @gamemap[y][x] = Empty.new

      @gamemap[y + dy][x + dx] = self
    end
  end

  # Move a box accordingly to our direction
  # TODO: Push multiple boxes at the same time
  def push_box(x, y, dx, dy, box)
    box_destiny = @gamemap[y + (dy * 2)][x + (dx * 2)]

    # Move acccordingly to destiny
    case box_destiny
    when Empty
      return if box.is_on_storage

      @gamemap[y + (dy * 2)][x + (dx * 2)] = box
    when Wall
      return

    when Storage
      # There could be multiple storages in a row
      return if box.is_on_storage

      box.is_on_storage = true

      @gamemap[y + (dy * 2)][x + (dx * 2)] = box
    end
  end

  # Finds the x and y of the pusher in the gamemap, returns an array
  def find_position
    # Iterate throught the map finding our x and y relative to it
    @gamemap.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell.is_a? Pusher
          return [x, y]
        end
      end
    end
  rescue NoMethodError
    if @gamemap.nil? # The player tried to move before the level has reset
      return
    else # Something else has happened
      raise 
    end
  end
end

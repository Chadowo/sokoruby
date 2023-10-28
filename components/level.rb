
require_relative 'pusher'
require_relative 'box'
require_relative 'storage'
require_relative 'empty'
require_relative 'wall'

class Level
  attr_reader :map, :player

  def initialize(map)
    @map = map

    @player = nil
    @boxes = []
  end

  # Returns a new game level with game objects
  def populate
    @map.map do |row|
      row.map do |cell|
        case cell
        when 0
          Empty.new
        when 1
          Wall.new
        when 2
          @boxes << Box.new

          # Grab the box we pushed
          @boxes.last
        when 3
          Storage.new
        when 4
          @player = Pusher.new
        else
          cell
        end
      end
    end
  end

  # Set the level to its initial condition
  def reset
    @boxes = []
  end

  # Are all the boxes of the level stashed?
  def finished?
    true if @boxes.all?(&:is_on_storage)
  end
end

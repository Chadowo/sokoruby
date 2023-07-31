
# A box is simple, like a switch there's only two states, either it is stored 
# or it isn't
class Box
  attr_accessor :is_on_storage

  def initialize
    @is_on_storage = false
  end
end

class Exhibit
  attr_reader :name, :cost

  def initialize(init_hash)
    @name = init_hash[:name]
    @cost = init_hash[:cost]
  end
end

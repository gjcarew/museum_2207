class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.select do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    patrons_by_exhibit_hash = Hash.new([])
    @exhibits.each do |exhibit|
      patrons_by_exhibit_hash[exhibit] = @patrons.select do |patron|
        patron.interests.include?(exhibit.name)
      end
    end
    patrons_by_exhibit_hash
  end

  def ticket_lottery_contestants(exhibit)
    ticket_lottery_arr = []
    patrons_by_exhibit_interest[exhibit].each do |patron|
      if patron.spending_money < exhibit.cost
        ticket_lottery_arr << patron
      end
    end
    ticket_lottery_arr
  end

  def draw_lottery_winner(exhibit)
    return nil if ticket_lottery_contestants(exhibit).empty?
    ticket_lottery_contestants(exhibit).sample(1)[0].name
  end

end

require './lib/museum'
require './lib/patron'
require './lib/exhibit'

describe Museum do
  before :each do
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
    @patron_4 = Patron.new("Megan", 7)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    @patron_3.add_interest("Dead Sea Scrolls")
    @patron_4.add_interest("Dead Sea Scrolls")
  end

  it 'has attributes' do
    expect(@dmns.name).to eq("Denver Museum of Nature and Science")
    expect(@dmns.exhibits).to eq([])
    expect(@dmns.patrons).to eq([])
  end

  it 'can add exhibits' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    expect(@dmns.exhibits).to eq([@gems_and_minerals, @dead_sea_scrolls, @imax])
  end

  it 'recommends exhibits that match patron interests' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    expect(@dmns.recommend_exhibits(@patron_1)).to eq([@gems_and_minerals, @dead_sea_scrolls])
    expect(@dmns.recommend_exhibits(@patron_2)).to eq([@imax])
  end

  it 'admits patrons' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    expect(@dmns.patrons).to eq([@patron_1, @patron_2, @patron_3])
  end

  it 'displays patrons by exhibit interest' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)

    expect(@dmns.patrons_by_exhibit_interest).to eq({@gems_and_minerals => [@patron_1], @dead_sea_scrolls => [@patron_1, @patron_3, @patron_4], @imax => [@patron_2]})
  end

  it 'adds contestants to a lottery if they are interested in an exhibit but lack the cash' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)

    expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to eq([@patron_3, @patron_4])
  end

  it 'draws a lottery winner' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)
    allow(@dmns).to receive(:draw_lottery_winner).and_return(@patron_3.name)
    expect(@dmns.draw_lottery_winner(@dead_sea_scrolls)).to eq("Johnny")
  end

  it 'lottery winner is nil if there are no contestants' do
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @dmns.admit(@patron_4)
    expect(@dmns.draw_lottery_winner(@gems_and_minerals)).to be nil
  end
end

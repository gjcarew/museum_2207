require './lib/exhibit'

RSpec.describe Exhibit do
  it 'exists' do
    exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})
    expect(exhibit).to be_a Exhibit
  end

  it 'has attributes' do
    exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})
    expect(exhibit.name).to eq("Gems and Minerals")
    expect(exhibit.cost).to eq(0)
  end
end

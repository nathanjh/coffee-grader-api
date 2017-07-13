require 'rails_helper'

RSpec.describe Roaster, type: :model do
  let(:roaster) do
    Roaster.create(name: 'Cafe Grumpy',
                   location: 'Greenpoint, Brooklyn',
                   website: 'www.cafegrumpy.com')
  end

  describe 'attributes' do
    subject { roaster }

    it { should respond_to(:name) }
    it { should respond_to(:location) }
    it { should respond_to(:website) }
  end

  describe 'validations' do
    subject { roaster }

    it { should validate_uniqueness_of(:name).scoped_to(:location) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
  end

  describe 'associations' do
    subject { roaster }

    it { should have_many(:cupped_coffees) }
    it { should have_many(:coffees).through(:cupped_coffees) }
    it 'coffees are distinct for a given roaster' do
      host = create(:user)
      coffee = create(:coffee)
      cupping1 = create(:cupping, host_id: host.id)
      create(:cupped_coffee,
             coffee_id: coffee.id,
             roaster_id: roaster.id,
             cupping_id: cupping1.id)
      cupping2 = create(:cupping, host_id: host.id)
      create(:cupped_coffee,
             coffee_id: coffee.id,
             roaster_id: roaster.id,
             cupping_id: cupping2.id)
      expect(roaster.cupped_coffees.size).to eq 2
      expect(roaster.coffees.size).to eq 1
      expect(roaster.coffees[0].id).to eq coffee.id
    end
  end
end

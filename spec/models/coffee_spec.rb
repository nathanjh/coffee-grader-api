require 'rails_helper'

RSpec.describe Coffee, type: :model do
  let(:coffee) do
    Coffee.create(name: 'Aragon',
                  origin: 'Guatemala',
                  farm: 'Beneficio Bella Vista')
  end

  describe 'attributes' do
    subject { coffee }

    it { should respond_to(:name) }
    it { should respond_to(:origin) }
    it { should respond_to(:farm) }
  end

  describe 'validations' do
    subject { coffee }

    it { should validate_uniqueness_of(:name).scoped_to(:origin, :farm) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:farm) }
    it { should validate_presence_of(:origin) }
  end

  describe 'associations' do
    subject { coffee }

    it { should have_many(:cupped_coffees) }
    it { should have_many(:roasters).through(:cupped_coffees) }
    it 'roasters are distinct for a given coffee' do
      host = create(:user)
      roaster = create(:roaster)
      cupping1 = create(:cupping, host_id: host.id)
      cupped_coffee1 = create(:cupped_coffee,
                              coffee_id: coffee.id,
                              roaster_id: roaster.id,
                              cupping_id: cupping1.id)
      cupping2 = create(:cupping, host_id: host.id)
      cupped_coffee2 = create(:cupped_coffee,
                              coffee_id: coffee.id,
                              roaster_id: roaster.id,
                              cupping_id: cupping2.id)
      expect(coffee.cupped_coffees.size).to eq 2
      expect(coffee.roasters.size).to eq 1
      expect(coffee.roasters[0].id).to eq roaster.id
    end
  end
end

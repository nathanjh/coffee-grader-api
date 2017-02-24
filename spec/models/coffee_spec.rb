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
end

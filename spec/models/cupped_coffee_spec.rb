require 'rails_helper'

RSpec.describe CuppedCoffee, type: :model do
  let(:cupped_coffee) { create(:cupped_coffee) }

  describe 'attributes' do
    subject { cupped_coffee }

    it { should respond_to(:roast_date) }
    it { should respond_to(:coffee_alias) }
  end

  describe 'validations' do
    subject { cupped_coffee }

    it { should validate_presence_of(:roast_date) }
    it { should validate_uniqueness_of(:coffee_alias).scoped_to(:cupping_id) }
  end

  describe 'associations' do
    subject { cupped_coffee }

    it { should belong_to(:coffee) }
    it { should belong_to(:roaster) }
    it { should belong_to(:cupping) }
    it { should have_many(:scores) }
  end
end

require 'rails_helper'

RSpec.describe CuppedCoffee, type: :model do
  let(:cupped_coffee) do
    @user = create(:user)
    CuppedCoffee.create(roast_date: Date.parse('Feb 24 2017'),
                        coffee_alias: 'Sample A',
                        coffee_id: create(:coffee).id,
                        roaster_id: create(:roaster).id,
                        cupping_id: create(:cupping, host_id: @user.id).id)
  end

  describe 'attributes' do
    subject { cupped_coffee }

    it { should respond_to(:roast_date) }
    it { should respond_to(:coffee_alias) }
  end

  describe 'validations' do
    subject { cupped_coffee }

    it { should validate_presence_of(:roast_date) }
  end

  describe 'associations' do
    subject { cupped_coffee }

    it { should belong_to(:coffee) }
    it { should belong_to(:roaster) }
    it { should belong_to(:cupping) }
    # need to add scores table
    xit { should have_many(:scores) }

    # it 'belongs to a coffee' do
    #   pending
    # end
    #
    # it 'belongs to a roaster' do
    #   pending
    # end
    #
    # it 'belongs to a cupping' do
    #   pending
    # end
    #
    # it 'has many scores' do
    #   pending
    # end
  end
end

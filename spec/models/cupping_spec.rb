require 'rails_helper'

RSpec.describe Cupping, type: :model do
  let(:cupping) do
    user = create(:user)
    create(:cupping, host_id: user.id)
  end

  describe 'attributes' do
    subject { cupping }

    it { should respond_to(:location) }
    it { should respond_to(:cup_date) }
    it { should respond_to(:cups_per_sample) }
    it { should respond_to(:host_id) }
    it { should respond_to(:open) }
    it 'open attribute should default to true' do
      expect(cupping.open).to be true
    end
  end

  describe 'validations' do
    subject { cupping }

    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:cup_date) }
    it { should validate_presence_of(:cups_per_sample) }
    it { should validate_presence_of(:host_id) }
  end

  describe 'associations' do
    subject { cupping }

    it { should belong_to(:host) }
    it { should have_many(:invites).dependent(:destroy) }
    it { should have_many(:scores).dependent(:restrict_with_exception) }
    it { should have_many(:cupped_coffees).dependent(:destroy) }
  end
end

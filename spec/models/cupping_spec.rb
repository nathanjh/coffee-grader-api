require 'rails_helper'

RSpec.describe Cupping, type: :model do
  let(:user) { create(:user) }
  let(:cupping) { create(:cupping, host_id: user.id) }

  describe 'attributes' do
    subject { cupping }

    it { should respond_to(:location) }
    it { should respond_to(:cup_date) }
    it { should respond_to(:cups_per_sample) }
    it { should respond_to(:host_id) }
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
    it { should have_many(:invites) }
    it { should have_many(:scores) }
    it { should have_many(:cupped_coffees) }
  end
end

require 'rails_helper'

RSpec.describe Cupping, type: :model do
  describe 'attributes' do
    before { @user = create(:user)
             @cupping = create(:cupping, host_id: @user.id) }

    subject { @cupping }

    it { should respond_to(:location) }
    it { should respond_to(:cup_date) }
    it { should respond_to(:cups_per_sample) }
    it { should respond_to(:host_id) }
  end

  describe 'validations' do
    before { @user = create(:user)
             @cupping = create(:cupping, host_id: @user.id) }

    subject { @cupping }

    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:cup_date) }
    it { should validate_presence_of(:cups_per_sample) }
    it { should validate_presence_of(:host_id) }
  end

  describe 'associations' do
    before { @user = create(:user)
             @cupping = create(:cupping, host_id: @user.id) }

    subject { @cupping }

    it { should belong_to(:host) }

  end

end



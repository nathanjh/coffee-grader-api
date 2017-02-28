require 'rails_helper'

RSpec.describe Score, type: :model do
  let(:score) do
    @coffee = create(:coffee)
    @roaster = create(:roaster)
    @user = create(:user)
    @cupping = create(:cupping, host_id: @user.id)
    @cupped_coffee = create(:cupped_coffee, coffee_id: @coffee.id, roaster_id: @roaster.id, cupping_id: @cupping.id)
    @score = create(:score, grader_id: @user.id, cupping_id: @cupping.id, cupped_coffee_id: @cupped_coffee.id)
  end

  describe 'attributes' do
    subject { score }

    it { should respond_to(:aroma) }
    it { should respond_to(:aftertaste) }
    it { should respond_to(:acidity) }
    it { should respond_to(:body) }
    it { should respond_to(:uniformity) }
    it { should respond_to(:balance) }
    it { should respond_to(:clean_cup) }
    it { should respond_to(:sweetness) }
    it { should respond_to(:overall) }
    it { should respond_to(:defects) }
    it { should respond_to(:total_score) }
    it { should respond_to(:notes) }
    it { should respond_to(:cupped_coffee_id) }
    it { should respond_to(:cupping_id) }
    it { should respond_to(:grader_id) }
  end

  describe 'validations' do
    subject { score }

    it { should validate_presence_of(:grader_id) }
    it { should validate_presence_of(:cupping_id) }
    it { should validate_presence_of(:cupped_coffee_id) }
    it { should validate_presence_of(:aroma) }
    it { should validate_presence_of(:aftertaste) }
    it { should validate_presence_of(:acidity) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:uniformity) }
    it { should validate_presence_of(:balance) }
    it { should validate_presence_of(:clean_cup) }
    it { should validate_presence_of(:sweetness) }
    it { should validate_presence_of(:overall) }
    it { should validate_presence_of(:defects) }
    it { should validate_presence_of(:total_score) }
  end

  describe 'associations' do
    subject { score }

    it { should belong_to(:grader) }
    it { should belong_to(:cupped_coffee) }
    it { should belong_to(:cupping) }
  end
end

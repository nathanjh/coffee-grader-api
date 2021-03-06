require 'rails_helper'

RSpec.describe Score, type: :model do
  let(:user) { create(:user) }
  let(:cupping) { create(:cupping, host_id: user.id) }
  let(:cupped_coffee) do
    coffee = create(:coffee)
    roaster = create(:roaster)
    create(:cupped_coffee, coffee_id: coffee.id,
                           roaster_id: roaster.id,
                           cupping_id: cupping.id)
  end

  let!(:score) do
    create(:score, grader_id: user.id,
                   cupping_id: cupping.id,
                   cupped_coffee_id: cupped_coffee.id)
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
    it { should respond_to(:flavor) }
    it { should respond_to(:final_score) }
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
    it { should validate_presence_of(:final_score) }
    it { should validate_presence_of(:flavor) }

    it do
      should validate_uniqueness_of(:grader_id).scoped_to(:cupped_coffee_id)
        .with_message('has already scored this coffee!')
    end
  end

  describe 'associations' do
    subject { score }

    it { should belong_to(:grader) }
    it { should belong_to(:cupped_coffee) }
    it { should belong_to(:cupping) }
  end

  describe '::import' do
    before :each do
      @grader = create(:user)
      cupped_coffees = create_list(:cupped_coffee, 3, cupping_id: cupping.id)
      @new_scores = cupped_coffees.map do |cupped_coffee|
        attributes_for(:score,
                       grader_id: @grader.id,
                       cupping_id: cupping.id,
                       cupped_coffee_id: cupped_coffee.id)
      end
    end
    it 'raises an exception if any null values are passed' do
      invalid_score = attributes_for(:score,
                                     cupping_id: cupping.id,
                                     cupped_coffee_id: cupped_coffee.id)
      @new_scores << invalid_score
      expect { Score.import(@new_scores) }
        .to raise_error(Score::BatchInsertScoresError)
    end

    it 'raises an expection if cupping is closed' do
      cupping.update(open: false)
      cupping.reload

      expect { Score.import(@new_scores) }
        .to raise_error(Score::BatchInsertScoresError)
        .with_message('Cupping is closed and cannot receive any new scores.')
    end
  end
end

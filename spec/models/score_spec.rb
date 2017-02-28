require 'rails_helper'

RSpec.describe Score, type: :model do
  let(:score) do
    @coffee = create(:coffee)
    @roaster = create(:roaster)
    @user = create(:user)
    @cupping = create(:cupping, host_id: @user.id)
    @cupped_coffee = create(:cupped_coffee, coffee_id: @coffee.id, roaster_id: @roaster.id, cupping_id: @cupping.id)
    @score = create(:score, grader_id: @user.id, cupping_id: @cupping.id)
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

end

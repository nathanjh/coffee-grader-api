require 'rails_helper'

RSpec.describe Roaster, type: :model do
  let(:roaster) do
    Roaster.create(name: 'Cafe Grumpy',
                   location: 'Greenpoint, Brooklyn',
                   website: 'www.cafegrumpy.com')
  end

  describe 'attributes' do
    subject { roaster }

    it { should respond_to(:name) }
    it { should respond_to(:location) }
    it { should respond_to(:website) }
  end

  describe 'validations' do
    subject { roaster }

    it { should validate_uniqueness_of(:name).scoped_to(:location) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
  end
end

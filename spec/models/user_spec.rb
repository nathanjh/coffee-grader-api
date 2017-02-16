require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    before { @user = create(:user) }

    subject { @user }

    it { should respond_to(:name) }
    it { should respond_to(:username) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:create_new_auth_token) }
  end
end

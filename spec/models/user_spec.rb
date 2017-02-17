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

  describe 'validations' do
    before { @user = create(:user) }

    subject { @user }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('iamokemail@valid.com').for(:email) }
  end
end

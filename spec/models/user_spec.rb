require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  describe 'attributes' do
    subject { user }

    it { should respond_to(:name) }
    it { should respond_to(:username) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:create_new_auth_token) }
  end

  describe 'validations' do
    subject { user }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('iamokemail@valid.namespace.com').for(:email) }
    it { should_not allow_value('notokatinvalid.@com').for(:email) }
  end

  describe 'assocations' do
    subject { user }

    it { should have_many(:cuppings) }
  end
end

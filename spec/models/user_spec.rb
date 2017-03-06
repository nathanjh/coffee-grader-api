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

    context 'as a grader' do
      it { should have_many(:scores) }
      it { should have_many(:invites) }
      it { should have_many(:attended_cuppings).through(:invites) }

      describe '#attended_cuppings' do
        before :each do
          @host = create(:user)
          @past_cuppings = Array.new(3) { create(:cupping, host_id: @host.id) }
          @past_cuppings.each { |cupping| cupping.invites.create(grader_id: user.id) }
        end

        it "must have an 'accepted' status on invite joins user and cupping" do
          accepted_invite = user.invites.first.update(status: 1)
          attended_cuppings = user.attended_cuppings
          expect(attended_cuppings.size).to eq 1
          expect(attended_cuppings[0].id).to eq accepted_invite.cupping_id
        end

        it 'must have occurred in the past (as of current date-time)' do
          pending
        end
      end
    end
    context 'as a cupping host' do
      it { should have_many(:hosted_cuppings) }
    end
  end
end

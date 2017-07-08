require 'rails_helper'

RSpec.describe InviteMailer, type: :mailer do
  let!(:cupping) { create(:cupping) }
  let(:guest_invite) { cupping.invites.create!(grader_email: 'liam@s.com') }
  let(:guest_email) { InviteMailer.guest_invitation(guest_invite, cupping) }
  let(:user_invite) { cupping.invites.create!(grader_id: create(:user).id) }
  let(:user_email) { InviteMailer.user_invitation(user_invite, cupping) }

  # before(:context) do
  #   cupping = create(:cupping)
  #   invite = cupping.invites.create!(grader_email: 'newfriend@whatever.com')
  #   @mail = InviteMailer.guest_invitation(invite, cupping)
  # end
  after(:context) { ActionMailer::Base.deliveries.clear }

  describe '#guest_invitation' do
    it 'sends the email' do
      guest_email.deliver_now
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
  end

  describe '#user_invitation' do

  end
end

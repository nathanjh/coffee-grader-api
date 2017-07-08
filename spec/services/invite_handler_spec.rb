require 'rails_helper'

RSpec.describe InviteHandler do
  let(:cupping) { FactoryGirl.create(:cupping) }
  # Examples assume that @invite is valid, as invite_handler is implemented
  # after all validation checks pass...
  context "invite's grader_id field is blank (no user account exists)" do
    before do
      @invite = cupping.invites.create!(grader_email: 'example@whomever.com')
      InviteHandler.build.call(@invite)
    end
    it 'assigns and persists an invite_token to invite' do
      @invite.reload
      expect(@invite.invite_token.length).to be > 0
    end

    xit 'sends the new user invite email to grader_email address provided' do
    end
  end

  context 'invite has a valid grader_id' do
    xit "sends the preexisting user invite email to grader's email address" do
    end
  end
end

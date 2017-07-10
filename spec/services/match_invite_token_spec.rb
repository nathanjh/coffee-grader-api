require 'rails_helper'

RSpec.describe MatchInviteToken do
  let!(:invite) do
    create(:cupping)
      .invites.create!(grader_email: 'test@me.com',
                       invite_token: 'epn4APKl-M9lcunNomaNkg')
  end

  context 'given a user object with an invite token' do
    # let(:cupping) { create(:cupping) }
    let(:user) { create(:user, invite_token: 'epn4APKl-M9lcunNomaNkg') }

    it "updates the matching invite's grader_id to user's id" do
      expect do
        MatchInviteToken.build.call(user)
        invite.reload
      end
        .to change { invite.grader_id }.from(nil).to(user.id)
    end
  end

  context 'given a user object without an invite token' do
    let(:user) { create(:user) }

    it "doesn't upadate the invite's grader_id" do
      expect { MatchInviteToken.build.call(user) }
        .not_to change(invite, :grader_id)
    end
  end

  context 'given a user object with a bad invite token' do
    let(:user) { create(:user, invite_token: 'baaaad_token') }
    it 'fails silently' do
      expect { MatchInviteToken.build.call(user) }
        .not_to raise_error
    end
  end
end

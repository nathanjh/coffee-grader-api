require 'rails_helper'

RSpec.describe InviteMailer, type: :mailer do
  let!(:cupping) { create(:cupping) }
  let(:guest_invite) { cupping.invites.create!(grader_email: 'liam@s.com') }
  let(:guest_email) { InviteMailer.guest_invitation(guest_invite, cupping) }
  let(:user_invite) { cupping.invites.create!(grader_id: create(:user).id) }
  let(:user_email) { InviteMailer.user_invitation(user_invite, cupping) }

  after(:context) { ActionMailer::Base.deliveries.clear }

  describe '#guest_invitation' do
    before(:example) do
      guest_email.deliver_now
      @delivered_mail = ActionMailer::Base.deliveries.first
    end
    it 'sends the email' do
      expect(@delivered_mail).to be_a(Mail::Message)
    end

    it 'renders the headers' do
      expect(@delivered_mail.subject).to match(/invited you to a cupping/)
      expect(@delivered_mail.to).to eq([guest_invite.grader_email])
      expect(@delivered_mail.from).to eq([InviteMailer.default[:from]])
    end

    it 'renders the body' do
      sign_up_link_re =
        %r{https:\/\/www.coffeegrader.com\/sign-up\?inviteToken=}
      expect(@delivered_mail.body.encoded)
        .to match(sign_up_link_re)
    end
  end

  describe '#user_invitation' do
    before(:example) do
      user_email.deliver_now
      @delivered_mail = ActionMailer::Base.deliveries.first
    end
    it 'sends the email' do
      expect(@delivered_mail).to be_a(Mail::Message)
    end

    it 'renders the headers' do
      expect(@delivered_mail.subject).to match(/invited you to a cupping/)
      expect(@delivered_mail.to).to eq([User.find(user_invite.grader_id).email])
      expect(@delivered_mail.from).to eq([InviteMailer.default[:from]])
    end

    it 'renders the body' do
      user_account_link_re =
        %r{https:\/\/www.coffeegrader.com\/users\/#{user_invite.grader_id}}
      expect(@delivered_mail.body.encoded)
        .to match(user_account_link_re)
    end
  end
end

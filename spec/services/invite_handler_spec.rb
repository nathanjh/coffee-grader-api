require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe InviteHandler do
  let(:cupping) { FactoryGirl.create(:cupping) }
  let(:service) { described_class.build }
  # Examples assume that @invite is valid, as invite_handler is implemented
  # after all validation checks pass...
  context "invite's grader_id field is blank (no user account exists)" do
    before do
      @invite = cupping.invites.create!(grader_email: 'example@whomever.com')
    end
    it 'assigns and persists an invite_token to invite' do
      service.call(@invite, cupping)
      @invite.reload
      expect(@invite.invite_token.length).to be > 0
    end

    context 'sends the new user invite email' do
      before { ActiveJob::Base.queue_adapter = :test }

      it 'queues the job' do
        # enqueues the job in 'mailers' queue
        expect { service.call(@invite, cupping) }.to have_enqueued_job
          .on_queue('mailers')
      end

      it "sends the invite email with the correct 'to' header" do
        # sends the email with the correct 'to' header
        perform_enqueued_jobs { service.call(@invite, cupping) }
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([@invite.grader_email])
      end

      it 'implements InviteHandler::GuestInviteContact' do
        guest_invite_contact =
          instance_double('InviteHandler::GuestInviteContact', call: nil)
        test_service = InviteHandler.new(guest_invite_contact)
        test_service.call(@invite, cupping)
        expect(guest_invite_contact).to have_received(:call)
          .with(@invite, cupping)
      end
    end
  end

  context 'invite has a valid grader_id' do
    xit "sends the preexisting user invite email to grader's email address" do
    end
  end
end

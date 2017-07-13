require 'rails_helper'
include ActiveJob::TestHelper

RSpec.describe InviteHandler::GuestInviteContact do
  context 'when contacting via email(async)' do
    before do
      ActiveJob::Base.queue_adapter = :test
      @service = described_class.build
      @cupping = create(:cupping)
      @invite = @cupping.invites.create(grader_email: 'test@me.com')
    end

    it 'adds a job to the mailers queue' do
      expect { @service.call(@invite, @cupping) }
        .to have_enqueued_job.on_queue('mailers')
    end

    it 'delivers the email' do
      inbox = ActionMailer::Base.deliveries
      expect do
        perform_enqueued_jobs { @service.call(@invite, @cupping) }
      end
        .to change(inbox, :length).by 1
    end
  end
end

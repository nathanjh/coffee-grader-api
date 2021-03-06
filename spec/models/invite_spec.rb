require 'rails_helper'

RSpec.describe Invite, type: :model do
  let(:invite) do
    host = create(:user)
    Invite.new(grader_id: create(:user).id,
                   cupping_id: create(:cupping, host_id: host.id).id)
  end
  describe 'attributes' do
    subject { invite }

    it { should respond_to(:grader_id) }
    it { should respond_to(:cupping_id) }
    it { should respond_to(:status) }
    it { should respond_to(:grader_email) }
    it { should respond_to(:invite_token) }

    describe '#status' do
      it "should have a default value of 'pending'" do
        expect(invite.status).to eq 'pending'
      end
      it "can be updated to 'accepted', 'declined', or 'maybe'" do
        expect { invite.update(status: 1) }
          .to change { invite.status }.from('pending').to('accepted')
        expect { invite.update(status: 2) }
          .to change { invite.status }.from('accepted').to('declined')
        expect { invite.update(status: 3) }
          .to change { invite.status }.from('declined').to('maybe')
      end
    end
  end

  describe 'validations' do
    subject { invite }

    it do
      should validate_uniqueness_of(:grader_id).scoped_to(:cupping_id)
        .with_message('has already been invited to this cupping')
        .allow_blank
    end

    it { should allow_value('okemail@valid.namespace.com').for(:grader_email) }
    it { should_not allow_value('notokatinvalid.@com').for(:grader_email) }

    context 'when grader_id is nil or blank' do
      before { subject.grader_id = nil }
      it { should validate_presence_of(:grader_email) }
    end

    context 'when grader_email is nil or blank' do
      before { subject.grader_email = '' }
      it { should validate_presence_of(:grader_id) }
    end
  end

  describe 'associations' do
    subject { invite }

    it { should belong_to(:grader) }
    it { should belong_to(:cupping) }
  end
end

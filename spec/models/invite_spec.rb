require 'rails_helper'

RSpec.describe Invite, type: :model do
  let(:invite) do
    host = create(:user)
    Invite.create!(grader_id: create(:user).id,
                   cupping_id: create(:cupping, host_id: host.id).id)
  end
  describe 'attributes' do
    subject { invite }

    it { should respond_to(:grader_id) }
    it { should respond_to(:cupping_id) }
    it { should respond_to(:status) }

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

  describe 'associations' do
    subject { invite }

    it { should belong_to(:grader) }
    it { should belong_to(:cupping) }
  end
end

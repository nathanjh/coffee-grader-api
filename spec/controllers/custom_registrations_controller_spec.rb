require 'rails_helper'

RSpec.describe CustomRegistrationsController, type: :controller do
  let!(:invite) do
    create(:cupping)
      .invites.create!(grader_email: 'test@me.com',
                       invite_token: 'epn4APKl-M9lcunNomaNkg')
  end

  let(:attributes_with_token) do
    attributes_for(:user, invite_token: 'epn4APKl-M9lcunNomaNkg')
  end

  describe 'POST #create' do
    before(:example) { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'with valid attributes' do
      it 'saves a user in the database' do
        expect { post :create, params: attributes_with_token, format: :json }
          .to change(User, :count).by(1)
      end

      context 'when user has a valid invite token' do
        it "sets corresponding invite's grader_id to user's id" do
          expect do
            post :create, params: attributes_with_token, format: :json
            invite.reload
          end
            .to change(invite, :grader_id)
        end
      end
    end
  end
end

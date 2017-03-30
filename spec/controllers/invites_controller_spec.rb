require 'rails_helper'

RSpec.describe InvitesController, type: :controller do
  let(:cupping) { create(:cupping) }
  let(:grader) { create(:user) }
  let(:invites) { create_list(:invite, 5, cupping_id: cupping.id) }
  let(:invite) { invites.first }

  let(:valid_attributes) do
    { cupping_id: cupping.id,
      grader_id: grader.id,
      status: :pending }
  end

  describe 'GET #index' do
    it 'returns all invites as @invites' do
      invites
      get :index, params: { cupping_id: cupping.id }, format: :json
      expect(assigns(:invites)).to eq invites
    end
  end

  describe 'GET #show' do
    it 'assigns the requested invite as @invite' do
      get :show, params: { cupping_id: cupping.id, id: invite.id }
      expect(assigns(:invite)).to eq invite
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves an invite in the database' do
        expect do
          post :create, params: {
            invite: { grader_id: grader.id,
                      status: :pending },
            cupping_id: cupping.id
          }, format: :json
        end
          .to change(Invite, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new invite in the database" do
        expect do
          post :create, params: { cupping_id: cupping.id,
                                  invite: { grader_id: nil } }, format: :json
        end
          .not_to change(Invite, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'locates the requested invite' do
        patch :update, params: { id: invite,
                                 cupping_id: cupping.id,
                                 invite: attributes_for(:invite) }, format: :json
        expect(assigns(:invite)).to eq(invite)
      end

      it "updates the invite's attributes" do
        patch :update, params: { id: invite,
                                 cupping_id: cupping.id,
                                 invite: { status: :accepted } }, format: :json
        invite.reload
        expect(invite.status).to eq("accepted")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'locates the invite' do
      delete :destroy, params: { id: invite,
                                 cupping_id: cupping.id },
                       format: :json
      expect(assigns(:invite)).to eq(invite)
    end

    it 'deletes the invite from the database' do
      invites
      expect do
        delete :destroy, params: { id: invite,
                                   cupping_id: cupping.id },
                         format: :json
      end
        .to change(Invite, :count).by(-1)
    end
  end
end

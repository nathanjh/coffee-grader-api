require 'rails_helper'

RSpec.describe 'Invites API', type: :request do
  # invite requires cupping, and a user as grader
  let(:cupping) { create(:cupping) }
  let(:grader) { create(:user) }
  let(:invites) { create_list(:invite, 5, cupping_id: cupping.id) }
  let(:invite) { invites.first }

  describe 'GET /cuppings/:cupping_id/invites' do
    before do
      invites
      get cupping_invites_path(cupping)
    end

    it 'returns all invites' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /cuppings/:cupping_id/invites/:id' do
    context 'when invite exists' do
      before do
        invites
        get cupping_invite_path(cupping, invite)
      end

      it 'returns the cupped_coffee' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(invite.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the invite does not exist' do
      before :each do
        invite_id = 1_000_000
        get "/cuppings/#{cupping.id}/invites/#{invite_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Invite/)
      end
    end
  end

  describe 'POST /cuppings/:cupping_id/invites' do
    let(:valid_attributes) do
      { cupping_id: cupping.id,
        grader_id: grader.id,
        status: :pending }
    end

    context 'with valid attributes' do
      before :each do
        post cupping_invites_path(cupping), params:
          { invite: valid_attributes }
      end

      it 'returns the invite status' do
        expect(json['status']).to eq("pending")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invaild attributes' do
      before :each do
        post cupping_invites_path(cupping), params: { invite: {cupping_id: nil, grader_id: nil, status: :pending} }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Grader must exist/)
      end
    end
  end

  describe 'PATCH /cuppings/:cupping_id/invites/:id' do
    let(:valid_attributes) { { status: :accepted } }

    context 'with vaild attributes' do
      before :each do
        patch cupping_invite_path(cupping, invite),
              params: { invite: valid_attributes }
      end

      it 'updates the invite' do
        updated_invite = Invite.find(invite.id)
        expect(updated_invite.status).to eq('accepted')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'with invalid attributes' do
      before :each do
        patch cupping_invite_path(cupping, invite),
              params: { invite: { grader_id: 100_000_000 } }
              # tried changing status to "hellyeah", but it wouldn't let me
      end

      it 'returns a vaildation failure message' do
        expect(response.body).to match(/Validation failed:/)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /cuppings/:cupping_id/invites/:id' do
    it 'returns status code 204' do
      delete "/cuppings/#{cupping.id}/invites/#{invite.id}"
      expect(response).to have_http_status(204)
    end
  end
end

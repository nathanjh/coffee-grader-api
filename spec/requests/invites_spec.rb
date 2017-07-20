require 'rails_helper'

RSpec.describe 'Invites API', type: :request do
  # invite requires cupping, and a user as grader
  let(:cupping) { create(:cupping) }
  let(:host) { cupping.host }
  let(:grader) { create(:user) }
  let(:invites) { create_list(:invite, 5, cupping_id: cupping.id) }
  let(:invite) { create(:invite, cupping_id: cupping.id, grader_id: grader.id) }

  shared_examples 'restricted access to invites' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  shared_examples 'restricted access when cupping is closed' do
    it 'returns status code 400' do
      expect(response).to have_http_status(400)
    end

    it 'returns an error message' do
      expect(response.body).to match(/Cupping is closed/)
    end
  end

  describe 'GET /cuppings/:cupping_id/invites' do
    context 'with valid auth token' do
      before do
        invites
        get cupping_invites_path(cupping), headers: auth_headers(host)
      end

      it 'returns all invites' do
        expect(json['invites']).not_to be_empty
        expect(json['invites'].size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'without valid auth token' do
      before { get cupping_invites_path(cupping) }

      it_behaves_like 'restricted access to invites'
    end
  end

  describe 'GET /cuppings/:cupping_id/invites/:id' do
    context 'with valid auth token' do
      context 'when invite exists' do
        before do
          invites
          get cupping_invite_path(cupping, invite),
              headers: auth_headers(grader)
        end

        it 'returns the invite' do
          expect(json['invite']).not_to be_empty
          expect(json['invite']['id']).to eq(invite.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the invite does not exist' do
        before :each do
          invite_id = 1_000_000
          get "/cuppings/#{cupping.id}/invites/#{invite_id}",
              headers: auth_headers(grader)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Invite/)
        end
      end
    end

    context 'without valid auth token' do
      before { get cupping_invite_path(cupping, invite) }

      it_behaves_like 'restricted access to invites'
    end
  end

  describe 'POST /cuppings/:cupping_id/invites' do
    let(:valid_attributes) do
      { cupping_id: cupping.id,
        grader_id: grader.id,
        status: :pending }
    end
    context 'with valid auth token' do
      context 'with valid attributes' do
        before :each do
          post cupping_invites_path(cupping),
               params: { invite: valid_attributes },
               headers: auth_headers(host)
        end

        it 'returns the invite status' do
          expect(json['invite']['status']).to eq('pending')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        context 'when no grader account and grader_email is provided' do
          it 'sets an invite token' do
            post cupping_invites_path(cupping),
                 params: { invite: { grader_email: 'jen@isawesome.com' } },
                 headers: auth_headers(host)
            expect(json['invite']['invite_token']).not_to be_blank
          end
        end
      end

      context 'with invalid attributes' do
        before :each do
          post cupping_invites_path(cupping),
               params: { invite: { grader_id: 1_000_000,
                                   status: :pending } },
               headers: auth_headers(host)
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed:/)
        end
      end
    end

    context "when logged in, but not as cupping's host" do
      before do
        post cupping_invites_path(cupping),
             params: { invite: valid_attributes },
             headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access to invites'
    end

    context 'without valid auth token' do
      before { post cupping_invites_path(cupping) }

      it_behaves_like 'restricted access to invites'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        post cupping_invites_path(cupping),
             params: { invite: valid_attributes },
             headers: auth_headers(host)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'PATCH /cuppings/:cupping_id/invites/:id' do
    let(:valid_attributes) { { status: :accepted } }

    context 'with valid auth token' do
      context 'with valid attributes' do
        before :each do
          patch cupping_invite_path(cupping, invite),
                params: { invite: valid_attributes },
                headers: auth_headers(grader)
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
                params: { invite: { grader_email: 'invalid.email@fail' } },
                headers: auth_headers(host)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed:/)
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when logged in, but not as cupping host or invited grader' do
      let(:other) { create(:user) }

      before :each do
        patch cupping_invite_path(cupping, invite),
              params: { invite: valid_attributes },
              headers: auth_headers(other)
      end

      it_behaves_like 'restricted access to invites'
    end

    context 'without valid auth token' do
      before { patch cupping_invite_path(cupping, invite) }

      it_behaves_like 'restricted access to invites'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        patch cupping_invite_path(cupping, invite),
              params: { invite: valid_attributes },
              headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'DELETE /cuppings/:cupping_id/invites/:id' do
    context 'with valid auth token' do
      it 'returns status code 204' do
        delete "/cuppings/#{cupping.id}/invites/#{invite.id}",
               headers: auth_headers(host)
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete cupping_invite_path(cupping, invite) }

      it_behaves_like 'restricted access to invites'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        delete cupping_invite_path(cupping, invite), headers: auth_headers(host)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end

    context "when logged in, but not as cupping's host" do
      before do
        delete cupping_invite_path(cupping, invite),
               headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access to invites'
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1::ProfilesController do
  let(:user) { create(:user) }
  let(:profile) { user.profile }
  let(:another_user) { create(:user) }
  let(:another_profile) { another_user.profile }

  describe 'show' do
    context 'when no user logged-in' do
      it 'returns 302 (Permanent Redirect)' do
        get :show, id: profile.id
        expect(response.status).to eq 302
      end
    end

    context 'when different user logged-in' do
      before { sign_in another_user }
      it 'returns 401 (unauthorized)' do
        get :show, id: profile.id
        expect(response.status).to eq 401
      end
    end

    context 'when user logged-in' do
      before { sign_in user }
      it 'returns profile' do
        get :show, id: profile.id
        expect(response_body[:profile][:id]).to eq profile.id
      end

      context 'with invalid profile id' do
        it 'returns 404 (RecordNotFound)' do
          get :show, id: 'a123'
          expect(response.status).to eq 404
        end
      end

      context 'when different profile id is requested' do
        it 'returns 401 (unauthorized)' do
          get :show, id: another_profile.id
          expect(response.status).to eq 401
        end
      end
    end
  end

  describe 'update' do
    context 'when user logged-in' do
      before { sign_in user }
      let(:profile_attributes) { attributes_for(:profile) }
      it 'updates profile attributes' do
        put :update, id: profile.id, profile: profile_attributes
        updated_profile = response_body[:profile]
        expect(updated_profile[:id]).to eq profile.id
        expect(updated_profile[:country_id]).to eq profile_attributes[:country_id]
        expect(updated_profile[:sex_id]).to eq profile_attributes[:sex_id]
        expect(updated_profile[:birth_date]).to eq profile_attributes[:birth_date].to_date.to_s
      end
      context 'with available locale for country' do
        before { profile_attributes[:country_id] = 'IT' }
        it "sets the first country's language as locale" do
          put :update, id: profile.id, profile: profile_attributes
          expect(I18n.locale).to eq :it
        end
        after { I18n.locale = :en }
      end
      context 'with unavailable locale for country' do
        before { profile_attributes[:country_id] = 'IN' }
        it 'sets locale to default' do
          put :update, id: profile.id, profile: profile_attributes
          expect(I18n.locale).to eq I18n.default_locale
        end
      end

      context 'when some attribute is invalid' do
        before { profile_attributes[:sex_id] = 'blah' }
        it 'returns 422 (unprocessable_entity)' do
          put :update, id: profile.id, profile: profile_attributes
          expect(response.status).to eq 422
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1::CheckinsController do
  let!(:user) { create(:user) }
  let(:date) { '2016-01-06' }

  before { sign_in user }

  describe 'index' do
    context 'when checkin exists for the requested date' do
      before { create(:checkin, date: Date.parse(date), user_id: user.id) }
      it 'returns correct checkin' do
        get :index, date: date
        expect(response_body[:checkins].count).to eq 1
        returned_checkin = response_body[:checkins][0]
        expect(Date.parse(returned_checkin[:date])).to eq Date.parse(date)
      end
    end
    context "when checkin doesn't exist for the passed date" do
      it 'returns no results' do
        get :index, date: date
        expect(response_body[:checkins].count).to eq 0
      end
    end
  end

  describe 'create' do
    it 'returns new checkin' do
      post :create, checkin: { date: date }
      returned_checkin = response_body[:checkin]
      expect(Date.parse(returned_checkin[:date])).to eq Date.parse(date)
    end
  end

  describe 'update' do
    let(:checkin) { create(:checkin, user_id: user.id, date: Time.zone.today) }
    let(:attributes) { { id: checkin.id, checkin: { note: 'Blah' } } }
    it 'returns updated checkin' do
      put :update, attributes
      returned_checkin = response_body[:checkin]
      expect(returned_checkin[:id]).to eq checkin.id.to_s
      expect(returned_checkin[:note]).to eq attributes[:checkin][:note]
    end
  end

  context 'show' do
    describe 'for new user' do
      let(:new_user) { create(:user) }
      let(:checkin) { create(:checkin, user_id: new_user.id, date: Time.zone.today) }
      let(:attributes) { { id: checkin.id } }

      it 'promotion visiability' do
        get :show, attributes
        returned_checkin = response_body[:checkin]
        expect(returned_checkin[:available_for_pr]).to be false
        expect(returned_checkin[:promotion_skipped_at].blank?).to be true
        expect(returned_checkin[:promotion_rate_id].blank?).to be true
      end
    end

    describe 'for user created_at 1 week ago' do
      let(:old_user) { create(:user, created_at: 1.week.ago) }

      context 'Promotion rate' do
        let(:checkin) { create(:checkin, user_id: old_user.id, date: Time.zone.today) }
        let(:attributes) { { id: checkin.id } }

        describe 'start visiability' do
          it 'should be available' do
            get :show, attributes
            returned_checkin = response_body[:checkin]
            expect(returned_checkin[:available_for_pr]).to be true
            expect(returned_checkin[:promotion_skipped_at].blank?).to be true
            expect(returned_checkin[:promotion_rate_id].blank?).to be true
          end
        end

        describe 'skipped promotion rate' do
          let(:checkin) { create(:checkin, promotion_skipped_at: Time.now.utc) }

          it 'with skipped promotion rate' do
            get :show, attributes
            returned_checkin = response_body[:checkin]
            expect(returned_checkin[:available_for_pr]).to be false
            expect(returned_checkin[:promotion_rate_id].blank?).to be true
          end
        end

        describe 'skipped promotion becomes available' do
          let(:checkin) { create(:checkin, date: Time.zone.today, promotion_skipped_at: (Time.zone.today - 1.week)) }
          let(:attributes) { { id: checkin.id } }

          it 'returns false after skipped promotion rate for 1 week' do
            get :show, attributes
            returned_checkin = response_body[:checkin]
            expect(returned_checkin[:available_for_pr]).to be true
          end
        end

        describe 'rated promotion becomes unavailable' do
          let(:checkin) { create(:checkin, date: Time.zone.today) }
          let!(:promotion_rate) { create(:promotion_rate, checkin_id: checkin) }
          let(:attributes) { { id: checkin.id } }

          it 'returns false if user has rated' do
            get :show, attributes
            returned_checkin = response_body[:checkin]
            expect(returned_checkin[:promotion_rate_id]).to eq promotion_rate.id.to_s
            expect(returned_checkin[:available_for_pr]).to be false
          end
        end
      end
    end
  end
end

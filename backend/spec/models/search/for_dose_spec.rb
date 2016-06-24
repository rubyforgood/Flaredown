require 'rails_helper'

RSpec.describe Search::ForDose, type: :model do

  let!(:checkins) { create_list(:checkin, 3) }
  let!(:treatment) { create(:checkin_treatment, checkin: checkins[0], is_taken: true, value: '2 x 10 mg') }
  let!(:other_dose_1) { create(:checkin_treatment, checkin: checkins[1], is_taken: true, treatment_id: treatment.treatment_id) }
  let!(:other_dose_2) { create(:checkin_treatment, checkin: checkins[2], is_taken: true, treatment_id: treatment.treatment_id) }
  let(:all_treatment_doses) { [treatment.value] + [other_dose_1.value, other_dose_2.value] }
  let(:params) { { resource: 'dose', query: { treatment_id: treatment.treatment_id, name: '2 x' } } }

  subject { Search::ForDose.new(params) }

  context 'without treatment_id param' do
    before { params[:query].delete(:treatment_id) }
    it { is_expected.not_to be_valid }
  end

  context 'without name param' do
    before { params[:query].delete(:name) }
    it 'returns all doses for the requested treatment' do
      returned_doses = subject.searchables.map(&:name)
      expect(returned_doses.to_set).to eq all_treatment_doses.compact.to_set
    end
  end

  context 'with name param' do
    it 'returns matching doses for the requested treatment' do
      returned_doses = subject.searchables.map(&:name)
      expect(returned_doses).to include treatment.value
    end
  end

end

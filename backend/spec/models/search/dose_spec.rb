require 'rails_helper'

RSpec.describe Search::Dose, type: :model do

  let!(:checkin) { create(:checkin) }
  let!(:treatment) { create(:checkin_treatment, checkin: checkin, is_taken: true, value: '2 x 10 mg') }
  let!(:other_treatments) { create_list(:checkin_treatment, 2, checkin: checkin, is_taken: true, treatment_id: treatment.treatment_id) }
  let(:all_treatment_doses) { [treatment.value] + other_treatments.map(&:value) }
  let(:params) { { resource: 'dose', query: { treatment_id: treatment.treatment_id, name: '2 x' } } }

  subject { Search::Dose.new(params) }

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

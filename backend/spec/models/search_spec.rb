require 'rails_helper'

RSpec.describe Search, type: :model do

  let(:user) { create(:user) }
  let(:treatment) { create(:user_treatment, user: user).treatment }
  let(:params) do
    ActionController::Parameters.new(
      resource: 'treatment',
      query: {
        name: 'mediterr'
      },
      user: user
    )
  end

  before { treatment.update_attributes!(name: 'Mediterranean Diet') }

  subject { Search.new(params) }

  it 'returns matching treatment' do
    returned_treatment_names = subject.searchables.map(&:name)
    expect(returned_treatment_names).to include treatment.name
  end

end

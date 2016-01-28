# == Schema Information
#
# Table name: user_symptoms
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  symptom_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserSymptom, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:symptom) }
  end
end

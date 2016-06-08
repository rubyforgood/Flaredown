# == Schema Information
#
# Table name: symptoms
#
#  id                     :integer          not null, primary key
#  global                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  trackable_usages_count :integer          default(0)
#

require 'rails_helper'

RSpec.describe Symptom, type: :model do
  describe 'Respond to' do
    it { is_expected.to respond_to(:name) }
  end
end

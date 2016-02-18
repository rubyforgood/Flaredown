# == Schema Information
#
# Table name: conditions
#
#  id         :integer          not null, primary key
#  global     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Condition do
  describe 'Respond to' do
    it { is_expected.to respond_to(:name) }
  end

  describe 'Translations' do
    before { I18n.locale = locale }
    subject { create(:condition) }

    context "with 'en' as current locale" do
      let(:locale) { :en }
      it "stores name with 'en' locale" do
        t = subject.translations.to_a
        expect(t.size).to eq 1
        expect(t[0].locale).to eq locale
      end
    end

    context "with 'it' as current locale" do
      let(:locale) { :it }
      it "stores name with 'it' locale" do
        t = subject.translations.to_a
        expect(t.size).to eq 1
        expect(t[0].locale).to eq locale
      end
    end
  end
end

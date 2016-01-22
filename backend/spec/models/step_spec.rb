require 'rails_helper'

RSpec.describe Step do

  context 'onboarding' do
    let(:onboarding_steps) { Step.by_group(:onboarding) }
    context 'first step' do
      subject { onboarding_steps.first }
      it 'has no previous step' do
        expect(subject.prev_id).to be_nil
      end
      it 'has next step' do
        expect(subject.next_id).to be_present
      end
    end
    context 'intermediate step' do
      subject { onboarding_steps[1] }
      it 'has previous step' do
        expect(subject.prev_id).to be_present
      end
      it 'has next step' do
        expect(subject.next_id).to be_present
      end
    end
    context 'last step' do
      subject { onboarding_steps.last }
      it 'has previous step' do
        expect(subject.prev_id).to be_present
      end
      it 'has no next step' do
        expect(subject.next_id).to be_nil
      end
    end
  end

  context 'checkin' do
    let(:checkin_steps) { Step.by_group(:checkin) }
    context 'first step' do
      subject { checkin_steps.first }
      it 'has no previous step' do
        expect(subject.prev_id).to be_nil
      end
      it 'has next step' do
        expect(subject.next_id).to be_present
      end
    end
    context 'intermediate step' do
      subject { checkin_steps[1] }
      it 'has previous step' do
        expect(subject.prev_id).to be_present
      end
      it 'has next step' do
        expect(subject.next_id).to be_present
      end
    end
    context 'last step' do
      subject { checkin_steps.last }
      it 'has previous step' do
        expect(subject.prev_id).to be_present
      end
      it 'has no next step' do
        expect(subject.next_id).to be_nil
      end
    end
  end

end

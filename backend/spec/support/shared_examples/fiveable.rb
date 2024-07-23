require 'spec_helper'

shared_examples_for 'fiveable' do
  include Mongoid::Matchers

  it { is_expected.to respond_to(:value) }
  it { is_expected.to validate_inclusion_of(:value).to_allow(0..4) }
end

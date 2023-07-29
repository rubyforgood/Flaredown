require "rails_helper"

class MockClassSkeleton < RankedEnum
end

class MockClassOverride < RankedEnum
  class << self
    def all_ids
      %w[one two three]
    end
  end
end


RSpec.describe RankedEnum do
  describe MockClassSkeleton do
    it 'yields all IDs associated with the class' do
      all_ids = MockClassSkeleton.all_ids

      expect(all_ids).to eq []
    end
  end

  describe MockClassOverride do
    it 'yields all IDs associated with the class' do
      all_ids = MockClassOverride.all_ids

      expect(all_ids).to eq ['one', 'two', 'three']
    end

    it 'searches for a specific ID' do
      searched_id = MockClassOverride.find('two')

      expect(searched_id.id).to eq 'two'
    end

    # TODO: Actually make this test grab the cache
    it 'prints out all IDs from cache' do
      all_ids = MockClassOverride.all

      expect(all_ids.size).to eq 3
      expect(all_ids.last.id).to eq 'three'
    end

    it 'creates a translatable name (that does not exist in the code base)for a ranked enum model instance' do
      mock = MockClassOverride.new('some-id', 'some-rank')

      expect(mock.name).to eq 'translation missing: en.mock_class_override.some-id'
    end
  end
end
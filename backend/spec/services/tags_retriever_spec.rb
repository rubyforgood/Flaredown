require 'rails_helper'

RSpec.describe TagsRetriever do

  describe 'most_popular' do
    let(:tags) { create_list(:tag, 20) }
    let(:tag_ids) { tags.map(&:id) }

    before do
      5.times do
        create(:checkin, tag_ids: tag_ids.sample(5))
      end
    end

    subject { TagsRetriever.new(:most_popular) }

    it 'retrieves the most popular tags' do
      retrieved_tags = subject.retrieve
      expect(retrieved_tags.first).to be_a Tag
      popular_tag_ids = retrieved_tags.map(&:id)
      non_popular_tag_ids = tag_ids - popular_tag_ids
      min_occurrence = subject.occurrences.to_a.last['count']
      non_popular_tag_ids.each do |tag_id|
        expect(occurrences_for(tag_id)).to be <= min_occurrence
      end
    end

    it 'limits results to 10' do
      retrieved_tags = subject.retrieve
      expect(retrieved_tags.count).to eq 10
    end

    it 'makes occurrences counts available after retrieve' do
      subject.retrieve
      max_occurrence = subject.occurrences.to_a.first['count']
      min_occurrence = subject.occurrences.to_a.last['count']
      expect(min_occurrence).to be < max_occurrence
      subject.occurrences.each do |o|
        expected_count = occurrences_for(o['_id'])
        expect(o['count']).to eq expected_count
      end
    end
  end

  def occurrences_for(tag_id)
    Checkin.where(tag_ids: { "$elemMatch" => { "$eq" => tag_id } }).count
  end

end

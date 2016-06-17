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

  describe 'most_recent' do
    let(:user) { create(:user) }
    let(:tags) { create_list(:tag, 20) }
    let(:tag_ids) { tags.map(&:id) }

    before do
      today = Date.today
      (0..4).each do |i|
        create(:checkin, user_id: user.id, date: today+i.days, tag_ids: [tag_ids[i], tag_ids[i+5]])
      end
    end

    subject { TagsRetriever.new(:most_recent, user) }

    it 'retrieves the most recent tags for the given user' do
      subject.retrieve
      retrieved_tags = subject.retrieve
      expect(retrieved_tags.first).to be_a Tag
      retrieved_tag_ids = retrieved_tags.map(&:id)
      expect(retrieved_tag_ids.to_set).to eq tag_ids.slice(0..9).to_set
      expect(retrieved_tag_ids).not_to include tag_ids.slice(10..19)
    end
  end

end

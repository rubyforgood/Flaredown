require 'rails_helper'

MODELS = [Food, Tag].freeze

def occurrences_for(object_id, ids_key)
  Checkin.where(ids_key => { "$elemMatch" => { "$eq" => object_id } }).count
end

describe CollectionRetriever do
  let(:retrieved_objects) { subject.retrieve }

  MODELS.each do |model|
    model_name = model.name
    model_slug = model_name.underscore
    ids_key = "#{model_slug}_ids"
    all_objects_are_model = "all objects are #{model_name}"

    context model_name do
      shared_examples all_objects_are_model do
        it { expect(subject.retrieve.map(&:class).uniq.map(&:name)).to eq([model_name]) }
      end

      describe 'most_popular' do
        let(:objects) { create_list(model_slug, 20) }
        let(:object_ids) { objects.map(&:id) }

        before do
          5.times do
            create(:checkin, ids_key => object_ids.sample(5))
          end
        end

        subject { described_class.new(model, :most_popular) }

        it_behaves_like all_objects_are_model

        it 'retrieves the most popular' do
          popular_object_ids = retrieved_objects.map(&:id)
          non_popular_object_ids = object_ids - popular_object_ids
          min_occurrence = subject.occurrences.to_a.last['count']
          non_popular_object_ids.each do |object_id|
            expect(occurrences_for(object_id, ids_key)).to be <= min_occurrence
          end
        end

        it 'limits results to 10' do
          expect(retrieved_objects.count).to eq 10
        end

        it 'makes occurrences counts available after retrieve', pending: ENV['FIX_TRAVIS'] do
          subject.retrieve
          max_occurrence = subject.occurrences.to_a.first['count']
          min_occurrence = subject.occurrences.to_a.last['count']
          expect(min_occurrence).to be < max_occurrence
          subject.occurrences.each do |o|
            expected_count = occurrences_for(o['_id'], ids_key)
            expect(o['count']).to eq expected_count
          end
        end
      end

      describe 'most_recent' do
        let(:user) { create(:user) }
        let(:objects) { create_list(model_slug, 20) }
        let(:object_ids) { objects.map(&:id) }

        before do
          today = Time.zone.today
          (0..4).each do |i|
            create(
              :checkin,
              :user_id => user.id,
              :date => today + i.days,
              ids_key => [object_ids[i], object_ids[i + 5]]
            )
          end
        end

        subject { described_class.new(model, :most_recent, user) }

        it_behaves_like all_objects_are_model

        it 'retrieves the most recent objects for the given user' do
          retrieved_object_ids = retrieved_objects.map(&:id)
          expect(retrieved_object_ids.to_set).to eq object_ids.slice(0..9).to_set
          expect(retrieved_object_ids).not_to include object_ids.slice(10..19)
        end
      end
    end
  end
end

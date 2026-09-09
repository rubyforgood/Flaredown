require "rails_helper"

MODELS = [Food, Tag].freeze

def occurrences_for(object_id, ids_key)
  Checkin.where(ids_key => {"$elemMatch" => {"$eq" => object_id}}).count
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

      describe "most_popular" do
        let(:objects) { create_list(model_slug, 20) }
        let(:object_ids) { objects.map(&:id) }

        # Nested slices give every object a known occurrence count. The first 2
        # objects land in all five check-ins, the next 3 in four of them, and so
        # on, so the counts run:
        #
        #   5 5 | 4 4 4 | 3 3 3 3 3 || 2 2 2 2 2 | 1 1 1 1 1
        #
        # The top ten therefore have a real spread (5 down to 3), and the tenth
        # and eleventh differ (3 vs 2), so the `$limit 10` in
        # CollectionRetriever#most_popular never has to break a tie at the
        # cut-off. `object_ids.sample(5)` left both of those to chance.
        before do
          [20, 15, 10, 5, 2].each do |size|
            create(:checkin, ids_key => object_ids.first(size))
          end
        end

        subject { described_class.new(model, :most_popular) }

        it_behaves_like all_objects_are_model

        it "retrieves the most popular" do
          popular_object_ids = retrieved_objects.map(&:id)
          non_popular_object_ids = object_ids - popular_object_ids
          min_occurrence = subject.occurrences.to_a.last["count"]
          non_popular_object_ids.each do |object_id|
            expect(occurrences_for(object_id, ids_key)).to be <= min_occurrence
          end
        end

        it "limits results to 10" do
          expect(retrieved_objects.count).to eq 10
        end

        it "makes occurrences counts available after retrieve" do
          subject.retrieve

          # Which objects tie at a given count is not defined -- the aggregation
          # sorts on count alone -- but the counts themselves are.
          expect(subject.occurrences.map { |o| o["count"] }).to eq [5, 5, 4, 4, 4, 3, 3, 3, 3, 3]

          subject.occurrences.each do |o|
            expected_count = occurrences_for(o["_id"], ids_key)
            expect(o["count"]).to eq expected_count
          end
        end
      end

      describe "most_recent" do
        let(:user) { create(:user) }
        let(:objects) { create_list(model_slug, 20) }
        let(:object_ids) { objects.map(&:id) }

        before do
          today = Time.zone.today
          5.times do |i|
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

        it "retrieves the most recent objects for the given user" do
          retrieved_object_ids = retrieved_objects.map(&:id)
          expect(retrieved_object_ids.to_set).to eq object_ids.slice(0..9).to_set
          expect(retrieved_object_ids).not_to include object_ids.slice(10..19)
        end
      end
    end
  end
end

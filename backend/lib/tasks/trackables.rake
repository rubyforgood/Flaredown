namespace :trackables do
  desc 'flaredown | merge trackables'

  TRACKABLE_TYPES = %w(condition symptom treatment).freeze

  task merge: :environment do
    TRACKABLE_TYPES.map { |trackable_type| MergeTrackables::Dispatcher.perform_async(trackable_type) }
  end
end

namespace :trackables do
  desc 'flaredown | merge trackables'

  TRACKABLE_TYPES = %w(condition symptom treatment).freeze

  task :merge, [:trackable_type] => :environment do |t, args|
    trackable_type = args[:trackable_type]

    abort MergeTrackables::Dispatcher.perform_async(trackable_type) if trackable_type.present?

    TRACKABLE_TYPES.map { |trackable_type| MergeTrackables::Dispatcher.perform_async(trackable_type) }
  end

  task :list_same_trackabels, [:trackable_type, :translation] => :environment do |t, args|
    trackable_type = args[:trackable_type]
    translation = args[:translation]

    trackable_class = trackable_type.capitalize.constantize

    SameTrackablesJob.perform_async(trackable_type: trackable_type, translation: translation)
  end
end

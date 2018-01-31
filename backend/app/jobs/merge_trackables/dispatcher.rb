class MergeTrackables::Dispatcher
  include Sidekiq::Worker

  def perform(trackable_type, translation=nil)
    trackable_class = trackable_type.capitalize.constantize

    return find_duplicates(trackable_type, trackable_class, translation) if translation.present?

    trackable_class::Translation.find_each do |trackable_translation|
      translation = trackable_translation.name
      next unless translation

      find_duplicates(trackable_type, trackable_class, translation)
    end
  end

  def find_duplicates(trackable_type, trackable_class, translation)
    begin
      escaped_translation = Regexp.escape(translation.squish).split(' ').join('s+')
      regex =  "^\\s*#{escaped_translation}\\s*$"

      same_translations = trackable_class::Translation.where("name ~* ?", regex)

      return if same_translations.length <= 1 # Next step if origin found only

      same_trackables = trackable_class
        .where(id: same_translations.where(locale: 'en').select("#{trackable_type}_id".to_sym))
        .order(trackable_usages_count: :desc, id: :asc)

      parent, *rest = same_trackables
      return if parent.nil? || rest.length.zero?

      p "DUPLICATES FOUND..."
      p "#{trackable_type.capitalize} ids: #{same_trackables.pluck(:id)}"
      p "#{trackable_type.capitalize} translations: #{same_trackables.map(&:name)}"

      rest_ids = rest.map(&:id)

      # Remove duplicates from translations
      same_translations.where(:"#{trackable_type}_id" => rest_ids).map(&:destroy)
    rescue ActiveRecord::StatementInvalid
      return
    end

    p "PERFORM MergeTrackables::UserTrackableAssociation"
    MergeTrackables::UserTrackableAssociation.perform_async(trackable_type, parent.id, rest_ids)
  end
end

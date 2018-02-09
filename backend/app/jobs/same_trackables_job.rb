class SameTrackablesJob
  include Sidekiq::Worker

  def perform(options)
    trackable_type = options["trackable_type"]
    translation = options["translation"]

    trackable_class = trackable_type.capitalize.constantize
    searchable_attr = trackable_class.name == 'Food' ? 'long_desc' : 'name'

    [].tap do |array|
      if translation.present?
        array << find_duplicates(trackable_class, translation, searchable_attr)
      else
        trackable_class::Translation.find_each do |trackable_translation|
          translation_value = trackable_translation.send(searchable_attr.to_s)

          duplicates = find_duplicates(trackable_class, translation_value, searchable_attr)
          array << duplicates if duplicates.present?
        end
      end

      p "Same #{trackable_type.pluralize.camelize}: "
      p array.uniq
    end
  end

  def find_duplicates(trackable_class, translation, searchable_attr = 'name')
    escaped_translation = Regexp.escape(translation.squish).split(' ').join('s+')
    regex = "^\\s*#{escaped_translation}\\s*$"

    same_translations = trackable_class::Translation.where("#{searchable_attr} ~* ?", regex)
    same_translations.map(&:"#{searchable_attr}") if same_translations.length > 1
  rescue ActiveRecord::StatementInvalid
    return
  end
end

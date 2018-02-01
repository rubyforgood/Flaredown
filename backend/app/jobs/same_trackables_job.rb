class SameTrackablesJob
  include Sidekiq::Worker

  def perform(options)
    trackable_type = options["trackable_type"]
    translation = options["translation"]

    trackable_class = trackable_type.capitalize.constantize

    [].tap do |array|
      if translation.present?
        array << find_duplicates(trackable_class, translation)
      else
        trackable_class::Translation.find_each do |trackable_translation|
          duplicates = find_duplicates(trackable_class, trackable_translation.name)
          array << duplicates if duplicates.present?
        end
      end

      p array.uniq
    end
  end

  def find_duplicates(trackable_class, translation)
    begin
      escaped_translation = Regexp.escape(translation.squish).split(' ').join('s+')
      regex =  "^\\s*#{escaped_translation}\\s*$"

      same_translations = trackable_class::Translation.where("name ~* ?", regex)
      same_translations.map(&:name) if same_translations.length > 1
    rescue ActiveRecord::StatementInvalid
      return
    end
  end
end

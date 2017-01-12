require 'csv'

namespace :utils do
  task csv_export: :environment do
    BATCH_SIZE = 200
    TRACKABLE_TYPES = %w(condition symptom treatment).freeze

    puts "Exporting data for #{User.count} users\n"

    CSV.open('export.csv', 'wb') do |csv|
      csv << %w(
        user_id age sex country checkin_date
        trackable_id trackable_type trackable_name trackable_value
      )

      User.includes(:profile).find_each(batch_size: BATCH_SIZE).with_index do |user, index|
        age = user.profile.age
        sex = user.profile.sex_id
        country = user.profile.country_id

        checkins = user.checkins.includes(:conditions, :symptoms, :treatments)
        checkin_ids = checkins.pluck(:id)

        trackable_names = TRACKABLE_TYPES
          .map do |trackable_type|
            trackable_type_capital = trackable_type.capitalize
            trackable_ids = "Checkin::#{trackable_type_capital}"
              .constantize
              .in(checkin_id: checkin_ids)
              .distinct(:"#{trackable_type}_id")

            translations_relation = :"#{trackable_type}_translations"

            [
              trackable_type,
              trackable_type_capital
                .constantize
                .where(id: trackable_ids)
                .includes(translations_relation)
                .map { |trackable| [trackable.id, trackable.send(translations_relation).first.name] }
                .to_h
            ]
          end
          .to_h

        tag_names = Tag.includes(:tag_translations).map { |t| [t.id, t.tag_translations.first.name] }.to_h

        checkins.each do |checkin|
          checkin_date = checkin.date.strftime('%Y-%m-%d')

          TRACKABLE_TYPES.each do |trackable_type|
            trackable_type_plural = trackable_type.pluralize
            trackable_type_capital = trackable_type.capitalize
            checkin_trackables = checkin.send(trackable_type_plural)

            checkin_trackables.each do |checkin_trackable|
              next if checkin_trackable.value.nil?

              trackable_id = checkin_trackable.send("#{trackable_type}_id")

              csv << [
                user.id, age, sex, country, checkin_date,
                trackable_id, trackable_type_capital,
                trackable_names[trackable_type][trackable_id], checkin_trackable.value
              ]
            end
          end

          checkin.tag_ids.each do |tag_id|
            csv << [
              user.id, age, sex, country, checkin_date,
              tag_id, 'Tag', tag_names[tag_id], nil
            ]
          end
        end

        print '.' if (index % BATCH_SIZE).zero?
      end
    end

    puts "\nDone."
  end
end

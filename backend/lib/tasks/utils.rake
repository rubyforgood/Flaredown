require 'csv'

namespace :utils do

  task csv_export: :environment do
    columns = %w(
      user_id checkin_date trackable_id trackable_type trackable_name trackable_value
    )
    CSV.open('export.csv', 'wb') do |csv|
      csv << columns
      User.all.each do |user|
        user.checkins.each do |checkin|
          checkin_date = checkin.date.strftime('%Y-%m-%d')
          %w( condition symptom treatment ).each do |trackable_type|
            trackable_type_plural = trackable_type.pluralize
            trackable_type_capital = trackable_type.capitalize
            trackable_class = trackable_type_capital.constantize
            checkin_trackables = checkin.send(trackable_type_plural)
            checkin_trackables.each do |checkin_trackable|
              next if checkin_trackable.value.nil?
              trackable_id = checkin_trackable.send("#{trackable_type}_id")
              trackable = trackable_class.find(trackable_id)
              record = [
                user.id, checkin_date,
                trackable_id, trackable_type_capital,
                trackable.name, checkin_trackable.value
              ]
              csv << record
            end
          end
          checkin.tag_ids.each do |tag_id|
            tag = Tag.find(tag_id)
            record = [
              user.id, checkin_date,
              tag_id, 'Tag', tag.name, nil
            ]
            csv << record
          end
        end
      end
    end
  end

end

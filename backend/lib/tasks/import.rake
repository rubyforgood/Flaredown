namespace :import do

  task from_json: :environment do
    Export.delete_all
    system('mongoimport -d flaredown_development -c exports --file exports.json --jsonArray')
  end

  task users_and_checkins: :environment do
    delete_users_and_checkins
    Export.all.each do |export|
      ImportUserJob.perform_later(export.id.to_s)
    end
  end

  def delete_users_and_checkins
    Rails.logger.info 'Deleting users and checkins... '
    Checkin::Condition.delete_all
    Checkin::Symptom.delete_all
    Checkin::Treatment.delete_all
    Checkin.delete_all
    User.destroy_all
    Rails.logger.info 'Done'
  end

end

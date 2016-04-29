namespace :oneoff do

  task build_trackable_usages: :environment do
    build_trackable_usages
  end

  def build_trackable_usages
    TrackableUsage.delete_all
    User.all.each do |user|
      Rails.logger.info("[#{__method__}] === #{user.email} ===")
      user.checkins.each do |checkin|
        Rails.logger.info("[#{__method__}] --- #{checkin.date.strftime('%Y-%m-%d')} ---")
        Rails.logger.info("[#{__method__}] --- Conditions ---")
        checkin.conditions.each do |condition|
          trackable = Condition.find(condition.condition_id)
          usage = TrackableUsage.create_or_update_by(user: user, trackable: trackable)
          Rails.logger.info("[#{__method__}] - #{trackable.name}: #{usage.count}")
        end
        Rails.logger.info("[#{__method__}] --- Treatments ---")
        checkin.symptoms.each do |symptom|
          trackable = Symptom.find(symptom.symptom_id)
          usage = TrackableUsage.create_or_update_by(user: user, trackable: trackable)
          Rails.logger.info("[#{__method__}] - #{trackable.name}: #{usage.count}")
        end
        Rails.logger.info("[#{__method__}] --- Symptoms ---")
        checkin.treatments.each do |treatment|
          trackable = Treatment.find(treatment.treatment_id)
          usage = TrackableUsage.create_or_update_by(user: user, trackable: trackable)
          Rails.logger.info("[#{__method__}] - #{trackable.name}: #{usage.count}")
        end
      end
    end
  end

end

class SetRecentDosesJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    Rails.logger.info("[BuildRecentDosesOut] user: #{user.email}")
    checkins = user.checkins.where(treatments: {"$ne" => []}).sort(date: 1)
    user.profile.most_recent_doses = build_most_recent_doses(checkins)
    user.profile.save!
    Rails.logger.info("[BuildRecentDosesOut] most_recent_doses: #{user.profile.reload.most_recent_doses}")
  end

  private

  def build_most_recent_doses(checkins)
    most_recent_doses = {}
    checkins.each do |checkin|
      treatments = checkin.treatments.where(is_taken: true, :value.nin => ["", nil])
      treatments.each do |treatment|
        most_recent_doses[treatment.treatment_id] = treatment.value
      end
    end
    most_recent_doses
  end

end

namespace :doses do

  task build_recent: :environment do
    build_recent
  end

  def build_recent
    User.all.pluck(:id).each do |user_id|
      SetRecentDosesJob.perform_later(user_id)
    end
  end

end

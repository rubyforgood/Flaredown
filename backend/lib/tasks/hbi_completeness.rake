namespace :app do
  desc 'flaredown | percentage of user completed HBI survey'
  task hbi_completeness: :environment do
    HBI_CONDITION = "Crohn's disease".freeze

    since = HarveyBradshawIndex.order_by(date: :asc).first.date
    hbi_count = HarveyBradshawIndex.count
    hbi_condition_id = Condition::Translation.find_by(name: HBI_CONDITION).condition_id
    checkin_ids = Checkin::Condition.where(condition_id: hbi_condition_id).distinct(:checkin_id)

    possible_checkins_count = Checkin.where(:date => (since..Date.today), :id.in => checkin_ids).count do |checkin|
      checkin.harvey_bradshaw_index.present? || chickin_was_available_for_hbi?(checkin)
    end

    puts 100.0 * hbi_count / possible_checkins_count
  end

  def chickin_was_available_for_hbi?(checkin)
    HarveyBradshawIndex.where(
      encrypted_user_id: checkin.encrypted_user_id,
      date: ((checkin.date - Checkin::HBI_PERIODICITY).next...(checkin.date))
    ).none?
  end
end

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
        Rails.logger.info("[#{__method__}] --- Symptoms ---")
        checkin.symptoms.each do |symptom|
          trackable = Symptom.find(symptom.symptom_id)
          usage = TrackableUsage.create_or_update_by(user: user, trackable: trackable)
          Rails.logger.info("[#{__method__}] - #{trackable.name}: #{usage.count}")
        end
        Rails.logger.info("[#{__method__}] --- Treatments ---")
        checkin.treatments.each do |treatment|
          trackable = Treatment.find(treatment.treatment_id)
          usage = TrackableUsage.create_or_update_by(user: user, trackable: trackable)
          Rails.logger.info("[#{__method__}] - #{trackable.name}: #{usage.count}")
        end
      end
    end
  end

  task fix_trackable_colors: :environment do
    fix_trackable_colors
  end
  # FIXME
  # rubocop:disable Metrics/AbcSize
  def fix_trackable_colors
    colors = (0..32).to_a
    User.all.each do |user|
      Rails.logger.info("[#{__method__}] === #{user.email} ===")
      colors_hash = Hash.new
      user.checkins.each do |checkin|
        Rails.logger.info("[#{__method__}] --- #{checkin.date.strftime('%Y-%m-%d')} ---")
        used_colors = Array.new
        fix_and_store_color_id = lambda do |checkin_trackable, trackable_type|
          trackable_id = checkin_trackable.send("#{trackable_type.downcase}_id")
          key = "#{trackable_type}-#{trackable_id}"
          if colors_hash[key].present?
            checkin_trackable.update_attributes!(color_id: colors_hash[key])
          else
            if checkin_trackable.color_id.nil?
              trackable = trackable_type.constantize.find(trackable_id)
              checkin_trackable.color_id = Flaredown::Colorable.color_id_for(trackable, user)
            end
            if used_colors.include?(checkin_trackable.color_id)
              if used_colors.count >= colors.count
                checkin_trackable.color_id = used_colors.count % colors.count
              else
                checkin_trackable.color_id = (colors - used_colors).sample
              end
            end
            checkin_trackable.save!
            colors_hash[key] = checkin_trackable.color_id
            used_colors << checkin_trackable.color_id
          end
        end
        Rails.logger.info("[#{__method__}] --- Conditions ---")
        checkin.conditions.each do |condition|
          fix_and_store_color_id.call(condition, "Condition")
        end
        Rails.logger.info("[#{__method__}] --- Symptoms ---")
        checkin.symptoms.each do |symptom|
          fix_and_store_color_id.call(symptom, "Symptom")
        end
        Rails.logger.info("[#{__method__}] --- Treatments ---")
        checkin.treatments.each do |treatment|
          fix_and_store_color_id.call(treatment, "Treatment")
        end
      end
      user.trackings.active_at(Time.now).each do |tracking|
        key = "#{tracking.trackable_type.downcase}-#{tracking.trackable_id}"
        tracking.update_attributes!(color_id: colors_hash[key]) if colors_hash[key].present?
      end
      Rails.logger.info("[#{__method__}] Colors: #{colors_hash}")
    end
  end
  # rubocop:enable Metrics/AbcSize

  task generate_screen_names: :environment do
    generate_screen_names
  end
  def generate_screen_names
    Profile.all.each do |profile|
      if profile.screen_name.blank?
        generated_screen_name = profile.user.email.split('@')[0]
        profile.update_attributes!(screen_name: generated_screen_name)
      end
    end
  end

  task remove_checkin_trackable_duplicates: :environment do
    remove_checkin_trackable_duplicates
  end
  def remove_checkin_trackable_duplicates
    [Checkin::Condition, Checkin::Symptom, Checkin::Treatment].each do |c|
      c.all.each do |trackable|
        key = "#{c.name.demodulize.downcase}_id"
        count = c.where(
          checkin: trackable.checkin,
          key.to_sym => trackable.send(key)
        ).count
        trackable.destroy if count > 1
      end
    end
  end

  task generate_trackable_positions: :environment do
    Checkin.all.each do |checkin|
      checkin.conditions.sort_by { |t| t.position.to_i }
        .each_with_index do |condition, i|
          condition.update_attributes!(position: i)
        end
      checkin.symptoms.sort_by { |t| t.position.to_i }
        .each_with_index do |symptom, i|
          symptom.update_attributes!(position: i)
        end
      checkin.treatments.sort_by { |t| t.position.to_i }
        .each_with_index do |treatment, i|
          treatment.update_attributes!(position: i)
        end
    end
  end

  task save_most_recent_trackables_positions: :environment do
    Profile.update_all(
      most_recent_conditions_positions: {},
      most_recent_symptoms_positions: {},
      most_recent_treatments_positions: {}
    )
    User.all.each do |user|
      latest_checkin = user.checkins.sort(date: -1).first
      next if latest_checkin.nil?
      latest_checkin.conditions.each_with_index do |cc, i|
        condition = Condition.find(cc.condition_id)
        user.profile.set_most_recent_condition_position(condition, cc.position || i)
      end
      latest_checkin.symptoms.each_with_index do |cs, i|
        symptom = Symptom.find(cs.symptom_id)
        user.profile.set_most_recent_symptom_position(symptom, cs.position || i)
      end
      latest_checkin.treatments.each_with_index do |ct, i|
        treatment = Treatment.find(ct.treatment_id)
        user.profile.set_most_recent_treatment_position(treatment, ct.position || i)
      end
      user.profile.save!
    end
  end

  task update_last_commented_for_posts: :environment do
    Post.where(_type: 'Post').each do |post|
      post.update(last_commented: post.created_at)
    end
  end

  task add_position_reference_to_checkins_and_weathers: :environment do
    add_position_reference_to_checkins
    add_position_reference_to_weathers
  end

  def add_position_reference_to_checkins
    Checkin.all.each do |checkin|
      postal_code = checkin.postal_code
      next if postal_code.nil? || postal_code.blank?

      PositionReferenceJob.perform_async('Checkin', checkin.id.to_s, postal_code)
    end
  end

  def add_position_reference_to_weathers
    Weather.find_each(batch_size: 500) do |weather|
      postal_code = weather.postal_code
      next if postal_code.nil? || postal_code.blank?

      PositionReferenceJob.perform_async('Weather', weather.id, postal_code)
    end
  end
end

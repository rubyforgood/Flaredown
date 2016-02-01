DAYS = 60
email = ENV['CHECKINS_FOR']
puts "email=#{email}"
if email.present?

  user = User.find_or_create_by(email: email)

  # Delete all Tracking, Checkin and Tag
  Tracking.destroy_all
  Checkin.destroy_all
  Checkin::Tag.destroy_all

  # Set locale to default
  I18n.locale = I18n.default_locale

  # Create some trackables (both global and personal)
  conditions = FactoryGirl.create_list(:user_condition, 2, user: user).map(&:condition)
  conditions += FactoryGirl.create_list(:condition, 3)
  symptoms = FactoryGirl.create_list(:user_symptom, 2, user: user).map(&:symptom)
  symptoms += FactoryGirl.create_list(:symptom, 5)
  treatments = FactoryGirl.create_list(:user_treatment, 3, user: user).map(&:treatment)
  treatments += FactoryGirl.create_list(:treatment, 6)

  # Setup time frame
  end_at = Time.now
  day = end_at - (DAYS-1).days

  # Start tracking some trackable
  2.times do
    condition = conditions.pop
    Tracking.create!(user: user, trackable: condition, start_at: day)
    puts "Start tracking #{condition.name}"
  end
  3.times do
    symptom = symptoms.pop
    Tracking.create!(user: user, trackable: symptom, start_at: day)
    puts "Start tracking #{symptom.name}"
  end
  4.times do
    treatment = treatments.pop
    Tracking.create!(user: user, trackable: treatment, start_at: day)
    puts "Start tracking #{treatment.name}"
  end

  # Iterate on days
  i = 1
  divisors_range_start = DAYS/4+2
  divisors_range = (divisors_range_start..divisors_range_start+2)
  while day <= end_at
    puts "\n\n=== Day: #{day} ==="

    active_trackings = user.trackings.active_at(day).to_a
    # Stop tracking something at some random iteration
    if i % divisors_range.to_a.sample == 0
      tracking = active_trackings.sample
      tracking.update_attributes!(end_at: day)
      puts "Stop tracking #{tracking.trackable.name}"
    end

    # Start tracking something at some random iteration
    # (either something new, or something tracked earlier)
    if i % divisors_range.to_a.sample == 0
      tracked_earlier = (user.trackings.to_a - active_trackings.to_a).map(&:trackable)
      trackables_matrix = [conditions, treatments, tracked_earlier, symptoms]
      trackables = []
      trackables = trackables_matrix.pop while trackables.empty?
      trackable = trackables.pop
      Tracking.create!(user: user, trackable: trackable, start_at: day)
      puts "Start tracking #{trackable.name}"
    end

    # Checkin
    checkin = FactoryGirl.create(:checkin, user_id: user.id, date: day)
    active_trackings = user.trackings.reload.active_at(day)
    active_trackings.map(&:trackable).each do |trackable|
      if trackable.is_a? Condition
        condition_checkin = FactoryGirl.create(
          :checkin_condition, checkin: checkin, condition_id: trackable.id
        )
        puts "Checked-in #{trackable.name}, value: #{condition_checkin.value}"
      elsif trackable.is_a? Symptom
        symptom_checkin = FactoryGirl.create(
          :checkin_symptom, checkin: checkin, symptom_id: trackable.id
        )
        puts "Checked-in #{trackable.name}, value: #{symptom_checkin.value}"
      elsif trackable.is_a? Treatment
        treatment_checkin = FactoryGirl.create(
          :checkin_treatment, checkin: checkin, treatment_id: trackable.id
        )
        puts "Checked-in #{trackable.name}, dose: #{treatment_checkin.dose}"
      end
    end

    day += 1.day
    i += 1
  end
end
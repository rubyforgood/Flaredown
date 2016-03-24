namespace :import do

  task from_json: :environment do
    Export.delete_all
    system('mongoimport -d flaredown_development -c exports --file exports.json --jsonArray')
  end

  task users_and_checkins: :environment do
    delete_users_and_checkins
    Export.all.each do |export|
      user = import_user(export.user)
      puts " === #{user.email} ==="
      import_profile(user, export.profile)
      export.checkins.each { |checkin| import_checkin(user, checkin) }
      set_trackings(user)
    end
  end

  def delete_users_and_checkins
    print 'Deleting users and checkins... '
    Checkin::Condition.delete_all
    Checkin::Symptom.delete_all
    Checkin::Treatment.delete_all
    Checkin.delete_all
    User.destroy_all
    puts 'Done'
  end

  def import_user(source)
    print  "\nImporting user... "
    user = User.new(source)
    saved = user.save(validate: false)
    fail ActiveRecord::RecordInvalid.new(user.errors.full_messages.join(',')) if not saved
    puts 'Done'
    user.reload
  end

  def import_profile(user, source)
    print  ' > Importing profile... '
    user.profile.update_attributes!(
      sex_id: import_sex(source[:sex]),
      birth_date: import_birth_date(source[:dobYear], source[:dobMonth], source[:dobDay]),
      country_id: import_country(source[:location]),
      onboarding_step_id: import_onboarding_step(source[:onboarded]),
      day_habit_id: import_day_habit(source[:occupation]),
      ethnicity_ids: to_ethnicity_ids(source[:ethnicOrigin]),
      education_level_id: import_education_level(source[:highestEducation]),
      day_walking_hours: source[:activityLevel].to_i
    )
    puts 'Done'
  end

  def import_sex(source_sex)
    return nil if source_sex.blank?
    Sex.all.find { |s| s.name.upcase == source_sex.upcase }.id
  end

  def import_birth_date(dob_year, dob_month, dob_day)
    return nil if dob_year.blank? || dob_month.blank? || dob_day.blank?
    Date.new(dob_year.to_i, dob_month.to_i, dob_day.to_i)
  end

  def import_country(source_country)
    return nil if source_country.blank?
    wrong_countries_map = {
      'Macau SAR China' => 'Macao',
      'Hong Kong SAR China' => 'Hong Kong',
      'East Germany' => 'Germany'
    }
    source_country = wrong_countries_map[source_country] if wrong_countries_map.keys.include?(source_country)
    country = Country.find_country_by_name(source_country)
    if country.present?
      country.alpha2
    else
      print " FAILED: Country '#{source_country}' not found ... "
    end
  end

  def import_onboarding_step(onboarded)
    (onboarded == 'true') ? 'onboarding-completed' : 'onboarding-personal'
  end

  def import_day_habit(source_day_habit)
    return nil if source_day_habit.blank?
    DayHabit.all.find { |d| d.name.upcase == source_day_habit.upcase }.id
  end

  def import_education_level(source_education_level)
    return nil if source_education_level.blank?
    EducationLevel.all.find { |e| e.name.upcase == source_education_level.upcase }.id
  end

  def to_ethnicity_ids(ethnic_origins)
    return [] if ethnic_origins.nil? || ethnic_origins == '[]'
    YAML::load(ethnic_origins).map do |ethnic_origin|
      Ethnicity.all.find { |e| e.name.upcase == ethnic_origin.upcase }.id
    end
  end

  def import_checkin(user, source)
    date = source[:date]
    pretty_date = date.strftime('%Y-%m-%d')
    print " > Checkin: #{pretty_date}... "
    begin
      Checkin.create!(
        user_id: user.id,
        date: date,
        note: source[:notes],
        tag_ids: source[:tags].map { |name| Tag.find_or_create_by(name: name).id },
        conditions_attributes: import_conditions(user, source[:conditions]),
        symptoms_attributes: import_symptoms(user, source[:symptoms]),
        treatments_attributes: import_treatments(user, source[:treatments])
      )
      puts 'Done'
    rescue Mongoid::Errors::Validations => e
      puts "\n     FAILED: #{e.summary} | Checkin: #{pretty_date}, User: #{user.email}"
    end
  end

  def import_conditions(user, sources)
    sources.map do |source|
      condition = Condition.new(name: source[:name], global: false)
      condition = TrackableCreator.new(condition, user).create!
      {
        condition_id: condition.id,
        value: source[:value]
      }
    end
  end

  def import_symptoms(user, sources)
    sources.map do |source|
      symptom = Symptom.new(name: source[:name], global: false)
      symptom = TrackableCreator.new(symptom, user).create!
      {
        symptom_id: symptom.id,
        value: source[:value]
      }
    end
  end

  def import_treatments(user, sources)
    sources.map do |source|
      treatment = Treatment.new(name: source[:name], global: false)
      treatment = TrackableCreator.new(treatment, user).create!
      {
        treatment_id: treatment.id,
        value: source[:value],
        is_taken: source[:is_taken]
      }
    end
  end

  def set_trackings(user)
    first_checkin = user.checkins.sort(date: -1).first
    return if first_checkin.nil?
    start_at = first_checkin.date - 2.days
    # Conditions
    conditions = user.checkins.map(&:conditions).flatten
    condition_ids = conditions.map(&:condition_id).uniq
    condition_ids.each do |condition_id|
      Tracking.create!(
        start_at: start_at,
        user: user,
        trackable_type: 'Condition',
        trackable_id: condition_id
      )
    end
    # Symptoms
    symptoms = user.checkins.map(&:symptoms).flatten
    symptom_ids = symptoms.map(&:symptom_id).uniq
    symptom_ids.each do |symptom_id|
      Tracking.create!(
        start_at: start_at,
        user: user,
        trackable_type: 'Symptom',
        trackable_id: symptom_id
      )
    end
    # Treatments
    treatments = user.checkins.map(&:treatments).flatten
    treatment_ids = treatments.map(&:treatment_id).uniq
    treatment_ids.each do |treatment_id|
      Tracking.create!(
        start_at: start_at,
        user: user,
        trackable_type: 'Treatment',
        trackable_id: treatment_id
      )
    end
  end

end

class DataExportJob < ActiveJob::Base
  SUBFIELD_SEPARATOR = "; ".freeze

  queue_as :default

  attr_accessor :user_locale, :symptom_ids, :condition_ids, :treatment_ids, :tag_ids, :food_ids

  def perform(user_id)
    user = User.find(user_id)

    data = csv_data(user)

    UserDataMailer.trackings_csv(user.email, data).deliver_later
  end

  def csv_data(user)
    checkins = user.checkins.includes(:conditions, :symptoms, :treatments).order_by(date: :asc)

    set_attributes(user.locale, checkins)

    CSV.generate do |csv|
      csv << headers

      checkins.each { |checkin| csv << checkin_row(checkin) }
    end
  end

  private

  def checkin_row(checkin)
    row = [checkin.date]

    symptoms_map = trackables_map(checkin.symptoms, "symptom")
    conditions_map = trackables_map(checkin.conditions, "condition")
    treatments_map = treatments_map(checkin.treatments)

    condition_names.keys.each { |id| row << conditions_map[id] }
    symptom_names.keys.each { |id| row << symptoms_map[id] }
    treatment_names.keys.each { |id| row << treatments_map[id] }

    row << tag_names.slice(*checkin.tag_ids).values.join(SUBFIELD_SEPARATOR)
    row << food_names.slice(*checkin.food_ids).values.join(SUBFIELD_SEPARATOR)
  end

  def set_attributes(locale, checkins)
    checkin_ids = checkins.pluck(:id)

    self.user_locale = I18n.locale_available?(locale) ? locale : I18n.default_locale

    self.symptom_ids = Checkin::Symptom.in(checkin_id: checkin_ids).distinct(:symptom_id)
    self.condition_ids = Checkin::Condition.in(checkin_id: checkin_ids).distinct(:condition_id)
    self.treatment_ids = Checkin::Treatment.in(checkin_id: checkin_ids).distinct(:treatment_id)

    self.tag_ids = checkins.distinct(:tag_ids)
    self.food_ids = checkins.distinct(:food_ids)
  end

  def symptom_names
    @symptom_names ||= object_names(Symptom, :name, symptom_ids)
  end

  def condition_names
    @condition_names ||= object_names(Condition, :name, condition_ids)
  end

  def treatment_names
    @treatment_names ||= object_names(Treatment, :name, treatment_ids)
  end

  def tag_names
    @tag_names ||= object_names(Tag, :name, tag_ids)
  end

  def food_names
    @food_names ||= object_names(Food, :long_desc, food_ids)
  end

  def object_names(klass, field, ids)
    name_slug = klass.name.underscore
    relation = :"#{name_slug}_translations"

    # .pluck(:"#{name_slug}_id", field)
    klass
      .joins(relation)
      .where(:id => ids, relation => {locale: user_locale})
      .pluck(:id, field)
      .to_h
  end

  def headers
    ["Date"]
      .concat(condition_names.values)
      .concat(symptom_names.values)
      .concat(treatment_names.values)
      .concat(%w[Tags Foods])
  end

  def trackables_map(trackables, type)
    id_field = "#{type}_id"

    trackables.map { |c| [c[id_field], c.value] }.to_h
  end

  # special handling to allow distinguishing between treatments with no dosage, and treatments not taken
  def treatments_map(treatments)
    treatments.map do |treatment|
      [
        treatment["treatment_id"],
        treatment_value(treatment.is_taken, treatment.value)
      ]
    end.to_h
  end

  def treatment_value(is_taken, value)
    if is_taken
      value || "Taken"
    else
      "Not Taken"
    end
  end
end

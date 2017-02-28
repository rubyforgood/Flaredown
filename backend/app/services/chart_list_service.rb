class ChartListService
  class << self
    def as_json(current_user:)
      checkin_ids = user_checkin_ids(current_user)

      {
        chart_list: {
          id: 1,
          payload: {
            tags: tags_payload(user_tag_ids(current_user)),
            foods: foods_payload(user_food_ids(current_user)),
            symptoms: symptoms_payload(user_symptom_ids(checkin_ids)),
            conditions: conditions_payload(user_condition_ids(checkin_ids)),
            treatments: treatments_payload(user_treatment_ids(checkin_ids)),
            weathersMeasures: weathers_payload,
            harveyBradshawIndices: hbi_payload
          }
        }
      }
    end

    private

    def user_tag_ids(user)
      user.checkins.distinct(:tag_ids)
    end

    def user_food_ids(user)
      user.checkins.distinct(:food_ids)
    end

    def user_checkin_ids(user)
      user.checkins.distinct(:id)
    end

    def user_symptom_ids(checkin_ids)
      Checkin::Symptom.where(:checkin_id.in => checkin_ids).distinct(:symptom_id)
    end

    def user_treatment_ids(checkin_ids)
      Checkin::Treatment.where(:checkin_id.in => checkin_ids).distinct(:treatment_id)
    end

    def user_condition_ids(checkin_ids)
      Checkin::Condition.where(:checkin_id.in => checkin_ids).distinct(:condition_id)
    end

    def tags_payload(tag_ids)
      Tag::Translation.where(tag_id: tag_ids, locale: I18n.locale).pluck(:tag_id, :name)
    end

    def foods_payload(food_ids)
      Food::Translation.where(food_id: food_ids, locale: I18n.locale).pluck(:food_id, :long_desc)
    end

    def symptoms_payload(symptom_ids)
      Symptom::Translation.where(symptom_id: symptom_ids, locale: I18n.locale).pluck(:symptom_id, :name)
    end

    def conditions_payload(condition_ids)
      Condition::Translation.where(condition_id: condition_ids, locale: I18n.locale).pluck(:condition_id, :name)
    end

    def treatments_payload(treatment_ids)
      Treatment::Translation.where(treatment_id: treatment_ids, locale: I18n.locale).pluck(:treatment_id, :name)
    end

    def weathers_payload
      [[1, 'Avg daily humidity'], [2, 'Avg daily atmospheric pressure']]
    end

    def hbi_payload
      [[1, 'Harvey Bradshaw Index']]
    end
  end
end

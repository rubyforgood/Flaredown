class Api::V1::ChartListsController < ApplicationController
  def show
    tag_ids = current_user.checkins.distinct(:tag_ids)
    checkin_ids = current_user.checkins.distinct(:id)
    symptom_ids = Checkin::Symptom.where(:checkin_id.in => checkin_ids).distinct(:symptom_id)
    treatment_ids = Checkin::Treatment.where(:checkin_id.in => checkin_ids).distinct(:treatment_id)
    condition_ids = Checkin::Condition.where(:checkin_id.in => checkin_ids).distinct(:condition_id)

    render json: {
      chart_list: {
        id: 1,
        payload: {
          conditions: Condition::Translation.where(condition_id: condition_ids, locale: I18n.locale).pluck(:name),
          symptoms: Symptom::Translation.where(symptom_id: symptom_ids, locale: I18n.locale).pluck(:name),
          treatments: Treatment::Translation.where(treatment_id: treatment_ids, locale: I18n.locale).pluck(:name),
          tags: Tag::Translation.where(tag_id: tag_ids).pluck(:name)
        }
      }
    }
  end
end

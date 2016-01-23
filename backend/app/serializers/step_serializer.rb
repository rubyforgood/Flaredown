class StepSerializer < ApplicationSerializer
  attributes :id, :group, :key, :title, :hint, :prev_id, :next_id

  def title
    I18n.t "step.#{object.group}.#{object.key}.title"
  end

  def hint
    I18n.t "step.#{object.group}.#{object.key}.hint", raise: true
  rescue I18n::MissingTranslationData
    nil
  end

end

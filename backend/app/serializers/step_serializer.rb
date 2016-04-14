class StepSerializer < ApplicationSerializer
  attributes :id, :group, :key, :title, :short_title, :hint, :priority, :prev_id, :next_id

  def title
    I18n.t "step.#{object.group}.#{object.key}.title"
  end

  def short_title
    optional_translation "short_title"
  end

  def hint
    optional_translation "hint"
  end

  private

  def optional_translation(key)
    I18n.t "step.#{object.group}.#{object.key}.#{key}", raise: true
  rescue I18n::MissingTranslationData
    nil
  end

end

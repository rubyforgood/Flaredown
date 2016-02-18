module SearchableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :type
  end

  def type
    object.class.name.downcase.dasherize
  end
end

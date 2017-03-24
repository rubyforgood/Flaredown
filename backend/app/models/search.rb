class Search
  include ActiveModel::Model,
          ActiveModel::Serialization,
          ActiveRecord::Sanitization::ClassMethods

  attr_accessor :resource, :scope, :user, :query

  #
  # Validations
  #
  validates :resource, presence: true, inclusion: { in: %w(treatment symptom condition tag dose food topic) }

  def id
    Digest::SHA256.base64digest(resource)
  end

  def searchables
    # FIXME
    # rubocop:disable Rails/DynamicFindBy
    @searchables ||= find_by_query
    # rubocop:enable Rails/DynamicFindBy
  end

  MAX_ROWS = 10

  protected

  def query_hash
    @query_hash ||= Hash(query)
  end

  def find_by_query
    if query_hash.present?
      resources.where(*where_conditions).limit(MAX_ROWS)
    elsif scope.present?
      case scope
      when 'random'
        resources.limit(MAX_ROWS).order('RANDOM()')
      end
    else
      resources.limit(MAX_ROWS)
    end
  end

  private

  def where_conditions
    @where_conditions ||=
      [].tap do |conditions|
        query_hash.each do |key, value|
          sanitized_value = sanitize_sql_like(value.downcase)
          pattern =
            if sanitized_value.length < 3
              "#{sanitized_value}%"
            else
              "%#{sanitized_value}%"
            end
          conditions << ["lower(#{key}) LIKE ?", pattern]
        end
        conditions
      end
  end

  def resources
    resource.classify.constantize.accessible_by(current_ability).with_translations(I18n.locale)
  end

  def current_ability
    @current_ability ||= Ability.new(user)
  end

end

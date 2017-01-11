class Search::ForDose < ::Search

  validates :query, presence: true

  validate :query_must_include_treatment_id
  def query_must_include_treatment_id
    return if query[:treatment_id]

    errors.add(:query, "must include treatment_id")
  end

  protected

  def find_by_query
    q = name.present? ? treatments.where(value: /#{name}/i) : treatments
    q = q.order_by('checkin.date' => 'desc').distinct(:value)
    q.slice(0..10).map { |value| ::Dose.new(name: value) }
  end

  private

  def treatments
    Checkin::Treatment.where(
      :value.ne => nil, is_taken: true, treatment_id: treatment_id
    )
  end

  def treatment_id
    query[:treatment_id].to_i
  end

  def name
    text = query[:name]
    Regexp.escape(text) if text
  end

end

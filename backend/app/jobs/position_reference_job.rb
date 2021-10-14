class PositionReferenceJob
  include Sidekiq::Worker

  def perform(object_class, objec_id, postal_code)
    object = object_class.constantize.find_by(id: objec_id)
    position = Position.find_or_create_by(postal_code: postal_code)

    object.update(position_id: position.id) if position.persisted?
  end
end

class Api::V1::ReactionsController < ApplicationController
  def create
    react(__method__)
  end

  def update
    react(__method__)
  end

  def destroy
    reaction = Reaction.where(reaction_params).first

    authorize! :destroy, reaction

    if reaction.destroy
      head :no_content
    else
      render json: { errors: reaction.errors }, status: :unprocessable_entity
    end
  end

  private

  def react(method_name)
    reaction = Reaction.find_or_initialize_by(reaction_params)

    authorize! method_name, reaction

    if reaction.save
      unless reaction.encrypted_user_id == reaction.reactable.encrypted_user_id
        Notification.create(
          kind: :reaction,
          notificateable: reaction.reactable,
          encrypted_user_id: reaction.encrypted_user_id,
          encrypted_notify_user_id: reaction.reactable.encrypted_user_id
        )
      end

      reaction.id = params[:id] if params[:id].present?

      render json: serialized_reaction(reaction), status: :created
    else
      render json: { errors: reaction.errors }, status: :unprocessable_entity
    end
  end

  def reaction_params
    reaction = params.require(:reaction)

    {
      value: reaction[:value],
      reactable_id: reaction[:reactable_id],
      reactable_type: reaction[:reactable_type].titleize,
      encrypted_user_id: current_user.encrypted_id
    }
  end

  def serialized_reaction(reaction)
    ReactionSerializer
      .new(
        Reaction.similar_to(reaction).values_count_with_participated(current_user.encrypted_id),
        reaction.reactable_id.to_s,
        reaction.reactable_type
      )
      .serialize_one
  end
end

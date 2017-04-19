class Api::V1::ReactionsController < ApplicationController
  def create
    reaction = Reaction.find_or_initialize_by(create_params)

    authorize! :create, reaction

    if reaction.save
      render(
        json: ReactionSerializer.new(
          Reaction.similar_to(reaction).values_count_with_participated(current_user.encrypted_id),
          reaction.reactable_id.to_s,
          reaction.reactable_type
        ).serialize_one,
        status: :created
      )
    else
      render json: { errors: reaction.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    reaction_params = params.require(:reaction)

    {
      value: reaction_params[:id],
      reactable_id: reaction_params[:reactable_id],
      reactable_type: reaction_params[:reactable_type].titleize,
      encrypted_user_id: current_user.encrypted_id
    }
  end
end

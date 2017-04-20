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
      render json: serialized_reaction(reaction), status: :created
    else
      render json: { errors: reaction.errors }, status: :unprocessable_entity
    end
  end

  def reaction_params
    reaction_params = params.require(:reaction)

    {
      value: reaction_params[:id] || params[:id],
      reactable_id: reaction_params[:reactable_id],
      reactable_type: reaction_params[:reactable_type].titleize,
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

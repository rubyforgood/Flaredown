module Api
  module V1
    class PatternsController < ApplicationController
      load_and_authorize_resource
      skip_before_action :authenticate_user!, only: [:index]

      def index
        page = params[:page] || 1
        pattern_ids = params[:pattern_ids]

        @patterns =
          if pattern_ids.present?
            Pattern.where(id: {"$in" => pattern_ids})
          else
            Pattern.accessible_by(current_ability).where(encrypted_user_id: encrypted_user_id)
          end

        render json: @patterns.page(page).per(10)
      end

      def show
        pattern = Pattern.find_by(id: pattern_params[:id])

        render json: pattern
      end

      def create
        @pattern = PatternCreator.new(pattern_params.to_h).create

        render json: @pattern
      end

      def update
        @pattern.update(pattern_params)

        render json: @pattern
      end

      def destroy
        pattern = Pattern.find_by(id: params[:id])

        authorize! :destroy, pattern

        if pattern.destroy
          head :no_content
        else
          render json: {errors: pattern.errors}, status: :unprocessable_entity
        end
      end

      private

      def pattern_params
        params.require(:pattern)
          .permit(:name, :start_at, :end_at, includes: [:id, :category, :label])
          .merge(user_id: current_user.id)
      end

      def current_ability
        @current_ability ||= Ability.new(current_user)
      end

      def encrypted_user_id
        @encrypted_user_id ||= SymmetricEncryption.encrypt(current_user.id)
      end
    end
  end
end

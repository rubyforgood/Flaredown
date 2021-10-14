module Api
  module V1
    class HarveyBradshawIndicesController < ApplicationController
      load_and_authorize_resource

      def show
        render json: @harvey_bradshaw_index
      end

      def create
        @harvey_bradshaw_index.save

        render json: @harvey_bradshaw_index
      end

      private

      def create_params
        params.require(:harvey_bradshaw_index).permit(
          :abdominal_mass, :abdominal_pain, :abscess,
          :anal_fissure, :aphthous_ulcers, :arthralgia,
          :checkin_id, :erythema_nodosum, :new_fistula,
          :pyoderma_gangrenosum, :stools, :uveitis, :well_being
        )
      end
    end
  end
end

module Api
  module V1
    class DataExportSchedulesController < ApplicationController
      def create
        DataExportJob.perform_later(current_user.id)

        head :created
      end
    end
  end
end

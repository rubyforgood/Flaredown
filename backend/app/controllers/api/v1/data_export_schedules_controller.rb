class Api::V1::DataExportSchedulesController < ApplicationController
  def create
    DataExportJob.perform_later(current_user.id)

    head :created
  end
end

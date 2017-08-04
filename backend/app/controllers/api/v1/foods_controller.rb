class Api::V1::FoodsController < ApplicationController
  load_and_authorize_resource

  def index
    @foods = @foods.includes(:translations)

    foods =
      if ids.present?
        @foods.where(id: ids)
      elsif scope.present?
        CollectionRetriever.new(Food, scope, current_user).retrieve
      end

    render json: foods
  end

  def show
    render json: @food
  end

  def create
    render json: TrackableCreator.new(@food, current_user).create!
  end

  private

  def create_params
    { long_desc: params.require(:food).require(:name) }
  end

  def ids
    @ids ||= params[:ids]
  end

  def scope
    @scope ||= params[:scope]&.to_sym
  end
end

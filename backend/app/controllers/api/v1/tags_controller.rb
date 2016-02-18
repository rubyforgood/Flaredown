class Api::V1::TagsController < Api::BaseController
  load_and_authorize_resource

  def index
    @tags = @tags.where(id: ids) if ids.present?
    render json: @tags
  end

  def show
    render json: @tag
  end

  def create
    @tag = Tag.create!(create_params)
    render json: @tag
  end

  private

  def create_params
    params.require(:tag).permit(:name)
  end

  def ids
    @ids ||= params[:ids]
  end
end

class V1::ImagesController < ApplicationController
  before_action :check_user

  def index
    @images = Image.user_images_json(current_user.id)
    render json: @images
  end

  def create
    @image = current_user.make_associated_image(create_image_params[:file])
    if @image.errors.present?
      render json: @image.errors.first, status: :unprocessable_entity
    else
      render json: @image.render_json, status: :created
    end
  end

  private

  def check_user
    return head(:unauthorized) unless current_user.present?
  end

  def create_image_params
    params.permit(:file)
  end
end

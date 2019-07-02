class V1::ImagesController < ApplicationController
  def index
    @images = Image.user_images_json(current_user.id)
    render json: @images
  end

  def create
    @image = Image.create_image(current_user.id, create_image_params[:file])
    if @image.errors.present?
      render json: @image.errors.first, status: :unprocessable_entity
    else
      render json: @image.render_json, status: :created
    end
  end

  private

  def create_image_params
    params.permit(:file)
  end
end

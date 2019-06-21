class V1::ImagesController < ApplicationController
  def show
    @image = Image.find(show_image_params[:id])
  end

  def create
    return unless current_user.present?
    @image = current_user.images.create(image: create_image_params[:file])

    render json: @image.render_json, status: :created
  end

  def change_mime_type

  end

  private

  def show_image_params
    params.permit(:id)
  end

  def create_image_params
    params.permit(:file)
  end
end

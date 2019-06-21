class V1::ImagesController < ApplicationController
  def show
    @image = Image.find(show_image_params[:id])
  end

  def create
    @image = Image.create(image: create_image_params[:file])

    render json: @image.image, status: :created
  end

  private

  def show_image_params
    params.permit(:id)
  end

  def create_image_params
    params.permit(:file)
  end
end

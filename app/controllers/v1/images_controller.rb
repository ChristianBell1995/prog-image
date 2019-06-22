class V1::ImagesController < ApplicationController
  def create
    return unless current_user.present?
    @image = current_user.make_associated_image(create_image_params[:file])
    render json: @image.render_json, status: :created
  end

  private

  def create_image_params
    params.permit(:file)
  end
end

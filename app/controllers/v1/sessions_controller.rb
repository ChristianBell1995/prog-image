class V1::SessionsController < ApplicationController
  def create
    user = User.find_by_email(user_params[:email])

    if user&.valid_password?(user_params[:password])
      render json: user.as_json(only: [:email, :authentication_token]), status: :created
    else
      head :unauthorized
    end
  end

  def destroy
    current_user&.authentication_token = nil
    if current_user.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end

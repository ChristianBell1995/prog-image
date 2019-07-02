class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none
  before_action :authenticate_user

  def authenticate_user
    return head(:unauthorized) unless current_user.present?
  end
end

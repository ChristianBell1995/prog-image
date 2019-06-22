require 'test_helper'

class V1::ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
  end

  test 'sign\'s in user and returns the token and email' do
    session_params = { email: user.email, password: user.password }
    post(v1_sessions_path, params: { session_params })

    response = JSON.parse(@response.body)

    assert response['email'] == user.email
    assert response['authentication_token'] == user.authentication_token
  end
end

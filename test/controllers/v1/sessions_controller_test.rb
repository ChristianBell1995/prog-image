require 'test_helper'

class V1::ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'create\'s user session and returns the token and email' do
    user = users(:one)
    session_params = { email: user.email, password: 'testing123' }
    post(v1_sessions_path, params: session_params)

    response = JSON.parse(@response.body)

    assert response['email'] == user.email
    assert response['authentication_token'] == user.authentication_token
  end

  test 'destroy\'s user session and resets the token' do
    delete v1_sessions_path, headers: @header
    assert_response :success
  end
end

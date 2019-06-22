require 'test_helper'

class V1::ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)

    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }

    test 'sign\'s in user and returns the token and email'
  end
end

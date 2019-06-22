require 'test_helper'

class V1::ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'create\'s image record and uploads variety of files' do
    file = fixture_file_upload('files/grand_budapest_hotel', 'image/jpg')

    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end
end

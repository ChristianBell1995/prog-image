require 'test_helper'

class V1::ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:one)
    @header = {
      'X-User-Email': user.email,
      'X-User-Token': user.authentication_token
    }
  end

  test 'create\'s image (JPG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.jpg', 'image/jpg')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'create\'s image (JPEG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.jpeg', 'image/jpeg')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'create\'s image (PNG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'create\'s image (TIFF)' do
    file = fixture_file_upload('files/grand_budapest_hotel.tiff', 'image/tiff')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'create\'s image (GIF)' do
    file = fixture_file_upload('files/grand_budapest_hotel.gif', 'image/gif')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'create\'s image (ICO)' do
    file = fixture_file_upload('files/grand_budapest_hotel.ico', 'image/ico')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end
end

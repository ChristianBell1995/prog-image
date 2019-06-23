require 'test_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

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

  test 'create\'s image associated with the user' do
    user = users(:one)
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }

    response = JSON.parse(@response.body)

    assert response['user_id'] == user.id
    assert response['id'] == user.images.last.id
  end

  test 'newly created image has correct ext names in image_data JSON' do
    user = users(:one)
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }

    image_data = JSON.parse(user.images.last.image_data)
    image_ext = image_data.map(&:first)[1..-1]

    assert image_ext == Image::IMAGE_EXTENSIONS
  end
end

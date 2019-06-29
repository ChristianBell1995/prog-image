require 'test_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

class V1::CreateTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @header = {
      'X-User-Email': @user.email,
      'X-User-Token': @user.authentication_token
    }
  end

  test 'POST v1/images, create\'s image (JPG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.jpg', 'image/jpg')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'POST v1/images, create\'s image (JPEG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.jpeg', 'image/jpeg')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'POST v1/images, create\'s image (PNG)' do
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'POST v1/images, create\'s image (TIFF)' do
    file = fixture_file_upload('files/grand_budapest_hotel.tiff', 'image/tiff')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'POST v1/images, create\'s image (GIF)' do
    file = fixture_file_upload('files/grand_budapest_hotel.gif', 'image/gif')
    post v1_images_path, headers: @header, params: { file: file }
    assert_response :success
  end

  test 'POST v1/images, create\'s image associated with the user' do
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }

    response = JSON.parse(@response.body)

    assert response['user_id'] == @user.id
    assert response['tracking_id'] == @user.images.last.id
  end

  test 'POST v1/images, newly created image has correct ext names in image_data JSON' do
    file = fixture_file_upload('files/grand_budapest_hotel.png', 'image/png')
    post v1_images_path, headers: @header, params: { file: file }

    image_exts = @user.images.last.image.keys[1..-1]

    assert image_exts == Image::IMAGE_EXTENSIONS
  end

  test 'GET v1/images, displays image records with status of uploaded, if uploaded' do
    image = images(:uploaded)
    get v1_images_path, headers: @header

    first_image = JSON.parse(@response.body).first

    assert first_image['status'] == 'Uploaded!'
    assert first_image['file_url'].start_with? ApplicationRecord::S3_PATH
  end

  test 'GET v1/images, updates image records to status of uploaded, if worker is finished' do
    image = images(:still_processing)
    get v1_images_path, headers: @header

    first_image = JSON.parse(@response.body).first

    assert first_image['status'] == 'Uploaded!'
    assert first_image['file_url'].start_with? ApplicationRecord::S3_PATH
  end
end

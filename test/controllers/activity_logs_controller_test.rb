require 'test_helper'

class ActivityLogsControllerTest < ActionDispatch::IntegrationTest
  test 'GET :index' do
    get activity_logs_url
    assert_response :success
  end

  test 'POST :upload with valid file' do
    post upload_activity_logs_url, params: { csv_file: fixture_file_upload('files/seed_data.csv', 'text/csv') }
    assert_response :success
  end

  test 'POST :upload with invalid mime type' do
    post upload_activity_logs_url, params: { csv_file: fixture_file_upload('files/seed_data.csv', 'application/csv') }
    assert_response :bad_request
    assert_equal '{"error":"Accepts only file with content type - text/csv"}', response.body
  end
end

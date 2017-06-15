require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get "/auth/google_oauth2"
    assert_response :success
  end
end
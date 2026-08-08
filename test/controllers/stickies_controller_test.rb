require "test_helper"

class StickiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get stickies_new_url
    assert_response :success
  end

  test "should get create" do
    get stickies_create_url
    assert_response :success
  end
end

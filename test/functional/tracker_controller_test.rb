require 'test_helper'

class TrackerControllerTest < ActionController::TestCase
  test "should get restart" do
    get :restart
    assert_response :success
  end

end

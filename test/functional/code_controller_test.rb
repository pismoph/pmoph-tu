require 'test_helper'

class CodeControllerTest < ActionController::TestCase
  test "should get cprovince" do
    get :cprovince
    assert_response :success
  end

end

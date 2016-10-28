require 'test_helper'

class RestsControllerTest < ActionController::TestCase
  test "should get index" do    
    rst = RestClient.get('http://localhost:3000/rests', {})
    if [301, 302, 307].include?(rst.code)
      rst.follow_redirection
    end
    binding.pry

    assert_response :success
  end

end

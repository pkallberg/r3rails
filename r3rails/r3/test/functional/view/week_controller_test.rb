require File.dirname(__FILE__) + '/../../test_helper'
require 'view/week_controller'

# Re-raise errors caught by the controller.
class View::WeekController; def rescue_action(e) raise e end; end

class View::WeekControllerTest < Test::Unit::TestCase
  def setup
    @controller = View::WeekController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

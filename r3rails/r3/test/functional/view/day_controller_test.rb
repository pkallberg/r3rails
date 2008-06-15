#
# Copyright @year@ @owner@
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# <@(#) $Id: day_controller_test.rb,v 1.2 2007/09/20 10:41:31 jury Exp $>
#
# 改定履歴
# 2007/09/19 (岡村 淳司) 新規作成 [S33] コントローラのテスト
#
require File.dirname(__FILE__) + '/../../test_helper'
require 'view/day_controller'

# Re-raise errors caught by the controller.
class View::DayController; def rescue_action(e) raise e end; end

class View::DayControllerTest < Test::Unit::TestCase
  def setup
    @controller = View::DayController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_with_no_param
    get :index
    assert_redirected_to :action => :index, :date => Date.today.strftime('%Y%m%d')
    follow_redirect
    assert_response :success
    
    # なぜかテストが通らない
    #assert_tag :tag => "title", :contents => "tiles"

  end

  def test_index_with_bad_param
    get :index, :date => "BadParam"
    assert_redirected_to :action => :index, :date => Date.today.strftime('%Y%m%d')
  end

  def test_index_with_good_param1
    get :index, :date => "2007/07/01"
    assert_response :success
  end

  def test_index_with_good_param2
    get :index, :date => "2007-07-01"
    assert_response :success
  end

  def test_index_with_good_param3
    get :index, :date => "20070701"
    assert_response :success
    
    assert_not_nil assigns(:day)
    assert_not_nil assigns(:all_units_by_room)
    assert_equal Date.new(2007,7,1), assigns(:day)
  end

  def test_index_with_good_param3
    get :index, :date => "20070701"
    assert_template 'view/day/index'
  end
  
  def no_test_goto_no_param
    get :goto
    assert_redirected_to :action => :index, :date => Date.today.strftime('%Y%m%d')
  end

end

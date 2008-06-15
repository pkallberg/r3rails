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
# <@(#) $Id: calendar_controller_test.rb,v 1.1 2007/09/13 15:25:40 jury Exp $>
#
# 改定履歴
# 2007/09/09 (岡村 淳司) 新規作成 [S18] 予約の開放 
#
require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/calendar_controller'

# Re-raise errors caught by the controller.
class Admin::CalendarController; def rescue_action(e) raise e end; end

class Admin::CalendarControllerTest < Test::Unit::TestCase
  fixtures :calendars

  def setup
    @controller = Admin::CalendarController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = calendars(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:calendars)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:calendar)
    assert assigns(:calendar).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:calendar)
  end

  def test_create
    num_calendars = Calendar.count

    post :create, :calendar => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_calendars + 1, Calendar.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:calendar)
    assert assigns(:calendar).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Calendar.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Calendar.find(@first_id)
    }
  end
end

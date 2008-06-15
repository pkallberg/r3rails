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
# <@(#) $Id: user_controller_test.rb,v 1.1 2007/09/04 12:16:26 jury Exp $>
#
# 改定履歴
# 2007/09/04 (岡村 淳司) 新規作成 [S12] 管理機能 User
#
require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/user_controller'

# Re-raise errors caught by the controller.
class Admin::UserController; def rescue_action(e) raise e end; end

class Admin::UserControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = Admin::UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = users(:first).id
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

    assert_not_nil assigns(:users)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:user)
  end

  def test_create
    num_users = User.count

    post :create, :user => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_users + 1, User.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      User.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      User.find(@first_id)
    }
  end
end

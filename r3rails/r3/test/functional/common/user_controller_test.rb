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
# <@(#) $Id: user_controller_test.rb,v 1.3 2007/10/16 13:40:01 jury Exp $>
#
# 改定履歴
# 2007/09/03 (岡村 淳司) 新規作成 [S8] ユーザ登録
#
require File.dirname(__FILE__) + '/../../test_helper'
require 'common/user_controller'

# Re-raise errors caught by the controller.
class Common::UserController; def rescue_action(e) raise e end; end

class Common::UserControllerTest < Test::Unit::TestCase
  def setup
    @controller = Common::UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_before_login
    get :day
    
    assert_response :redirect
    assert_redirected_to :controller=>"common/login", :action => 'index'

  end
end

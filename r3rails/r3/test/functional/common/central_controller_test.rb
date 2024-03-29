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
# <@(#) $Id: central_controller_test.rb,v 1.1 2007/09/08 11:47:11 jury Exp $>
#
# 改定履歴
# 2007/09/08 (岡村 淳司) 新規作成 [S22] 戻るボタン
#
require File.dirname(__FILE__) + '/../../test_helper'
require 'common/central_controller'

# Re-raise errors caught by the controller.
class Common::CentralController; def rescue_action(e) raise e end; end

class Common::CentralControllerTest < Test::Unit::TestCase
  def setup
    @controller = Common::CentralController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

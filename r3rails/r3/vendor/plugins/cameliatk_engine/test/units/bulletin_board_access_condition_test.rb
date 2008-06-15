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
# <@(#) $Id: bulletin_board_access_condition_test.rb,v 1.1 2007/10/12 12:43:24 jury Exp $>
#
# 改定履歴
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class BulletinBoardTest < Test::Unit::TestCase
  fixtures :users, :bulletin_boards, :bulletin_board_access_conditions
  
  def test_eval_condition
    bac = bulletin_board_access_conditions(:bbac_00001)
    assert !bac.eval_access_conditions( :user => nil )
    assert !bac.eval_access_conditions( :user => users(:newpass) )
    assert bac.eval_access_conditions( :user => users(:admin) )
  end
  
end

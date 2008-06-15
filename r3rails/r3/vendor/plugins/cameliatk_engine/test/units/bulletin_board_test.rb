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
# <@(#) $Id: bulletin_board_test.rb,v 1.1 2007/10/12 12:43:24 jury Exp $>
#
# 改定履歴
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class BulletinBoardTest < Test::Unit::TestCase
  fixtures :users, :bulletin_boards, :bulletin_board_access_conditions
  
  def test_new_and_add_clear
    bb = BulletinBoard.new(:title => "title")
    assert bb.save
    assert_equal 0, bb.access_conditions.size

    bac = BulletinBoardAccessCondition.new(:conditions => "sample")
    bb.access_conditions << bac
    a_id = bac.id
    
    assert bb.save
    assert_equal 1, bb.access_conditions.size

    bb.access_conditions.clear
    assert_raise(ActiveRecord::RecordNotFound){ BulletinBoardAccessCondition.find(a_id) }
  end

  def test_eval
    bb = bulletin_boards(:bulletin_board_00001)
    assert !bb.can_read?( :user => nil )
    assert !bb.can_read?( :user => users(:newpass) )
    assert bb.can_read?( :user => users(:admin), :login_id => "admin" )
  end
  
  def test_browse_for_condition
    bb_list = BulletinBoard.today()
    assert_equal 2, bb_list.size
    assert_equal 6, bb_list[0].id
    assert_equal 3, bb_list[1].id
    
    bb_list = BulletinBoard.today(:user => users(:user_1))
    assert_equal 2, bb_list.size
    assert_equal 6, bb_list[0].id
    assert_equal 3, bb_list[1].id
    
    assert users(:admin).is_admin?
    
    bb_list = BulletinBoard.today(:user => users(:admin))
    assert_equal 3, bb_list.size
    assert_equal 6, bb_list[0].id
    assert_equal 3, bb_list[1].id
    assert_equal 4, bb_list[2].id
  end
  
end

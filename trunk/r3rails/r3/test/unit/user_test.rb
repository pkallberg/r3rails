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
# <@(#) $Id: user_test.rb,v 1.7 2007/09/27 12:30:59 jury Exp $>
#
# 改定履歴
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/04 (岡村 淳司) [S12] 管理機能 User
# 2007/08/22 (岡村 淳司) [S5] ユーザの予約登録機能
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :reservations, :calendars

  def test_destroy_and_cancel_reservations
    units = Calendar.find(:all)
    assert_equal 60, units.size
    reservations = Reservation.find(:all, :conditions => ["user_id = ?",2])
    assert_equal 3, reservations.size

    user = User.find(2);
    assert_nothing_raised {
      user.destroy_and_cancel_reservations
    }
    reservations = Reservation.find(:all, :conditions => ["user_id = ?",2])
    assert_equal 0, reservations.size
    units = Calendar.find(:all)
    assert_equal 60, units.size
  end
  
end

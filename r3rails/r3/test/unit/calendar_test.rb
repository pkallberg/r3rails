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
# <@(#) $Id: calendar_test.rb,v 1.6 2007/09/16 04:43:44 jury Exp $>
#
# 改定履歴
# 2007/09/15 (岡村 淳司) [S25] カレンダのクローズ
# 2007/09/12 (岡村 淳司) [S18] カレンダの解放
# 2007/09/02 (岡村 淳司) [S6] 排他制御
# 2007/08/29 (岡村 淳司) [S5] 予約編集機能
# 2007/08/14 (岡村 淳司) [S3] 予約情報の詳細
# 2007/08/12 (岡村 淳司) 新規作成
#
require File.dirname(__FILE__) + '/../test_helper'

class CalendarTest < Test::Unit::TestCase
  fixtures :reservations, :calendars, :rooms
  
  def test_fixture_test
    assert_equal Date.new(2007,7,1), calendars(:ROOM1_1).date
  end
  
  def test_association
    assert_not_nil calendars(:ROOM1_1).reservation
    assert_equal 1,calendars(:ROOM1_1).reservation.id
    assert_equal "[End-End] 朝会",calendars(:ROOM1_1).reservation.name
  end
  
  def test_find_by_raw_interface
    calendars = Calendar.find(:all, 
                              :conditions => ["date = ?", Date.new(2007,7,1)],
    :order => "unit")
    assert_not_nil calendars
    assert_equal 60, calendars.size
    
    calendars = Calendar.find(:all,
                              :conditions => ["date = ?", Date.new(2006,7,1)],
    :order => "unit")
    assert_not_nil calendars
    assert_equal 0, calendars.size
  end
  
  def test_get_units
    calendars = Calendar.get_units(:room => 1, :date => Date.new(2007, 7 ,1))
    assert_not_nil calendars
    assert_equal 20, calendars.size
    
    calendars = Calendar.get_units(:room => 1, :date => "2007/07/01")
    assert_not_nil calendars
    assert_equal 20, calendars.size
    
    assert_equal 1,calendars[0].id
    assert_equal "09:00:00", calendars[0].start_at.strftime("%H:%M:%S")
  end
  
  def test_get_units_all
    all_units = Calendar.get_units_all("2007/07/01")
    assert_not_nil all_units
    assert_equal 3,all_units.size
    for key in all_units.keys
      assert_equal 20, all_units[key].size
    end
  end
  
  def test_get_unit
    unit = Calendar.get_unit(1,"2007/07/01",1)
    assert_not_nil unit
    
    unit = Calendar.get_unit(1,"2007-07-01",1)
    assert_not_nil unit
    
    unit = Calendar.get_unit(1, Date.strptime("2007-07-01","%Y-%m-%d"), 1)
    assert_not_nil unit
  end
  
  def test_exclusive_save
    u1 = Calendar.find(1)
    u2 = Calendar.find(1)
    
    u1.save
    
    assert_raise(ActiveRecord::StaleObjectError){u2.save}
  end
  
  def test_get_versioned_calendar
    unit = nil
    assert_nothing_raised{ unit = Calendar.get_versioned_unit(1,0) }
    assert_not_nil unit
    assert_raise(ActiveRecord::RecordNotFound){ unit = Calendar.get_versioned_unit(1,1) }
    assert_raise(ActiveRecord::RecordNotFound){ unit = Calendar.get_versioned_unit(100,0) }
  end
  
  def test_get_vacant_unit
    unit = nil
    assert_nothing_raised{ unit = Calendar.get_vacant_unit(15) }
    assert_not_nil unit
    assert_raise(ActiveRecord::RecordNotFound){ unit = Calendar.get_vacant_unit(1) }
    assert_raise(ActiveRecord::RecordNotFound){ unit = Calendar.get_vacant_unit(100) }
  end

  def test_has_units_by_month
    assert_equal false, Calendar.has_units_by_month?(1, 2007, 8)
    assert_equal true, Calendar.has_units_by_month?(1, 2007, 7)
    assert_equal false, Calendar.has_units_by_month?(1, 2006, 7)
  end
  
  def test_get_units_status
    status = Calendar.get_units_status 1,2007
    assert_equal false, status[1]
    assert_equal false, status[2]
    assert_equal false, status[3]
    assert_equal false, status[4]
    assert_equal false, status[5]
    assert_equal false, status[6]
    assert_equal true, status[7]
    assert_equal false, status[8]
    assert_equal false, status[9]
    assert_equal false, status[10]
    assert_equal false, status[11]
    assert_equal false, status[12]
  end
  
  def test_open_units_by_month
    assert_nothing_raised {
      Calendar.open_units_by_month(1,2007,8)
    }    
    units = Calendar.find(:all,
      :conditions=>["room_id=? and date between ? and ?",1,'2007-08-01','2007-08-31'])
    assert_equal 31 * 20, units.size
  end
  
  def test_delete_units_by_month
    Calendar.delete_units_by_month(1, 2007, 7)

    u = Calendar.find(:all, :conditions => ["room_id = 1 and date between '2007/07/01' and '2007/07/31'"])
    assert_equal 0, u.size
    
    r = Reservation.find(:all, :conditions => ["room_id = 1 and date between '2007/07/01' and '2007/07/31' "])
    assert_equal 0, r.size
    
  end
  
end

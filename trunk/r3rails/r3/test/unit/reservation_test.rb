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
# <@(#) $Id: reservation_test.rb,v 1.6 2007/10/06 01:37:09 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [S45] 電話会議のサポート
# 2007/10/02 (岡村 淳司) [故障] 登録時のverificationが例外に飲み込まれる
# 2007/09/02 (岡村 淳司) [S6] 排他制御
# 2007/08/22 (岡村 淳司) [S5] ユーザの予約登録機能
# 2007/08/17 (岡村 淳司) [S3] 予約の詳細表示
# 2007/08/10 (岡村 淳司) 新規作成
#
require File.dirname(__FILE__) + '/../test_helper'

class ReservationTest < Test::Unit::TestCase
  fixtures :reservations, :users, :rooms, :calendars
  
  def test_elements
    assert_not_nil reservations(:reserv1)
    assert_equal "[End-End] 朝会", reservations(:reserv1).name
  end
  
  def test_reaervation_owner
    reservation = Reservation.find(1)
    assert_equal reservations(:reserv1).id, reservation.id 
    assert_not_nil reservation.user
    assert_equal "User Name 1", reservation.user.name
    assert_equal "user1", reservation.user.login_id
    assert_not_nil reservation.room
    assert_equal "会議室1", reservation.room.name
  end
  
  def test_edit_and_save
    reserv = reservations(:reserv1) 
    assert_equal 1, reserv.id
    assert_equal "[End-End] 朝会", reserv.name
    assert_equal "定例ミーティング", reserv.description
    assert_nil reserv.updated_at
    
    reserv.name = "[End-End] 朝会"
    
    reserv = Reservation.find(1)
    assert_equal "[End-End] 朝会", reserv.name
    assert_equal "定例ミーティング", reserv.description
    assert_nil reserv.updated_at
    
    reserv.name = "[End-End] 朝会 over"
    reserv.save
    
    reserv = Reservation.find(1)
    assert_equal "[End-End] 朝会 over", reserv.name
    assert_equal "定例ミーティング", reserv.description
    assert_not_nil reserv.updated_at
  end
  
  def test_verify
    reserv = Reservation.find(1)
    
    reserv.name = ""
    reserv.date = nil
    assert_equal false ,reserv.save
    assert_equal "件名が指定されていません", reserv.errors.on("name")
    assert_equal "日付が指定されていません", reserv.errors.on("date")
    
    values = []
    reserv.errors.each do |key, value|
      values << value
    end
    assert_equal ["件名が指定されていません","日付が指定されていません"], values
  end
  
  def test_verify_unit
    reserv = Reservation.find(1)
    
    units = []
    assert_equal false, reserv.save_safe(units)
    assert_equal "時間が選択されていません", reserv.errors.on("unit")
  end
  
  def test_has_many
    reserv = Reservation.find(1)
    
    assert_equal 7, reserv.units.size
    assert_equal 1, reserv.units[0].id
    assert_equal 2, reserv.units[1].id
    assert_equal 9, reserv.units[2].id
    assert_equal 10, reserv.units[3].id
    assert_equal 11, reserv.units[4].id
    assert_equal 12, reserv.units[5].id
    assert_equal 13, reserv.units[6].id
  end
  
  def test_delete_auto
    reserv = Reservation.find(1)
    reserv.units.clear
    reserv.destroy
    assert_raise(ActiveRecord::RecordNotFound){Reservation.find(1)}
    
    unit = Calendar.find(1)
    assert_not_nil unit
    assert_nil unit.reservation
    assert_nil unit.reservation_id
    
    assert_not_nil Calendar.find(2) rescue nil
    assert_not_nil Calendar.find(9) rescue nil
    assert_not_nil Calendar.find(10) rescue nil
    assert_not_nil Calendar.find(11) rescue nil
    assert_not_nil Calendar.find(12) rescue nil
    assert_not_nil Calendar.find(13) rescue nil
  end
  
  def test_save_safe
    reserv = Reservation.find(1) rescue nil
    reserv.name = "[NEW] name"
    reserv.save_safe [1,2]
    
    reserv = Reservation.find(1) rescue nil
    assert_not_nil reserv
    assert_equal 2, reserv.units.size
    assert_equal 1, reserv.units[0].id
    assert_equal 2, reserv.units[1].id
    
    unit = Calendar.find(9) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(10) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(11) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(12) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(13) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
  end
  
  def test_save_safe_and_verify
    reserv = Reservation.find(1) rescue nil
    reserv.name = nil
    begin
      rtn = reserv.save_safe [1,2]
      assert false
    rescue
      assert_equal "件名が指定されていません", reserv.errors.on("name")
    end
  end
  
  def test_cancel
    reserv = Reservation.find(1) rescue nil
    reserv.cancel
    
    reserv = Reservation.find(1) rescue nil
    assert_nil reserv
    
    unit = Calendar.find(1) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(2) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(9) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(10) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(11) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(12) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
    unit = Calendar.find(13) rescue nil
    assert_not_nil unit
    assert_nil unit.reservation_id
  end
  
  def test_get_versioned_reservation
    r = nil
    r = Reservation.get_versioned_reservation(1,0)
    assert_not_nil r
    assert_equal 1, r.id
    
    assert_raise(ActiveRecord::RecordNotFound){ Reservation.get_versioned_reservation(1,1)}
    assert_raise(ActiveRecord::RecordNotFound){ Reservation.get_versioned_reservation(100,1)}
  end
  
  def test_exclusive_cancel
    r1 = Reservation.find(1);
    r2 = Reservation.find(1);
    r1.save
    
    assert_equal false, r2.cancel
  end
  
  def test_exclusive_save
    r1 = Reservation.find(1);
    r2 = Reservation.find(1);
    
    r1.name ="new name"
    r1.save
    
    r2.name ="new name2"
    # 予約に対する排他制御
    assert_raise(ActiveRecord::StaleObjectError){r2.save}
  end
  
  def test_exclusive_save_safe
    r1 = Reservation.find(1);
    r2 = Reservation.find(1);
    
    r1.name ="new name"
    
    rtn = false
    assert_nothing_raised{rtn = r1.save_safe([1,2,9])}
    assert_equal true, rtn
    
    r2.name ="new name2"
    # ユニット更新を伴う、予約に対する排他制御
    assert_raise(ActiveRecord::StaleObjectError){r2.save_safe([1,2,11,12])}
    
  end
  
  def test_exclusive_save_on_add_unit
    r1 = Reservation.find(1);
    u1 = Calendar.find(14)
    u2 = Calendar.find(14)
    u2.save
    
    # 予約にユニット追加時の、ユニットに対する排他制御
    assert_raise(ActiveRecord::StaleObjectError){r1.units << u1}
  end
  
  def test_exclusive_save_on_delete_unit_other
    r1 = Reservation.find(1)
    u2 = Calendar.find(13)
    u2.save
    
    u1 = Calendar.find(13)
    
    # 予約のユニット削除時の、ユニットに対する排他制御は効かない
    assert_nothing_raised{r1.units.delete(u1)}
    # このこと自体はちょっとどうかなぁと思うが、所有関係がいきているのならちゃちゃを
    # 入れられることはないはずなのでよしとする
    
    # そのせいでレコードが消されてしまうことはない
    u1 = Calendar.find(13)
    # アソシエーションも空
    assert_nil u1.reservation_id
  end
  
  def test_collection_clear
    r1 = Reservation.find(1)
    
    assert_nothing_raised{
      r1.units.clear
      r1.save
    }
    
    # そのせいでレコードが消されてしまうことはないしアソシエーションも空
    assert_nil Calendar.find(1).reservation
    assert_nil Calendar.find(2).reservation
    assert_nil Calendar.find(9).reservation
    assert_nil Calendar.find(10).reservation
    assert_nil Calendar.find(11).reservation
    assert_nil Calendar.find(12).reservation
    assert_nil Calendar.find(13).reservation
  end
  
  def test_resgist_new_reservation
    r1 = Reservation.create(:name=>"r1", :date => Date.today, :room_id=>1, :user_id=>1)
    r2 = Reservation.create(:name=>"r2", :date => Date.today, :room_id=>1, :user_id=>1)
    
    assert_nothing_raised { r1.save_safe [14,15] }
    
    assert_raise(ActiveRecord::RecordNotFound){ r2.save_safe [15,16] }
  end
  
  def test_have_a_visitor
    r4 = Reservation.find(4)
    assert r4.have_a_visitor
    
    r3 = Reservation.find(3)
    assert !r3.have_a_visitor
    assert_equal false,r3.have_a_visitor
  end
  
  def test_use_tel_meeting
    r4 = Reservation.find(4)
    assert r4.use_tel_meeting
    
    r3 = Reservation.find(3)
    assert !r3.use_tel_meeting
    assert_equal false,r3.use_tel_meeting
  end
  
end

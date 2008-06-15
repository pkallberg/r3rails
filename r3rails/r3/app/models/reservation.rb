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
# <@(#) $Id: reservation.rb,v 1.5 2007/10/02 13:55:07 jury Exp $>
#
# 改定履歴
# 2007/10/02 (岡村 淳司) [故障] 登録時のverificationが例外に飲み込まれる
# 2007/08/31 (岡村 淳司) [S6] 排他制御
# 2007/08/30 (岡村 淳司) [S5-4] 新規予約
# 2007/08/29 (岡村 淳司) [S5] 予約編集機能
# 2007/08/10 (岡村 淳司) 新規作成
#
class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  has_many :units ,
          :foreign_key => "reservation_id" ,
          :order => "date, unit",
          :dependent => false,
          :class_name => "Calendar"
  
  validates_presence_of :user_id, :message => "ユーザが指定されていません"
  validates_presence_of :room_id, :message => "部屋が指定されていません"
  validates_presence_of :date, :message => "日付が指定されていません"
  validates_presence_of :name, :message => "件名が指定されていません"
  
  #
  # Reservation インスタンスを返します。
  # @param rid Reservation id
  # @param rver Reservation lock_version
  #
  def self.get_versioned_reservation rid, rver
    r = Reservation.find(:first, :conditions => ["id=? and lock_version=?",rid, rver ])
    if r.nil?
      raise ActiveRecord::RecordNotFound, "予約が見つかりません"
    end
    r
  end
  
  #
  # 予定を保存します。
  # ユニットの更新も含めたアトミックな保存を提供します。
  # ユニットは同一日付内のユニットであることを期待しています。
  # @param new_units ユニットIDの配列
  #
  def save_safe new_calendar_ids
    if new_calendar_ids.nil? || new_calendar_ids.empty?
      self.errors.add("unit", "時間が選択されていません")
      return false
    end
    rtn = false
    Reservation.transaction do
      self.units.clear
      
      new_calendar_ids.each do |unit_id|
        unit = Calendar.get_vacant_unit(unit_id.to_i)
        self.units << unit
      end

      rtn = self.save
    end
    return rtn
  end
  
  #
  # 予定をキャンセルします
  #
  def cancel
    Reservation.transaction do
      if Reservation.find(self.id).lock_version == self.lock_version
        self.units.clear
        destroy
      else
        return false
      end
    end
    return true
  end
  
  #
  # 指定したユニットを持っているかどうかを判定します
  #
  def has_unit(target_unit)
    unit_id = nil
    if target_unit.class == String
      unit_id = target_unit.to_i
    elsif target_unit.class == Calendar
      unit_id = target_unit.id
    else
      unit_id = target_unit
    end
    
    flg = false
    self.units.each do |unit|
      flg = true if unit.id == unit_id
    end
    return flg
  end
  
end

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
# <@(#) $Id: calendar.rb,v 1.8 2007/09/27 12:38:28 jury Exp $>
#
# 改定履歴
# 2007/09/18 (岡村 淳司) [S14] Week View
# 2007/09/15 (岡村 淳司) [S25] カレンダのクローズ
# 2007/09/09 (岡村 淳司) [S18] 予約の開放 
# 2007/09/02 (岡村 淳司) [S6] 排他制御にあわせてリファクタリング
# 2007/08/29 (岡村 淳司) [S5] 予約編集機能
# 2007/08/14 (岡村 淳司) [S3] 予約情報の詳細
# 2007/08/11 (岡村 淳司) 新規作成
#
class Calendar < ActiveRecord::Base
  belongs_to :reservation
  
  #
  # 指定日の特定の部屋の予定をすべて返します。
  # @param params {}
  #          :date => 日付 YYYY-MM-DD または YYYY/MM/DD 形式
  #          :room => 部屋 id
  #
  def Calendar.get_units(params)
    Calendar.find(:all, 
                  :conditions => ["date = ? and room_id = ?", params[:date], params[:room]])
  end
  
  #
  # 指定日付での全室の予定をすべて返します。
  # @param date 日付 YYYYMMDD形式
  #
  def Calendar.get_units_all(date)
    units_by_room = Hash::new
    
    rooms = Room.find(:all, :order => "id");
    for room in rooms
      units_by_room[room] = Calendar.get_units(:date => date, :room => room.id)
    end
    
    units_by_room
  end
  
  #
  # Calendarインスタンスを返します。
  # @param room_id 部屋 id
  # @param date 日付 YYYY-MM-DD または YYYY/MM/DD 形式
  # @param unit_id ユニットID
  #
  def Calendar.get_unit(room_id, date, unit)
    Calendar.find(:first, 
                  :conditions => ["room_id = ? and date = ? and unit = ?", room_id, date, unit])
  end
  
  #
  # Calendarインスタンスを返します。
  # @param room_id 部屋 id
  # @param date 日付 YYYY-MM-DD または YYYY/MM/DD 形式
  # @param unit_id ユニットID
  #
  def Calendar.get_unit(room_id, date, unit)
    Calendar.find(:first, 
                  :conditions => ["room_id = ? and date = ? and unit = ?", room_id, date, unit])
  end
  
  #
  # Calendarインスタンスを返します。
  # @param uid Calendar id
  # @param uver Calendar lock_version
  #
  def Calendar.get_versioned_unit uid, uver
    unit = Calendar.find(:first,
                         :conditions => ["id = ? and lock_version = ?",uid, uver])
    raise ActiveRecord::RecordNotFound, "ユニットが見つかりません" if unit.nil?
    unit
  end
  
  # 
  # 空きのCalendarインスタンスを返します。
  #
  def Calendar.get_vacant_unit uid
    unit = Calendar.find(:first,
                         :conditions => ["id = ? and reservation_id is null",uid])
    raise ActiveRecord::RecordNotFound, "ユニットが見つかりません" if unit.nil?
    unit
  end
  
  #
  # ユニットの有無をチェックします。
  #
  def self.get_units_status rid, year
    status = []
    1.upto(12) do |i|
      status[i] = Calendar.has_units_by_month? rid, year, i
    end
    status
  end
  
  #
  # ユニットの有無をチェックします
  #
  def self.has_units_by_month? rid, year, month
    from,to = Calendar.from_to(year, month)
    
    num =Calendar.count(
                        :conditions=>"room_id = #{rid} and date between '#{from}' and '#{to}'")
    
    num > 0
  end
  
  #
  # 月単位でカレンダを予約可能なように開放します。
  # @param rid room id
  # @param year year
  # @param month month
  #
  def self.open_units_by_month rid, year, month
    year = year.to_i
    month = month.to_i
    max = Calendar.days_in_month(year, month)
    Calendar.transaction do
      1.upto(max) do |i|
        tab = Calendar.get_time_table(year, month, i)
        j = 0
        for unit in tab
          j += 1
          Calendar.new do |o|
            o.unit = j
            o.date = Date.new(year, month, i)
            o.start_at = unit.strftime('%H:%M:%S').to_s
            o.room_id = rid
            o.save
          end
        end
      end
    end
  end
  
  #
  # 月単位でカレンダを閉じます。その際、ユニットと予約を削除します。
  # @param rid room id
  # @param year year
  # @param month month
  # 
  def self.delete_units_by_month rid, year, month
    rid = rid.to_i
    from, to  = Calendar.from_to year, month
    Calendar.transaction do
      Calendar.delete_all(["room_id = ? and date between ? and ?",rid, from, to])
      Reservation.delete_all(["room_id = ? and date between ? and ?",rid, from, to])
    end
    rescue
    
  end
  
  private
  
  #
  # 月初、月末の両日を返します
  #
  def self.from_to year,month
    y,m = year.to_i, month.to_i
    d = Calendar.days_in_month(y, m)
    from = Date.new y, m, 1
    to = Date.new y, m, d
    return from, to
  end
  
  #
  # カレンダ設定に従いタイムテーブル用時間配列を返します。
  #
  def self.get_time_table y, m, d
    arr = []
    $R3_UNITS[:start_at].upto($R3_UNITS[:end_at]) do |i|
      0.step(59, $R3_UNITS[:term]) do |j|
        arr << DateTime.new(y, m, d, i, j, 0)
      end
    end
    arr
  end
  
  #
  # 月日数を返します
  #
  def self.days_in_month year, month
    Time.days_in_month(month.to_i, year.to_i)
  end
  
end

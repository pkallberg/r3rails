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
# <@(#) $Id: date_util.rb,v 1.1 2007/09/27 12:34:20 jury Exp $>
#
# 改定履歴
# 2007/07/19 (岡村 淳司) [リファクタリング] 日付処理の集約
#

module Cameliatk
  
  #
  # 日付ユーティリティ
  #
  module Cameliatk::DateUtil
    
    #
    # 年、週番号を日付範囲に変換して返します
    #
    def week_to_range year, wno
      year = year.to_i
      wno = wno.to_i
      
      year, wno = week_in_year(year,wno)
      d = Date.strptime("#{year}-#{wno}", "%Y-%W")
       (d - 6) .. d
    end
    
    #
    # 週番号の妥当性を検証します
    #
    def valid_week? year, wno
      year = year.to_i
      wno = wno.to_i
      
      begin
        d = Date.strptime("#{year}-#{wno}", "%Y-%W")
        return true
        rescue
        return false
      end
    end
    
    #
    # 妥当な週番号を返します。
    # 妥当な週番号計算時、年はまたぎません。
    #
    def week_in_year year, wno
      year = year.to_i
      wno = wno.to_i
      
      case wno
      when 0..1
        unless valid_week?(year,wno)
          return week_in_year(year , wno + 1)
        end
      when 52..53
        unless valid_week?(year,wno)
          return week_in_year(year, wno - 1)
        end
      end
      return year, wno
    end
    
    #
    # 次の週番号を返します。
    #
    def next_week year, wno
      year = year.to_i
      wno = wno.to_i
      
      year, wno = week_in_year(year,wno)
      return year, wno + 1 if valid_week?(year, wno + 1)
      return year + 1, 0 if valid_week?(year + 1 , 0)
      return year + 1, 1
    end
    
    #
    # 次の週番号を返します。
    #
    def prev_week year, wno
      year = year.to_i
      wno = wno.to_i
      
      year, wno = week_in_year(year,wno)
      return year, wno - 1 if valid_week?(year, wno - 1)
      return year - 1, 53 if valid_week?(year - 1 , 53)
      return year - 1, 52 if valid_week?(year - 1 , 52)
      return year - 1, 51
    end
    
  end
  
end

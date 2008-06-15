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
# <@(#) $Id: action_controller_extension.rb,v 1.1 2007/09/27 12:34:20 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # ActionController拡張
  #
  module ActionControllerExtension
    
    #
    # ActiveRecordインスタンスのエラーメッセージを配列で返します。
    #
    def get_error_messages(active_record)
      values = []
      active_record.errors.each do |key, value|
        values << value
      end
      values
    end
    
    #
    # nil, empty判定
    #
    def is_empty? str
      if str.nil? || str.empty?
        return true
      else
        return false
      end
    end
    
    #
    # nil, empty判定
    #
    def is_not_empty? str
      return !is_empty?(str)
    end
    
    #
    # 指定された文字列を日付に変換するか、今日の日付の Dateインスタンスを返します。
    #
    def date_or_today str
      if is_not_empty?(str)
        return str.to_date
      else
        return Date.today
      end
    end
    
    #
    # 指定された文字列を日付に変換するか、nil を返します。
    #
    def date_or_nil str
      if is_not_empty?(str)
        return str.to_date
      else
        return nil
      end
    end
    
  end
  
end

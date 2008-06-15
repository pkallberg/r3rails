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
# <@(#) $Id: format_helper.rb,v 1.2 2007/10/11 16:06:15 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # 整形ユーティリティ
  #
  module FormatHelper
    
    #
    # 文字列を <br/> で連結します。
    #
    def html_cat(*elements)
      elements.join("<br/>")
    end
    
    #
    # 先頭をBoldにして文字列を <br/> で連結します。
    #
    def html_popup_text(title, *elements)
    "<b>" + title + "</b><br/>" + elements.join("<br/>")
    end
    
    #
    # 日付時刻をYYYY/MM/DD hh:mm:ss形式で出力します
    #
    def f_ymdhms data
      unless data.nil?
        if data.class == Time
          data.strftime('%Y/%m/%d %H:%M:%S')
        end
      end
    end
    
    #
    # 日付をYYYY/MM/DD形式で出力します
    #
    def f_ymd_raw data
      unless data.nil?
        if data.class == Date || data.class == Time
          data.strftime('%Y%m%d')
        end
      end
    end
    
    #
    # 日付をYYYY/MM/DD形式で出力します
    #
    def f_ymd data
      unless data.nil?
        if data.class == Date || data.class == Time
          data.strftime('%Y/%m/%d')
        end
      end
    end
    
    #
    # 日付をYYYY/MM/DD(曜日)形式で出力します
    #
    def f_ymdw data
      unless data.nil?
        if data.class == Date || data.class == Time
          str = data.strftime('%Y/%m/%d')
          str << '('
          str << ['日','月','火','水','木','金','土'][data.wday]
          str << ')'
          str
        end
      end
    end
    
    #
    # 日付範囲を "YYYY年 Ww週"で返します
    #
    def f_week year, wno
     "#{year}年 W#{wno}週"
    end
    
    #
    # 日付範囲を "YYYY/MM/DD～YYYY/MM/DD"で返します
    #
    def f_range *args
      return "" if args.nil?
      return "" if args.empty?
      if args.size == 1
        if args[0].class == Range
          range = args[0]
          return "#{to_string(range.first)}～#{to_string(range.last)}"
        else
          return args[0].to_s
        end
      elsif args.size >= 2
        val_from = to_string(args[0])
        val_to = to_string(args[1])
        return "" if val_from.blank? && val_to.blank?
        return "#{val_from}～#{val_to}"
      else
        return args.inspect        
      end
    end
    
    def to_string arg
      return "" if arg.nil?
      return arg.strftime('%Y/%m/%d') if arg.class == Date || arg.class == DateTime
      return arg.to_s if arg.class == String
      return arg.inspect
    end
    
    #
    # empty処置
    #
    def f_empty data, default
      if (data.nil? || data.empty?)
        default
      else
        data
      end
    end
    
  end
  
end

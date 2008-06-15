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
# <@(#) $Id: string_extension.rb,v 1.2 2007/10/23 12:51:39 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # String拡張
  #
  module StringExtension
    
    #
    # 日付文字列をDateインスタンスに変換します。
    # 日付は YYYYMMDD、YYYY-MM-DD、YYYY/MM/DDを対応します。
    # 変換できない文字列の場合は nil を返します。
    #
    def to_date
      date = nil
      date = Date.strptime(self, "%Y%m%d") rescue nil unless date
      date = Date.strptime(self, "%Y/%m/%d") rescue nil unless date
      date = Date.strptime(self, "%Y-%m-%d") rescue nil unless date
      date
    end
    
    #
    # 拡張子（と思われる文字列）を返します。
    #
    def suffix
      r = self.scan(/\w*(\.\w+)/)
      return "" if r.empty?
      r[0][0]
    end
    
  end
  
end

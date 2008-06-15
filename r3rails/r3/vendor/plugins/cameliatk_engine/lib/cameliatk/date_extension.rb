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
# <@(#) $Id: date_extension.rb,v 1.2 2007/10/11 16:06:15 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # Date拡張
  #
  module DateExtension

    #
    # 年、週番号を日付範囲に変換して返します
    #
    def to_week
      return strftime('%Y').to_i, strftime('%W').to_i
    end
    
    #
    # YYYYMMDD形式の文字列を返します
    #
    def to_ymd
      return strftime("%Y%m%d")
    end
    
    #
    # to_s
    #
    def to_s
      return strftime("%Y/%m/%d")
    end

  end
  
end

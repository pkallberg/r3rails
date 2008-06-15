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
# <@(#) $Id: message_extension.rb,v 1.1 2007/09/27 12:34:20 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # メッセージ機構拡張
  #
  module MessageExtension
    
    #
    #
    #
    def msg(*ary)
      return to_s unless ary.is_a?(Array)
  
      s = dup
      if s.include?('?')
        for v in ary
          s.sub!(/\?/,v.to_s)
        end
      end
      s
    end
  
    #
    #
    #
    def gmsg(*ary)
      msg(*ary).gsub(/\?/,'')
    end

  end
  
end

#
# メッセージホルダー
#
$MESSAGES = {}
  

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
# <@(#) $Id: array_extension.rb,v 1.1 2007/10/23 12:51:39 jury Exp $>
#
# 改定履歴
# 2007/10/23 (岡村 淳司) 新規作成 [S59] ファイルアップロード
#

module Cameliatk
  
  #
  # Array拡張
  #
  module ArrayExtension
    
    #
    # join path elements
    #
    def join_path root=""
      arycp = self.collect do |x|
        unless x.nil?
          x = x.to_s
          x.sub!(/^\//,'')
          x.sub!(/\/$/,'')
          x
        end
      end
      arycp.reject!{|x| x.nil? || x.blank? || x == "/"}
      unless root.blank?
        if root.last == "/"
          return root + arycp.join('/')
        else
          return root + "/" + arycp.join('/')
        end
      else
        arycp.join('/')
      end
    end
    
  end
  
end

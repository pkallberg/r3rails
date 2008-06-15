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
# <@(#) $Id: drip_extension.rb,v 1.2 2007/10/23 12:51:39 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/01 (岡村 淳司) 新規作成 [S49] 予約のメンテナンス に対応して
#                        Modelからの属性抽出機能として作詞絵
#

module Cameliatk
  
  #
  # Drip機能
  #
  module DripExtension
    
    #
    # 指定された属性値を返します。
    #
    def drip *args
      arr = []
      if args.nil?
        arr << nil
      elsif args.is_a?(Array)
        args.each do |arg|
          if !arg.nil? and arg.to_s != ""
            arr << attributes()[arg.to_s]
          end
        end
      else
        arr << self.attributes()["id"]
      end
      arr
    end
    
  end
  
  #
  # コレクションに対してDrip拡張対応を施します
  #
  module Drippable
    
    #
    # 要素の属性をDripします
    #
    def drip *args
      arr = []
      self.each do |element|
        if element.respond_to?(:drip)
          arr << element.drip(*args)
        else
          arr << []
        end
      end
      arr
    end
    
  end
  
end

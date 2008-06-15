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
# <@(#) $Id: display_stack.rb,v 1.4 2007/10/23 12:51:39 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/17 (岡村 淳司) [S51] 2度押しガード（サーバサイド）
# 2007/10/16 (岡村 淳司) [S51] Framework機能拡充 SoftForward
# 2007/09/24 (岡村 淳司) [S40] 新規作成 統合Plugin化
#
require 'cameliatk/login_session_controll'

module Cameliatk
  
  #
  # ディスプレイスタック制御
  #
  module Cameliatk::DisplayStack
    include Cameliatk::LoginSessionControll
    
    #
    # DisplayStackChunk構造
    #
    Struct::new("DisplayStackChunk",:name,:data)
    
    #
    # [filter] 画面遷移スタック制御 clear
    #
    def display_stack_clear
      session[$SESSION_KEYS[:display_stack]] = []
    end

    def allow_anchor_unless_login?
      return false if $DISPLAY_STACK_OPTIONS[:allow_anchor_unless_login].nil?
      return ($DISPLAY_STACK_OPTIONS[:allow_anchor_unless_login] == true)
    end
    
    #
    # [filter] 画面遷移スタック制御 anchor
    #
    def display_stack_anchor
      unless allow_anchor_unless_login?
        return false unless is_login?  
      end
      
      session[$SESSION_KEYS[:display_stack]] ||= []
      
      chunk = Struct::DisplayStackChunk.new
      chunk.name = params[:controller]
      chunk.data = request.parameters
      
      current = session[$SESSION_KEYS[:display_stack]].first
      
      if current.nil? 
        session[$SESSION_KEYS[:display_stack]].push(chunk)
      else
        current.name = chunk.name
        current.data = chunk.data
      end
    end
    
    #
    # [filter] 画面遷移スタック制御 push
    #
    def display_stack_push
      __stack_push__ params[:controller], request.parameters
    end

    def __display_stack_push__ name, data
      session[$SESSION_KEYS[:display_stack]] ||= []
      
      chunk = Struct::DisplayStackChunk.new
      chunk.name = name
      chunk.data = data
      
      current = session[$SESSION_KEYS[:display_stack]].first
      
      if current.nil? 
        session[$SESSION_KEYS[:display_stack]].push(chunk)
      else
        if current.name == chunk.name
          current.data = chunk.data
        else
          session[$SESSION_KEYS[:display_stack]].push(chunk)
        end
      end
    end
    
    #
    # 画面遷移スタック制御 pop
    #
    def display_stack_pop
      session[$SESSION_KEYS[:display_stack]] ||= []
      session[$SESSION_KEYS[:display_stack]].pop
    end
    
    #
    # 画面遷移スタック制御 current
    #
    def display_stack_current
      session[$SESSION_KEYS[:display_stack]] ||= []
      return session[$SESSION_KEYS[:display_stack]].first
    end
    
  end
  
end
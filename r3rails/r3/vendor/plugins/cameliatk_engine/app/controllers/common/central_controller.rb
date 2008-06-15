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
# <@(#) $Id: central_controller.rb,v 1.3 2007/10/15 12:09:45 jury Exp $>
#
# 改定履歴
# 2007/10/15 (岡村 淳司) [リファクタリング] セッション周りのリファクタリング 
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/13 (岡村 淳司) [S27] スタックNULLの場合の挙動
# 2007/09/08 (岡村 淳司) 新規作成 [S22] 戻るボタン
#
class Common::CentralController < ApplicationController
  before_filter :login_required
  
  def current
    stack_data = display_stack_current
    if stack_data.nil?
      redirect_to $VIEWS[:DEFAULT]
    else
      redirect_to stack_data.data
    end
  end
  
  def backward
    stack_data = display_stack_pop
    if stack_data.nil?
      redirect_to  $VIEWS[:DEFAULT]
    else
      redirect_to stack_data.data
    end
  end
  
  def portal
    if request.post?
      goto_portal_with_rjs()
    else
      goto_portal_with_js_on_html()
    end
  end
  
end

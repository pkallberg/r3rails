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
# <@(#) $Id: login_controller.rb,v 1.7 2007/10/19 14:08:41 jury Exp $>
#
# 改定履歴
# 2007/10/19 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
# 2007/10/16 (岡村 淳司) [S51] Framework機能拡充 SoftForward
# 2007/10/13 (岡村 淳司) [リファクタリング] セッション周りのリファクタリング 
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/22 (岡村 淳司) [故障] adminユーザログアウト時に強制的にadmin系画面だとメッセージがうっとおしい
# 2007/09/08 (岡村 淳司) [故障] ログイン後にアンカー位置にジャンプしない
# 2007/09/14 (岡村 淳司) [S26] ログイン画面の独立化
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/05 (岡村 淳司) [S13] パスワード有効期限
# 2007/09/04 (岡村 淳司) リファクタリング
# 2007/09/03 (岡村 淳司) [S10] 最終ログイン日時の記録
# 2007/08/31 (岡村 淳司) 新規作成 [S1] ログイン機構
#

class Common::LoginController < ApplicationController
  layout 'layouts/common/user'
  model :user
  
  def login
    @error_message = nil
    @exception = nil
    @hard_forward_to_change_password = false
    @soft_forward_to_change_password = false
    
    begin
      user = User.authenticate(params[:login_id],params[:password])
      
      reset_session
      
      set_user_to_session(user)
      
      user.last_login_at = DateTime.now.strftime("%Y/%m/%d %H:%M:%S")
      user.save!
      
      if user.password_issued
        @hard_forward_to_change_password = true
        @error_message = $MESSAGES[:common][:login_password_issued]
      elsif user.is_expired_warning?
        @soft_forward_to_change_password = true
        __display_stack_push__("common/user", url_for(:controller=>"/common/user", :action=>"edit_personal"))
        @error_message = $MESSAGES[:common][:login_password_expired_warning]
      elsif user.is_expired?
        @hard_forward_to_change_password = true
        @error_message = $MESSAGES[:common][:login_password_expired]
      end
      rescue Exception
      @exception = true
      @error_message = $!.to_s
    end
  end
  
  def logout
    clear_session_for_logout   
    if request.post?
      goto_entrance_with_rjs()    
    else
      goto_entrance_with_js_on_html()    
    end
  end
  
end

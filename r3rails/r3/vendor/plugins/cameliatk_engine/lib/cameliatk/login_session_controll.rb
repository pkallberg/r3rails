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
# <@(#) $Id: login_session_controll.rb,v 1.5 2007/10/19 14:08:28 jury Exp $>
#
# 改定履歴
# 2007/10/17 (岡村 淳司) [S51] 2度押しガード（サーバサイド）
# 2007/10/13 (岡村 淳司) [リファクタリング] セッション周りのリファクタリング 
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/24 (岡村 淳司) [S40] 新規作成 統合Plugin化
#

module Cameliatk
  
  #
  # ログインセッション関連機能の制御に関しての機能拡張を提供します。
  #
  module LoginSessionControll
    
    #
    # エントランス URI
    #
    def entrance_view_url
      ent = "/"
      ent = url_for($VIEWS[:ENTRANCE]) if $VIEWS[:ENTRANCE]
      ent
    end
    
    #
    # ログイン済みかどうかを判断します。
    #
    def is_login?
      return ! ( session[$SESSION_KEYS[:login_user_info]].nil? || session[$SESSION_KEYS[:login_user_info]].empty? )
    end
    
    #
    # ログインユーザが管理者ユーザかどうかを判断します。
    #
    def is_admin?
      if is_login?
        return get_login_user_info()[:is_admin]
      end
      return false
    end
    
    #
    # ログインユーザのパスワードが期限切れかどうかを判断します。
    #
    def is_password_expired?
      if is_login?
        return get_login_user_info()[:expired] 
      end
      return false
    end
    
    #
    # ログインユーザのパスワードが仮パスワードかどうかを判断します。
    #
    def is_password_issued?
      if is_login?
        return get_login_user_info()[:password_issued]
      end
      return false
    end
    
    #
    # ログインidをセッションから取り出します
    #
    def get_login_user_id
      return get_login_user_info()[:user_id]
    end  
    
    #
    # ログイン情報をセッション上に設定します。
    #
    def set_user_to_session user
      dtime = user.last_login_at.strftime('%Y/%m/%d %H:%M:%S') unless user.last_login_at.nil?
      
      info = {
        :user_id => user.id,
        :username => user.name,
        :last_login=> dtime ,
        :is_admin => user.is_admin?,
        :password_term_valid => user.password_term_valid,
        :remained_days => (user.password_term_valid - Date.today).to_i,
        :expired => user.is_expired?,
        :expired_warning => user.is_expired_warning?,
        :password_issued => user.password_issued,
        :role_id => user.role_id
      }
      
      session[$SESSION_KEYS[:login_user_info]] = info
    end
    
    #
    # ログイン情報をセッション上からクリアします。
    #
    def clear_user_to_session
      session[$SESSION_KEYS[:login_user_info]] = nil
    end
    
    #
    # ログイン情報を返します。
    #
    def get_login_user_info
      return session[$SESSION_KEYS[:login_user_info]]
    end
    
    #
    # ログインセッションをクリーンにします。
    #
    def clean_session_attributes
      $SESSION_KEYS.each_key do |key|
        session[$SESSION_KEYS[key]] = nil
      end
    end
    
    #
    # ログアウトのためのセッションを破棄します。
    #
    def clear_session_for_logout
      display_stack_clear
      clear_user_to_session
      
      clean_session_attributes
      
      close_session
    end
    
    #
    # RJSを使ってEntranceへ移動します。
    #
    def goto_entrance_with_rjs target="top"
      rjs = __with_js__(entrance_view_url(), target)
      render :update do |page|
        page << rjs
      end
    end
    
    #
    # RJSを使ってPortalへ移動します。
    #
    def goto_portal_with_rjs target="top"
      rjs = __with_js__(url_for($VIEWS[:PORTAL_FRAME]), target)
      render :update do |page|
        page << rjs
      end
    end
    
    #
    # Entranceへ移動します。
    #
    def goto_entrance_with_js_on_html target="top"
      render :text => __with_js_on_html__(entrance_view_url(), target)
    end
    
    #
    # Portalへ移動します。
    #
    def goto_portal_with_js_on_html target="top"
      render :text => __with_js_on_html__(url_for($VIEWS[:PORTAL_FRAME]), target)
    end
    
    #
    # 特定ページへ移動するJavaScriptを含むHTMLを返します。
    #
    def __with_js_on_html__ url, target="top"
      target ||= "top"
      "<script type=\'text/javascript\'>#{__with_js__(url, target)}</script>"
    end
    
    #
    # 特定ページへ移動するJavaScriptを返します。
    #
    def __with_js__ url, target="top"
      target ||= "top"
      "#{target}.location.href = '#{url}'"
    end
    
  end
  
end
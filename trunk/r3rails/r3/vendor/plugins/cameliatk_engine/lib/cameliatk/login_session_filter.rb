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
# <@(#) $Id: login_session_filter.rb,v 1.7 2007/10/18 14:56:19 jury Exp $>
#
# 改定履歴
# 2007/10/13 (岡村 淳司) [リファクタリング] セッション周りのリファクタリング 
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

module Cameliatk
  
  #
  # ログインセッションを使用したフィルタ機能を提供します
  #
  module LoginSessionFilter
    include Cameliatk::LoginSessionControll
    
    #
    # [Filter] ログインの有無をチェックします
    #
    def login_required
      unless is_login?
        alart_secure $MESSAGES[:common][:login_required]
        if request.post?
          goto_entrance_with_rjs
        else
          goto_entrance_with_js_on_html
        end
        return false
      end
    end
    
    #
    # [Filter] 管理者権限の有無をチェックします
    #
    def admin_required
      unless is_login?
        login_required
        return false
      end
      unless is_admin?
        alart_secure $MESSAGES[:common][:admin_required]
        redirect_to $VIEWS[:CURRENT]
        return false
      end
    end
    
    #
    # [Filter] ログインしている場合に、ユーザの状態によって遷移先を変更させます。
    # ・パスワードが期限切れか
    # ・パスワードが新規発行か
    #
    def password_term_valid_if_login
      if is_login? and is_password_expired?
        alart_secure $MESSAGES[:common][:login_password_expired]
        redirect_to $VIEWS[:PASSWORD_CHANGE]
        return false
      elsif is_login? and is_password_issued?
        alart_secure $MESSAGES[:common][:login_password_issued]
        redirect_to $VIEWS[:PASSWORD_CHANGE]
        return false
      end
    end
    
    #
    # [Filter] ロール権限有無をチェックします
    #
    def privilege_required
      if is_login?
        unless User.find(get_login_user_id()).role.allow?(params)
          alart_secure $MESSAGES[:common][:not_allowed_access]
          redirect_to $VIEWS[:CURRENT]
          return false
        end
      end
    end

    #
    # flashにセキュリティアラートを設定します。
    #
    def alart_secure msg=""
      return if msg.blank?
      flash[:secure_message] ||= ""
      if flash[:secure_message].blank?
        flash[:secure_message] << msg 
      else
        flash[:secure_message] << "\n#{msg}"
      end
    end
    
  end
  
end

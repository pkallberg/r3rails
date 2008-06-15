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
# <@(#) $Id: user_controller.rb,v 1.7 2008/01/26 12:55:05 jury Exp $>
#
# 改定履歴
# 2007/10/26 (岡村 淳司) [故障] 戻ると常に「ログインが必要・・・」と言われる
# 2007/10/16 (岡村 淳司) [故障] パスワード変更の2回目でパスワードフィールドが化ける
# 2007/10/15 (岡村 淳司) [S51] Framework機能の拡充 パスワード要件
# 2007/10/08 (岡村 淳司) [S54] ユーザ新規作成時にロールを割り当て
# 2007/10/03 (岡村 淳司) [故障] HardForward後のログインがportalに向かわない
# 2007/10/01 (岡村 淳司) [S47] 新規作成 メニュー機構
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/08 (岡村 淳司) [故障] 属性変更が即時に反映されていない
# 2007/09/08 (岡村 淳司) [故障] ユーザ属性変更のValidatesが効いていない 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/07 (岡村 淳司) [S13] パスワード有効期限
# 2007/09/04 (岡村 淳司) リファクタリング
# 2007/09/03 (岡村 淳司) [S9] アカウント属性変更
# 2007/09/03 (岡村 淳司) 新規作成 [S8] ユーザ登録
#
require 'cameliatk/password_util'

class Common::UserController < ApplicationController
  layout 'layouts/common/user'
  model :user
  before_filter :login_required, :except => [:registration, :regist_new_user]
  
  def registration
    reset_session
    @user = User.new
  end
  
  def edit_personal
    @title = "登録情報の変更"
    @user = User.find(get_login_user_id)
  end
  
  def change_your_password
    @force_change_password = true
    edit_personal
    render :action => 'edit_personal'
  end
  
  def regist_new_user
    @error_messages = []
    
    if params[:password].empty?
      @error_messages << "パスワードを指定してください。"
      return
    end
    if params[:password] != params[:password_verify]
      @error_messages << "パスワードとパスワード(確認)が異なります。"
      return
    end
    
    user = User.create(params[:user])
    user.password=params[:password]
    user.role = role_for_new_user()
    
    begin
      user.save!
      set_user_to_session(user)
      rescue
      @error_messages = get_error_messages user
    end
  end
  
  def role_for_new_user
    Role.find($NEW_USER_CONFIGURATIONS[:role_id])
  end
  
  @@ARP_L = /[A-Z]/
  @@ARP_S = /[a-z]/
  @@NUM = /[0-9]/
  
  def regist
    @error_messages = []
    user = User.find(params[:user][:id])
    user.name = params[:user][:name]
    @force_change_password = params[:force_change_password]
    
    unless params[:password_changed].nil?
      if params[:password].empty?
        @error_messages << "新しいパスワードを指定してください。"
        return
      end
      if params[:password] != params[:password_verify]
        @error_messages << "パスワードとパスワード(確認)が異なります。"
        return
      end
      
      verify_results = []
      unless Cameliatk::PasswordUtil.verify(:length, params[:password], {:size=>8})
        verify_results << $MESSAGES[:common][:bad_password_length].msg(8)
      end
      unless Cameliatk::PasswordUtil.verify(:exclude_words, params[:password], {:words=>user.login_id})
        verify_results << $MESSAGES[:common][:bad_password_exclude].msg("ログインID")
      end
      unless Cameliatk::PasswordUtil.verify(:include_regexp, params[:password], {:regexp=>[@@ARP_L,@@ARP_S,@@NUM]})
        verify_results << $MESSAGES[:common][:bad_password_include].msg("英小文字、英大文字、数字")
      end
      unless Cameliatk::PasswordUtil.verify(:succesive, params[:password], {:size=>3})
        verify_results << $MESSAGES[:common][:bad_password_succesive].msg(3)
      end
      unless verify_results.empty?
        @error_messages.concat verify_results
        return
      end
      
      user.password=params[:password]
      user.password_issued = false
    end
    
    begin
      if user.save!
        set_user_to_session(user)
      else
        @error_messages = get_error_messages user
      end
      rescue
      @error_messages = get_error_messages user
    end
    
  end
  
end

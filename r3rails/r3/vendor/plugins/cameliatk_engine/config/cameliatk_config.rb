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
# <@(#) $Id: cameliatk_config.rb,v 1.9 2008/01/26 12:55:06 jury Exp $>
#
# 改定履歴
# 2007/10/24 (岡村 淳司) [S61] loading
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/17 (岡村 淳司) [S51] 2度押しガード（サーバサイド）
# 2007/10/14 (岡村 淳司) [リファクタリング] url
# 2007/10/08 (岡村 淳司) [S54] ユーザ新規作成時にロールを割り当て
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/27 (岡村 淳司) 新規作成 [S44] 統合Plugin化 2nd
#

#
# Windowタイトル
#
$WINDOW_TITLE = "cameliaTk.jp"

#
# View
#
$VIEWS = {
  # エントランス画面（通常はログイン画面）
  :ENTRANCE => {:controller => "common/login", :action => "index"},
  # ポータル画面（ログイン画面直後のフレームセット）
  :PORTAL_FRAME => {:controller => "/portal", :action => "index"},
  # デフォルトビュー設定（ログイン直後のコンテンツ画面）
  :DEFAULT  => {:controller => "common/bulletin_board", :action => "today"},
  # 
  :CURRENT  => {:controller => "common/central", :action => "current"},
  # メニュー
  :MENU  => {:controller => "common/menu", :action => "index"},
  # 強制パスワード変更画面
  :PASSWORD_CHANGE  => {:controller => 'common/user', :action => 'edit_personal'}
}

#
# ロゴ等
#
$LOGO = {
  :login => "/plugin_assets/cameliatk_engine/images/cameliatk_jp-slogo.png",
  :menu => "/plugin_assets/cameliatk_engine/images/cameliatk_jp-banner.jpg"
}

#
# セッションキー
#
$SESSION_KEYS ={
  :display_stack => :display_stack,
  :login_user_info => :login_user_info,
  :session_token => :session_token
}

#
# パスワード有効期限設定
#
$LOGIN_PASSWORD_CONFIG = {
  :issued_password_valid_term => 7,
  :valid_term => 60,
  :expired_warning_term => 7,
  :abeyance_term => 7,
  :max_faults => 5
}

#
# 新規ユーザのコンフィグレーション
#
$NEW_USER_CONFIGURATIONS = {
  :role_id => 2
}

#
# 画面遷移スタックオプション
#
$DISPLAY_STACK_OPTIONS = {
  :allow_anchor_unless_login => true
}

#
# アップロードファイルオプション
#
$FILE_UPLOAD_OPTIONS = {
  :host => "localhost",
  :base => "#{RAILS_ROOT}/upload-files"
}

#
# View component options
#
$VIEW_COMPONENT_OPTIONS = {
  :loading_splash_id => "loading"
}

#
# $MESSAGE[:common]のロード
#
def __DIR__(*args) File.join(File.dirname(__FILE__), *args) end
require __DIR__("messages/common")

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
# <@(#) $Id: init.rb,v 1.7 2008/01/26 12:55:06 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/19 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
# 2007/10/10 (岡村 淳司) [S36] フィードバック装置（掲示版） ActiveRecord拡張
# 2007/10/01 (岡村 淳司) [S49] 予約のメンテナンス に対応して
#                        Modelからの属性抽出機能として作詞絵
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#

$CAMLEIATK = {
  :name => "cameliaTk.jp", 
  :copyright_owner => "The Camelia-Framework Foundation",
  :copyright_year => "2007"
}
$CAMELIATK_COPYRIGHT = "&copy; #{$CAMLEIATK[:copyright_year]} #{$CAMLEIATK[:copyright_owner]} all right reserved."

def __DIR__(*args) File.join(File.dirname(__FILE__), *args) end
def __LOADING__ klasspath
  require klasspath
  __LOADING_MSG__ klasspath
end
def __LOADING_MSG__ msg
  puts "[#{$CAMLEIATK[:name]}] loading #{msg} ..."
end

#
# Message機構拡張
#
__LOADING__ 'cameliatk/message_extension'
String.__send__ :include, Cameliatk::MessageExtension

#
# Date拡張
#
require 'date'
__LOADING__ 'cameliatk/date_extension'
Date.__send__ :include, Cameliatk::DateExtension

#
# String拡張
#
__LOADING__ 'cameliatk/string_extension'
String.__send__ :include, Cameliatk::StringExtension

#
# ActinoController拡張
#
# 画面移動制御フィルタ
__LOADING__ 'cameliatk/display_stack'
ActionController::Base.__send__ :include, Cameliatk::DisplayStack
# 日付関連拡張
__LOADING__ 'cameliatk/date_util'
ActionController::Base.__send__ :include, Cameliatk::DateUtil
# セッション関連ユーティリティ
__LOADING__ 'cameliatk/login_session_controll'
ActionController::Base.__send__ :include, Cameliatk::LoginSessionControll
# セッション制御フィルタ
__LOADING__ 'cameliatk/login_session_filter'
ActionController::Base.__send__ :include, Cameliatk::LoginSessionFilter
# エラーメッセージ加工等の汎用部品
__LOADING__ 'cameliatk/action_controller_extension'
ActionController::Base.__send__ :include, Cameliatk::ActionControllerExtension
# エラーメッセージ加工等の汎用部品
__LOADING__ 'cameliatk/session_token'
ActionController::Base.__send__ :include, Cameliatk::SessionTokenMixin

#
# Array拡張 join_path
#
__LOADING__ 'cameliatk/array_extension'
ActiveRecord::Base.__send__ :include, Cameliatk::ArrayExtension
Array.__send__ :include, Cameliatk::ArrayExtension

#
# Array拡張 Drip対応
#
__LOADING__ 'cameliatk/drip_extension'
ActiveRecord::Base.__send__ :include, Cameliatk::DripExtension
Array.__send__ :include, Cameliatk::Drippable

#
# ActiveRecord拡張 (Class method extensions)
#
__LOADING__ 'cameliatk/active_record_extension'
ActiveRecord::Base.module_eval do
  extend Cameliatk::ActiveRecordExtension
end

#
# ActionView拡張
#
__LOADING__ 'cameliatk/view_extension'


#
# cameliaTk.jp 自体の設定情報のロード
#
__LOADING_MSG__ "camliaTk.jp web configuration"
require __DIR__("config/cameliatk_config")

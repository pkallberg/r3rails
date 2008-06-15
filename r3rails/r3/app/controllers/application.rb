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
# <@(#) $Id: application.rb,v 1.21 2007/09/27 12:38:29 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) [S40] 統合Plugin化
# 2007/09/22 (岡村 淳司) [故障] adminユーザログアウト時に強制的にadmin系画面だとメッセージがうっとおしい
# 2007/09/17 (岡村 淳司) [S14] Week View
# 2007/09/16 (岡村 淳司) [故障] adminがadmin系画面からログアウトした場合、アンカー対象画面の場合警告が出る
# 2007/09/15 (岡村 淳司) [S27] ログイン画面Forward
# 2007/09/13 (岡村 淳司) [S23] sesssion[:date]の解放
# 2007/09/12 (岡村 淳司) [S18] カレンダの解放
# 2007/09/09 (岡村 淳司) [リファクタリング] 日付書式ユーティリティの移動 
# 2007/09/08 (岡村 淳司) [S22] 戻るボタン
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/04 (岡村 淳司) [S13] パスワード有効期限
# 2007/09/04 (岡村 淳司) リファクタリング
# 2007/09/02 (岡村 淳司) [S10] 最終ログイン日時の記録
# 2007/09/02 (岡村 淳司) リファクタリング
# 2007/08/31 (岡村 淳司) [S1] ログイン機構
# 2007/08/29 (岡村 淳司) [S5] 予約の登録 日付データに関するリファクタリング
# 2007/08/07 (岡村 淳司) 新規作成
#
require 'r3config'
require 'messages/admin'

class ApplicationController < ActionController::Base
  session :session_key => '_r3_session_id'
  
end

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
# <@(#) $Id: application_helper.rb,v 1.11 2007/10/19 14:09:33 jury Exp $>
#
# 改定履歴
# 2007/10/17 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
# 2007/10/12 (岡村 淳司) [S58] カスタムタグ拡張 
# 2007/09/24 (岡村 淳司) [S40] 統合Plugin化
# 2007/07/19 (岡村 淳司) [S14] Week View
# 2007/09/09 (岡村 淳司) [リファクタリング] 日付書式ユーティリティの移動 
# 2007/09/08 (岡村 淳司) [S15] 会議室のプロパティ
# 2007/09/07 (岡村 淳司) パスワード有効期限
# 2007/09/04 (岡村 淳司) リファクタリング
# 2007/08/29 (岡村 淳司) [S5] 予約の登録機能 
# 2007/08/17 (岡村 淳司) [S3] 予約の詳細表示
# 2007/08/07 (岡村 淳司) 新規作成
#

require 'cameliatk/login_session_controll'
require 'cameliatk/format_helper'
require 'cameliatk/date_util'

module ApplicationHelper
  
  # 整形ユーティリティ
  include Cameliatk::FormatHelper
  
  # 日付関連拡張
  include Cameliatk::DateUtil
  
  # セッション関連ユーティリティ
  include Cameliatk::LoginSessionControll
  
  # View拡張
  include Cameliatk::ViewExtension

  # SessionToken拡張
  include Cameliatk::SessionTokenHelperMixin

end

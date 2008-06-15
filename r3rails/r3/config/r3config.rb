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
# <@(#) $Id: r3config.rb,v 1.8 2007/09/27 12:36:30 jury Exp $>
#
# 改定履歴
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/19 (岡村 淳司) [S32] String拡張のplugin化
# 2007/09/13 (岡村 淳司) [S27] スタックNULLの場合の挙動
# 2007/09/09 (岡村 淳司) [S18] 予約の開放 
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/04 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/04 (岡村 淳司) 新規作成 [S13] パスワード有効期間
#

#
# カレンダユニット設定
#
$R3_UNITS = {
  :start_at => 9,
  :end_at => 18,
  :term => 30
}


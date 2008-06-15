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
# <@(#) $Id: common.rb,v 1.3 2007/10/16 13:32:55 jury Exp $>
#
# 改定履歴
# 2007/10/15 (岡村 淳司) [S51] Framework機能の拡充 パスワード要件
# 2007/10/14 (岡村 淳司) [S51] フレームワーク機能 1st アクセス制限
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/05 (岡村 淳司) 新規作成 [S13] パスワード有効期限
#
$MESSAGES[:common] = {
  :login_required => "サービスを利用するにはログインする必要があります。",
  :admin_required => "メンテナンス機能を利用するには管理者権限が必要です。",
  :login_password_expired_warning => "パスワードの有効期限が迫っています。\nパスワードを変更してください。",
  :login_password_expired => "パスワードの有効期限が切れています。\nパスワードを変更してください。",
  :login_password_issued => "このパスワードは仮パスワードです。\nパスワードを変更してください。" ,
  :locked => "ロックアウトされました。\n管理者にお問い合わせください。",
  :login_invalid => "ログインIDまたはパスワードが違います。",
  :not_allowed_access => "アクセスは許可されていません。",
  :bad_password_length => "パスワードは?桁以上にしてください。",
  :bad_password_exclude => "パスワードに?を含められません。",
  :bad_password_include => "パスワードに?を含めてください。",
  :bad_password_succesive => "パスワードに?連続以上の同じ文字を含めないでください。"
}.freeze

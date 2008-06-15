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
# <@(#) $Id: day_controller.rb,v 1.15 2007/10/19 14:15:41 jury Exp $>
#
# 改定履歴
# 2007/10/17 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/24 (岡村 淳司) [S40] 統合Plugin化
# 2007/09/08 (岡村 淳司) [故障] パラメータ不正の場合の処置
# 2007/09/17 (岡村 淳司) [S28] 日付ジャンプ
# 2007/09/14 (岡村 淳司) [S26] ログイン画面の独立化
# 2007/09/13 (岡村 淳司) [S23] sesssion[:date]の解放
# 2007/09/08 (岡村 淳司) [S22] 戻るボタン
# 2007/09/06 (岡村 淳司) [S13] パスワード有効期限 フィルタ追加
# 2007/09/03 (岡村 淳司) [S8] ユーザ登録 go_back 動作に関するリファクタリング
# 2007/09/03 (岡村 淳司) [S7] キーナビゲーションサポート
# 2007/08/30 (岡村 淳司) [S5-4] 新規予約
# 2007/08/29 (岡村 淳司) [S5] 予約の登録 日付データに関するリファクタリング
# 2007/08/20 (岡村 淳司) [S4] day_view 特定日付対応 リファクタリング
# 2007/08/19 (岡村 淳司) [S4] day_view 特定日付対応
# 2007/08/12 (岡村 淳司) 新規作成
#

class View::DayController < ApplicationController
  before_filter :login_required
  before_filter :password_term_valid_if_login
  before_filter :privilege_required
  after_filter :display_stack_anchor, :only => "index"
  after_filter :reset_token
  
  def index
    id = params[:date] || params[:id]
    param_date = date_or_nil(id)
    if param_date.nil?
      redirect_to :action => :index, :date => Date.today.to_ymd
      return
    end
    
    @all_units_by_room = Calendar.get_units_all(param_date)
    @day = param_date
  end
  
  def goto
    @date = date_or_today(params[:goto_date]).to_ymd
  end

end

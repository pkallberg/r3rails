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
# <@(#) $Id: reservation_controller.rb,v 1.19 2007/10/19 15:18:31 jury Exp $>
#
# 改定履歴
# 2007/10/19 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
# 2007/10/09 (岡村 淳司) [故障] Admin以外で予約登録できない
# 2007/10/05 (岡村 淳司) [S45] 電話会議のサポート
# 2007/10/02 (岡村 淳司) [故障] 登録時のverificationが例外に飲み込まれる
# 2007/10/01 (岡村 淳司) [S47] 統合Plugin化 ロール、アクセス権
# 2007/10/01 (岡村 淳司) [S49] 予約のメンテナンス
# 2007/09/24 (岡村 淳司) [S40] 統合Plugin化
# 2007/09/09 (岡村 淳司) [リファクタリング] @date除去
# 2007/09/09 (岡村 淳司) [故障] ユーザ機構リファクタリングによるUser情報方法の誤り
# 2007/09/06 (岡村 淳司) [S13 パスワード有効期限 フィルタ追加
# 2007/09/04 (岡村 淳司) リファクタリング
# 2007/08/31 (岡村 淳司) [S6] 排他制御
# 2007/08/30 (岡村 淳司) [S5-4] 新規予約
# 2007/08/20 (岡村 淳司) 新規作成 [S5] 予約編集機能
#

class View::ReservationController < ApplicationController
  before_filter :login_required
  before_filter :password_term_valid_if_login
  before_filter :get_enable_editors
  
  def get_enable_editors
    @editors = []
    if is_admin?
      @editors = User.enable_users
    end
  end
  
  #
  # [Action] 予約編集画面に予約を表示します。
  #
  def get
    @error_messages = []
    
    begin
      @reservation = Reservation.find(params[:id])
      @units = Calendar.get_units(:date => @reservation.date, :room => @reservation.room.id )
      if is_editable_reservation?(@reservation)
        @token_string = reset_token
        render :action => "edit_view.rjs"
      else
        render :action => "view.rjs"
      end
      return
    rescue
      @error_messages << "この予約または時間は他の人によって更新されています。"
      render :action => "exclusive_access.rjs"
    end
  end
  
  #
  # [Action] 予約の新規登録画面を表示します
  #
  def new_entry
    @token_string = reset_token
    
    @reservation = Reservation.new(:name=>"", :description=>"")
    @reservation.room = Room.find(params[:room_id])
    @reservation.user = User.find(get_login_user_info()[:user_id])
    @reservation.date = date_or_nil(params[:date])
    
    selected_units = params[:selected_units].split('$')
    selected_units ||= []
    
    selected_units.each do |unit_id|
      unit = Calendar.find(unit_id)
      @reservation.units << unit
    end
    
    @units = Calendar.get_units(:date => @reservation.date, :room => @reservation.room.id )
    
    render :action => "edit_view.rjs"
  end
  
  #
  # [Action] 予定を更新します
  #
  def regist
    @error_messages = []
    begin
      assert_token
      
      if params[:id].nil? || params[:id].empty? || params[:id] == "null"
        rsv = Reservation.new
      else
        rsv = Reservation.get_versioned_reservation(params[:id], params[:lock_version])
      end
      
      rsv.name = params[:name]
      rsv.description = params[:description]
      rsv.date = date_or_nil(params[:date])
      rsv.room_id = params[:room_id]
      rsv.user_id = params[:user_id]
      rsv.have_a_visitor = (params[:have_a_visitor] == "true")
      rsv.use_tel_meeting = (params[:use_tel_meeting] == "true")
      selected_units = params[:selected_units].split('$')
      selected_units ||= []
      
      rtn = rsv.save_safe(selected_units)
      unless rtn
        @error_messages = get_error_messages(rsv)
      end
    rescue
      @error_messages << "この予約または時間は他の人によって更新されています。"
      render :action => "exclusive_access.rjs"
    end
  end
  
  #
  # [Action] 予約を解除します
  #
  def cancel
    @error_messages = []
    
    begin
      rsv = Reservation.get_versioned_reservation(params[:id], params[:lock_version])
      unless rsv.cancel
        @error_messages = get_error_messages(rsv)
      end
      rescue
      @error_messages << "この予約または時間は他の人によって更新されています。"
      render :action => "exclusive_access.rjs"
    end
  end
  
  private
  
  #
  # 予約が編集可能かを判断します。
  # @param rsv Reservation インスタンス
  # @return 予約のオーナとログインユーザが一致する場合 true
  #
  def is_editable_reservation?(rsv)
    if is_login?
      if is_admin?
        return true
      else
        return rsv.user_id == get_login_user_id
      end
    else
      return false;
    end
    return true
  end
  
end

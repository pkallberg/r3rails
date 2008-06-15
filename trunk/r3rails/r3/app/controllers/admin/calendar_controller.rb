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
# <@(#) $Id: calendar_controller.rb,v 1.5 2007/10/16 13:40:55 jury Exp $>
#
# 改定履歴
# 2007/10/02 (岡村 淳司) [S47] 統合Plugin化 ロール、アクセス権
# 2007/09/15 (岡村 淳司) [S25] カレンダのクローズ
# 2007/09/09 (岡村 淳司) 新規作成 [S18] 予約の開放 
#
class Admin::CalendarController < ApplicationController
  before_filter :admin_required
  before_filter :privilege_required
  after_filter :display_stack_anchor, :only => "list"
  
  #
  # [Action] 会議室の解放状況一覧を返します。
  #
  def index
    redirect_to :action => 'list', :year => Date.today.strftime('%Y').to_i
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  #
  # [Action] 指定年の会議室の解放状況を返します。
  #
  def list
    if params[:year].nil? || params[:year].empty?
      redirect_to :action => 'list', :year => Date.today.strftime('%Y').to_i
      return
    end
    @year = params[:year].to_i
        
    @rooms = Room.find(:all)
    @status = []
    for room in @rooms
      @status << {:room=>room, :units_status => Calendar.get_units_status(room.id, @year)}
    end
  end

  #
  # [Action] 部屋、月指定で会議室を開放します。
  #
  def open_units_by_month
    room_id = params[:room].to_i
    year = params[:year].to_i
    month = params[:month].to_i
    if Calendar.has_units_by_month?(room_id, year, month)
      @message  = $MESSAGES[:admin][:units_already_exist].msg("#{year}年#{month}月")
    else
      begin
        Calendar.open_units_by_month room_id, year, month
      rescue
        @message = $!.to_s
      end
    end
    render :action => "result.rjs"
  end

  #
  # [Action] 部屋、月指定で会議室を閉じます。
  #
  def delete_units_by_month
    room_id = params[:room].to_i
    year = params[:year].to_i
    month = params[:month].to_i
    begin
      Calendar.delete_units_by_month room_id, year, month
    rescue
      @message = $!.to_s
    end
    render :action => "result.rjs"
  end
  
  #
  # [Action] 月指定ですべての会議室を開放します。
  #
  def open_units_all_by_month
    year = params[:year].to_i
    month = params[:month].to_i
    @messages = []
    begin
      for room in Room.find(:all) do
        if Calendar.has_units_by_month?(room.id, year, month)
          @messages << $MESSAGES[:admin][:skip_make_units_by_monthly].msg(room.name, year, month)
        else
          Calendar.open_units_by_month room.id, year, month
        end
      end
    rescue
      @messages << $!.to_s
    end
    render :action => "result.rjs"
  end

end

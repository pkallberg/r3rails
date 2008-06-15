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
# <@(#) $Id: room_controller.rb,v 1.6 2007/10/16 13:40:55 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/10/02 (岡村 淳司) [S47] 統合Plugin化 ロール、アクセス権
# 2007/09/13 (岡村 淳司) [S12-x] リファクタリング
# 2007/09/05 (岡村 淳司) [S13] パスワード有効期限 リファクタリング 
# 2007/09/03 (岡村 淳司) 新規作成 [S11] 管理機能 Room
#

class Admin::RoomController < ApplicationController
  before_filter :admin_required
  before_filter :privilege_required
  after_filter :display_stack_anchor, :only => "list"
  
  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @room_pages, @rooms = paginate :rooms, :order => "name", :per_page => 10
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    if @room.save
      flash[:notice] = 'Room was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(params[:room])
      flash[:notice] = 'Room was successfully updated.'
      redirect_to :action => 'show', :id => @room
    else
      render :action => 'edit'
    end
  end

  def destroy
    Room.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

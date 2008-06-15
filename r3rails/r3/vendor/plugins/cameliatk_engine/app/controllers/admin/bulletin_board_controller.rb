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
# <@(#) $Id: bulletin_board_controller.rb,v 1.3 2008/01/26 12:55:02 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/11 (岡村 淳司) [S56] 新規作成 アナウンスメンテナンス
#
require 'digest/sha2'

class Admin::BulletinBoardController < ApplicationController
  include Admin::BulletinBoardAttachDownloadMixin
  
  layout "layouts/admin/user"
  before_filter :login_required
  before_filter :admin_required
  after_filter :display_stack_anchor, :only => ["list","show_access_conditions","show_attach_files"]
  
  def index
    redirect_to :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list
    @bulletin_board_pages, @bulletin_boards = paginate :bulletin_boards, :per_page => 20
  end
  
  def show
    @bulletin_board = BulletinBoard.find(params[:id])
  end
  
  def show_attach_files
    @bulletin_board = BulletinBoard.find(params[:id])
  end
  
  def show_access_conditions
    @bulletin_board = BulletinBoard.find(params[:id])
  end
  
  def new
    @bulletin_board = BulletinBoard.new(:title => "新しいお知らせ" )
  end
  
  def create
    @bulletin_board = BulletinBoard.new(params[:bulletin_board])
    
    if @bulletin_board.save
      flash[:notice] = 'BulletinBoard was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @bulletin_board = BulletinBoard.find(params[:id])
  end
  
  def update
    @bulletin_board = BulletinBoard.find(params[:id])
    @bulletin_board.update_attributes(params[:bulletin_board])
    
    if @bulletin_board.save
      flash[:notice] = 'BulletinBoard was successfully updated.'
      redirect_to :action => 'show', :id => @bulletin_board
    else
      @bulletin_board = BulletinBoard.find(params[:id])
      render :action => 'edit'
    end
  end
  
  def update_access_conditions
    @bulletin_board = BulletinBoard.find(params[:id])
    @access_conditinos = params[:access_conditions]
    
    @access_conditinos.each do |cond|
      unless cond[:id].blank?
        bbac = BulletinBoardAccessCondition.find(cond[:id])
        if cond[:conditions].blank?
          bbac.destroy
        else
          bbac.conditions = cond[:conditions]
          bbac.save
        end
      else
        bbac = BulletinBoardAccessCondition.new()
        bbac.conditions = cond[:conditions]
        @bulletin_board.access_conditions << bbac
      end
    end
    
    if @bulletin_board.save
      flash[:notice] = 'BulletinBoardAccessConditinos was successfully updated.'
      redirect_to :action => 'show_access_conditions', :id => @bulletin_board
    else
      @bulletin_board = BulletinBoard.find(params[:id])
      redirect_to :action => 'show_access_conditions', :id => @bulletin_board
    end
  end
  
  def add_attach_file
    @bulletin_board = BulletinBoard.find(params[:id])
    flg = false
    
    BulletinBoard.transaction do
      bbaf = BulletinBoardAttachment.new

      bbaf.bulletin_board_id = params[:id]
      bbaf.name = params[:display_name]
      bbaf.filedata = params[:upload_file]
      if params[:download_name].blank?
        unless params[:upload_file].nil?
          bbaf.download_name = params[:upload_file].original_filename
        end
      else
        bbaf.download_name = params[:download_name]
      end
      bbaf.host = $FILE_UPLOAD_OPTIONS[:host]
      bbaf.path = @bulletin_board.attach_path
      # TODO 検疫
      bbaf.out_of_quarantine = true
      bbaf.passed_quarantine = true

      unless bbaf.save
        flash[:notice] = get_error_messages(bbaf)
    end
    end
    @bulletin_board = BulletinBoard.find(params[:id])
    render :action=>"show_attach_files"
  end
  
  def remove_attach_file
    bbaf = BulletinBoardAttachment.find(params[:file_id])
    bbaf.destroy
    
    @bulletin_board = BulletinBoard.find(params[:id])
    render :action=>"show_attach_files"
  end
  
  def destroy
    BulletinBoard.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

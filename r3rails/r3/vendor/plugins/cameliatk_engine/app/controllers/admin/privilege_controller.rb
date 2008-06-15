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
# <@(#) $Id: privilege_controller.rb,v 1.2 2007/10/11 16:09:47 jury Exp $>
#
# 改定履歴
# 2007/10/09 (岡村 淳司) [S55] 新規作成 権限メンテナンス
#
class Admin::PrivilegeController < ApplicationController
  layout "layouts/admin/user"
  before_filter :login_required
  before_filter :admin_required
  after_filter :display_stack_anchor, :only => "list"
  
  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @privilege_pages, @privileges = paginate :privileges, :per_page => 20
  end

  def show
    @privilege = Privilege.find(params[:id])
  end

  def new
    @privilege = Privilege.new(:name => "新しい権限" )
    @parent_privileges = parent_privileges_for_select_options
  end

  def create
    @privilege = Privilege.new(params[:privilege])

    if @privilege.save
      flash[:notice] = 'Privilege was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @privilege = Privilege.find(params[:id])
    @parent_privileges = parent_privileges_for_select_options
  end

  def parent_privileges_for_select_options
    Privilege.find(:all, :conditions=>["node_type='menu'"], :order => :sort_order).drip(:name, :id).unshift([])
  end

  def update
    
    @privilege = Privilege.find(params[:id])
    @privilege.update_attributes(params[:privilege])
    
    if @privilege.save
      flash[:notice] = 'Privilege was successfully updated.'
      redirect_to :action => 'show', :id => @privilege
    else
      @privilege = Privilege.find(params[:id])
      render :action => 'edit'
    end
  end

  def destroy
    Privilege.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

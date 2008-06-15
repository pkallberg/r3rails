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
# <@(#) $Id: role_controller.rb,v 1.1 2007/10/07 15:56:59 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [S53] 新規作成 ロールメンテナンス
#
class Admin::RoleController < ApplicationController
  layout "layouts/admin/user"
  before_filter :login_required
  before_filter :admin_required
  after_filter :display_stack_anchor, :only => "list"
  
  #in_place_edit_for :role, :name

  def set_role_name
    id_on_js = "role_name_#{params[:id]}_in_place_editor"
    role = Role.find(params[:id])
    old = role.name
    role.name = params[:value]
    if role.save
      render :update do |page|
        page[id_on_js].replace_html role.name
      end
    else
      rn = params[:value]
      render :update do |page|
        page.alert role.errors.on("name")
        page[id_on_js].replace_html old
      end
    end
  end
  
  def index
    redirect_to :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @role_pages, @roles = paginate :roles, :per_page => 10
  end

  def show
    @role = Role.find(params[:id])
    @all_privileges = Privilege.top_nodes
  end

  def new
    @role = Role.new(:name => "新規ロール" )
    @all_privileges = Privilege.top_nodes
  end

  def create
    @role = Role.new(params[:role])
    privileges = params[:privileges].collect{|x| x[1]} unless params[:privileges].nil?
    privileges.each do |x|
      @role.privileges << Privilege.find(x) unless x == ""
    end

    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find(params[:id])
    @all_privileges = Privilege.top_nodes
  end

  def update
    privileges = []
    privileges = params[:privileges].collect{|x| x[1]} unless params[:privileges].nil?
    
    @role = Role.find(params[:id])
    @role.privileges.clear
    privileges.each do |x|
      @role.privileges << Privilege.find(x) unless x == ""
    end
    @role.name = params[:role][:name]
    
    if @role.save
      flash[:notice] = 'Role was successfully updated.'
      redirect_to :action => 'show', :id => @role
    else
      @role = Role.find(params[:id])
      render :action => 'edit'
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

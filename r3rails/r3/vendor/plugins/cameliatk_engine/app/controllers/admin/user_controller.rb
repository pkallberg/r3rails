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
# <@(#) $Id: user_controller.rb,v 1.7 2007/10/15 12:10:58 jury Exp $>
#
# 改定履歴
# 2007/10/13 (岡村 淳司) [リファクタリング] セッション周りのリファクタリング 
# 2007/10/05 (岡村 淳司) [故障] ログイン系フィルタの二重使用
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/10/05 (岡村 淳司) [故障] パスワードが常に初期化される
# 2007/10/05 (岡村 淳司) [S52] ロール設定機能
# 2007/10/01 (岡村 淳司) [S47] メニュー機構
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin 2nd
# 2007/09/13 (岡村 淳司) [S12-x] リファクタリング
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/05 (岡村 淳司) [S13] パスワード有効期限 リファクタリング 
# 2007/09/04 (岡村 淳司) 新規作成 [S12] 管理機能 User
#

class Admin::UserController < ApplicationController
  layout "layouts/admin/user"
  before_filter :admin_required
  after_filter :display_stack_anchor, :only => "list"
  
  def index
    redirect_to :action => 'list'
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  
  def list
    @user_pages, @users = paginate :users, :order => "login_id", :per_page => 10
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
    @user.password = ""
    @roles = get_roles
  end
  
  def create
    @error_messages = ""
    
    @user = User.new
    @user.login_id = params[:user][:login_id]
    @user.name = params[:user][:name]
    @user.admin = params[:user][:admin]
    @user.role_id = params[:user][:role_id]
    @user.password_issued = params[:user][:password_issued]
    @user.password_term_valid = params[:password_term_valid]
    @user.password_faults = 0
    
    if params[:password].blank?
      @user.errors.add("password", "パスワードを指定してください。") 
      @roles = get_roles
      render :action => 'new'
      return
    end
    @user.password= params[:password]
    
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'show', :id => @user
    else
      @roles = get_roles
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @roles = get_roles
  end
  
  def get_roles
    rolelist = Role.find(:all).drip(:name,:id)
    empty = ["",""]
    rolelist.unshift empty
    rolelist
  end
  
  def update
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
    @user.admin = params[:user][:admin]
    @user.enable = params[:user][:enable]
    @user.role_id = params[:user][:role_id]
    unless params[:password_changed].nil?
      @user.password= params[:password]
    end
    if params[:user][:password_issued] == "true"
      @user.password_issued = true
      @user.password_term_valid = params[:password_term_valid]
      @user.password_faults = 0
    end
    
    if @user.save
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'show', :id => @user
    else
      @roles = get_roles
      render :action => 'edit', :id => @user
    end
  end
  
  def destroy
    begin
      User.find(params[:id]).destroy_and_cancel_reservations
      rescue Exception
      flash[:notice] = $!.to_s
    end
    redirect_to :action => 'list'
  end
  
  def new_password
    @pass = User.new_password
    @term_valid_date = Date.today + $LOGIN_PASSWORD_CONFIG[:issued_password_valid_term]
  end
end

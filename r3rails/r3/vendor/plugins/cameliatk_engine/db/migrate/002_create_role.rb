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
# <@(#) $Id: 002_create_role.rb,v 1.2 2007/10/02 13:54:42 jury Exp $>
#
# 改定履歴
# 2007/09/30 (岡村 淳司) [S47] 新規作成 統合Plugin化 ロール、アクセス権
#
class CreateRole < ActiveRecord::Migration
  def self.up
    # 単一ロールの場合
    add_column "users", "role_id", :integer
    
    # ロール複数の場合
    # create_table "roles_users", :force => "true", :id => false  do |t|
    #   t.column "role_id", :integer, :null => false
    #   t.column "user_id", :integer, :null => false
    # end
    
    create_table "roles", :force => "true" do |t|
      t.column "name", :string, :null => false
      
      t.column "lock_version", :integer, :default => 0
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
    
    create_table "privileges_roles", :force => "true", :id => false do |t|
      t.column "privilege_id", :integer, :null => false
      t.column "role_id", :integer, :null => false
    end
    add_index "privileges_roles", [:privilege_id, :role_id], :name => "pk_privileges_roles", :unique => true

    create_table "privileges", :force => "true" do |t|
      t.column "name", :string, :null => false
      t.column "sort_order", :integer, :null => false, :default => 0
      t.column "controller", :string
      t.column "action", :string
      t.column "node_type", :string
      t.column "parent_id", :integer, :null => true, :default => nil
      
      t.column "lock_version", :integer, :default => 0
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
    
  end
  def self.down
    # 単一ロールの場合
    remove_column "users", "role_id"
    
    # ロール複数の場合
    #drop_table "roles_users"
    
    drop_table "roles"
    
    remove_index "privileges_roles", :name => "pk_privileges_roles"
    drop_table "privileges_roles"
    
    drop_table "privileges"
    
  end
end

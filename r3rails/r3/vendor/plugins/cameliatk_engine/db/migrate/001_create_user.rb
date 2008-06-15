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
# <@(#) $Id: 001_create_user.rb,v 1.1 2007/10/01 13:00:04 jury Exp $>
#
# 改定履歴
# 2007/09/30 (岡村 淳司) [S47] 新規作成 統合Plugin化 ロール、アクセス権
#
class CreateUser < ActiveRecord::Migration
  def self.up
    create_table "users", :force => "true" do |t|
      t.column "login_id", :string, :null => false
      t.column "name", :string, :null => false
      t.column "admin",  :boolean, :default => false
      t.column "enable", :boolean, :default => true
      t.column "password_hash", :string
      t.column "password_salt", :string
      t.column "password_term_valid", :date, :default => Date.today
      t.column "password_issued", :boolean, :default => false
      t.column "last_login_at", :timestamp
      t.column "password_faults", :integer, :default => 0

      t.column "lock_version", :integer, :default => 0
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end

    add_index :users, [:login_id], :name => "uniq_login_id", :unique => true
  end
  
  def self.down
    drop_table "users"
  end
end

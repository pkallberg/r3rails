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
# <@(#) $Id: 005_create_user.rb,v 1.1 2007/08/29 13:21:43 jury Exp $>
#
# 改定履歴
# 2007/08/22 (岡村 淳司) [S5] 予約編集機能
#
class CreateUser < ActiveRecord::Migration
  def self.up
    create_table "users", :force => "true" do |t|
      t.column "login_id", :string, :null => false
      t.column "name", :string, :null => false
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
    add_column "reservations", "user_id", :integer, :null => false
    add_column "reservations", "room_id", :integer
    add_column "reservations", "date", :date, :null => false
    add_column "reservations", "created_at", :timestamp
    add_column "reservations", "updated_at", :timestamp
  end

  def self.down
    remove_column "reservations", "user_id"
    remove_column "reservations", "room_id"
    remove_column "reservations", "date"
    remove_column "reservations", "created_at"
    remove_column "reservations", "updated_at"
    drop_table "users"
  end
end

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
# <@(#) $Id: 004_create_calendars.rb,v 1.1 2007/08/14 08:25:22 jury Exp $>
#
# 改定履歴
# 2007/08/10 (岡村 淳司) 新規作成
#
class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars, :force => "true" do |t|
      t.column "date", :date, :null => false
      t.column "unit", :integer, :null => false
      t.column "start_at", :time
      t.column "end_at", :time
      t.column "term", :integer
      t.column "reservation_id", :integer
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "room_id", :integer, :null => false
    end
    add_index :calendars, [:date, :unit]
  end
  
  def self.down
    drop_table :calendars
  end
end

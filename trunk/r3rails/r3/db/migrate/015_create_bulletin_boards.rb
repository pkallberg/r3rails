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
# <@(#) $Id: 015_create_bulletin_boards.rb,v 1.2 2007/10/23 12:45:54 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
class CreateBulletinBoards < ActiveRecord::Migration
  
  def self.up
    create_table "bulletin_boards", :force => "true" do |t|
      t.column "title", :string, :null => false
      t.column "comment", :string, :null => true
      t.column "sort_order", :integer, :default => 0
      t.column "opened_at", :date
      t.column "closed_at", :date
      t.column "enable", :boolean, :default => true
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "lock_version", :integer, :default => 0
    end
    add_index :bulletin_boards, [:sort_order], :name => "bb_sort"

    create_table "bulletin_board_access_conditions", :force => "true" do |t|
      t.column "bulletin_board_id", :integer, :null => false
      t.column "conditions", :string, :null => true
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "lock_version", :integer, :default => 0
    end
    
    create_table "bulletin_board_attachments", :force => "true" do |t|
      t.column "bulletin_board_id", :integer, :null => false
      t.column "name", :string
      t.column "download_name", :string
      t.column "host", :string
      t.column "path", :string
      t.column "file_name", :string
      t.column "passed_quarantine", :boolean, :default => false
      t.column "out_of_quarantine", :boolean, :default => false
      t.column "quarantine_status", :string
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "lock_version", :integer, :default => 0
    end

  end
  
  def self.down
    remove_index :bulletin_boards, :name => :bb_sort

    drop_table "bulletin_board_attachments"
    drop_table "bulletin_board_access_conditions"
    drop_table "bulletin_boards"

  end
end

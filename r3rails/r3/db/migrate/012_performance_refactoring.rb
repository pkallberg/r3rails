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
# <@(#) $Id: 012_performance_refactoring.rb,v 1.1 2007/09/27 12:30:32 jury Exp $>
#
# 改定履歴
# 2007/09/26 (岡村 淳司) [S38] 性能試験
#
class PerformanceRefactoring < ActiveRecord::Migration
  
  def self.up
    add_index :calendars, [:room_id, :date, :unit], :name => "room_date_unit", :unique => true
  end
  
  def self.down
    remove_index :calendars, :name => :room_date_unit
  end
  
end

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
# <@(#) $Id: 007_lock_version.rb,v 1.1 2007/09/02 13:58:51 jury Exp $>
#
# 改定履歴
# 2007/08/31 (岡村 淳司) [S6] 排他制御
#
class LockVersion < ActiveRecord::Migration
  def self.up
    add_column "reservations", "lock_version", :integer, :default => 0
    add_column "calendars", "lock_version", :integer, :default => 0
  end

  def self.down
    remove_column "reservations", "lock_version"
    remove_column "calendars", "lock_version"
  end
end

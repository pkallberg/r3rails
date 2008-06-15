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
# <@(#) $Id: 008_admin.rb,v 1.1 2007/09/04 12:13:41 jury Exp $>
#
# 改定履歴
# 2007/08/31 (岡村 淳司) [S12] 管理機能 User
#
class Admin < ActiveRecord::Migration
  def self.up
    add_column "users", "admin",  :boolean, :default => false
    add_column "users", "enable", :boolean, :default => true
  end

  def self.down
    remove_column "users", "admin"
    remove_column "users", "enable"
  end
end

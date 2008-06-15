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
# <@(#) $Id: 009_password_valid_term.rb,v 1.1 2007/09/07 08:17:25 jury Exp $>
#
# 改定履歴
# 2007/09/04 (岡村 淳司) [S13] パスワード有効期限
#
class PasswordValidTerm < ActiveRecord::Migration
  def self.up
    add_column "users", "password_term_valid", :date, :default => Date.today
    add_column "users", "password_issued", :boolean, :default => false
  end

  def self.down
    remove_column "users", "password_term_valid"
    remove_column "users", "password_issued"
  end
end

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
# <@(#) $Id: role.rb,v 1.4 2007/10/14 10:27:06 jury Exp $>
#
# 改定履歴
# 2007/10/12 (岡村 淳司) [S51] フレームワーク機能 1st
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/09/30 (岡村 淳司) 新規作成 [S47] 統合Plugin化 ロール、アクセス権
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :privileges
  
  validates_presence_of :name, :message => "名前が指定されていません"
  validates_uniqueness_of :name, :message => "名前が重複しています"
  
  def top_nodes
    cp_arr = privileges.dup
    cp_arr.reject!{|x| x.parent_id != nil}
    cp_arr
  end
  
  def sorted_privileges_list
    list = []
    self.top_nodes.each do |priv|
      list.concat(scan_privileges(priv))
    end
    list
  end
  
  def all_privilege_id_list
     all_priv_id_list = []
     self.sorted_privileges_list.each {|x| all_priv_id_list << x.id}
     all_priv_id_list
  end
  
  def allow? args={}
    privileges.each do |priv|
      return true if priv.allow?(args)
    end
    return false
  end
  
  private

  def scan_privileges priv
    list = []
    list << priv unless self.privileges.index(priv).nil?
    priv.children.each do |child|
      list.concat(scan_privileges(child))
    end
    list
  end
  
end
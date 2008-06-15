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
# <@(#) $Id: privilege.rb,v 1.4 2007/10/14 10:27:06 jury Exp $>
#
# 改定履歴
# 2007/10/12 (岡村 淳司) [S51] フレームワーク機能 1st
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/09/30 (岡村 淳司) 新規作成 [S47] 統合Plugin化 ロール、アクセス権
#

class Privilege < ActiveRecord::Base
  acts_as_tree :order => "sort_order"
  
  has_and_belongs_to_many :roles

  validates_presence_of :name, :message => "名前が指定されていません"
  validates_uniqueness_of :name, :message => "名前が重複しています"

  def self.top_node_by_role rid
    Privilege.find(:all, :conditions => ["role_id = ? and parent_id is null",rid])
  end
  
  def is_item?
    return (self.node_type == 'menu_item')
  end

  def is_menu?
    return (self.node_type == 'menu')
  end
  
  def uri
    u = [self.controller , self.action]
    "/" + u.reject{|x| x.nil? or x == ""}.join('/')
  end

  def self.top_nodes
    find(:all, :conditions => ["parent_id is null"], :order => "sort_order")
  end
  
  def allow? args={}
    return false if args.nil?
    return false unless args.has_key?(:controller)
    return false if args[:controller].blank?
    return (args[:controller] == self.controller)
  end
end
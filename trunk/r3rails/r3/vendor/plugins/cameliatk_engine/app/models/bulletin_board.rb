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
# <@(#) $Id: bulletin_board.rb,v 1.2 2007/10/23 12:46:36 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
require 'fileutils'

class BulletinBoard < ActiveRecord::Base
  validates_presence_of :title, :message => "タイトルが指定されていません"
  
  has_many :access_conditions,
  :dependent => :destroy,
  :class_name => "BulletinBoardAccessCondition"
  
  has_many :attach_files,
  :order => "name,file_name",
  :dependent => :destroy,
  :class_name => "BulletinBoardAttachment"
  
  def self.today params={}
    @bb_list = find(:all, :conditions=>["enable=true"], :order=>"sort_order, opened_at").reject{|x| !x.can_read?(params)}
    @bb_list
  end
  
  def can_read? params={}
    return false if params.nil?
    return false if unpublicized?
    
    condition = true
    access_conditions.each do |cond| 
      condition = (condition and cond.eval_access_conditions(params))
    end
    return condition
  end
  
  def past_article?
    return false if self.opened_at.nil? || self.opened_at.blank?
    return (Date.today > self.opened_at)
  end
  
  def unpublicized?
    return false if self.opened_at.nil? || self.opened_at.blank?
    return (Date.today < self.opened_at)
  end
  
  def after_destroy
    begin
      FileUtils.rmdir(attach_path)
    rescue
      #TODO log
    end
  end
  
  def attach_path
    [$FILE_UPLOAD_OPTIONS[:base],"/bulletin_board", self.id].join_path
  end
  
end

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
# <@(#) $Id: bulletin_board_attachment.rb,v 1.2 2007/10/23 12:46:36 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
require 'fileutils'

class BulletinBoardAttachment < ActiveRecord::Base
  validates_presence_of :name, :message => "名前が指定されていません"
  validates_uniqueness_of :name, :scope => :bulletin_board_id, :message => "名前が重複しています"
  
  belongs_to :bulletin_board
  
  attr_accessor :filedata
  
  #
  # 検疫に合格したかどうかを判定します。
  #
  def passed_quarantine?
    passed_quarantine
  end
  
  #
  # 添付ファイルが検疫済みかどうかを判定します。
  #
  def out_of_quarantine?
    out_of_quarantine
  end
  
  #
  # 添付ファイルが有効かどうかを判定します。
  # 添付ファイルが有効であるとは下記の条件を満たすことを言います。
  # ・検疫済みである
  # ・検疫を合格した
  #
  def enable_attachment?
    passed_quarantine && out_of_quarantine
  end
  
  #
  # 絶対パスを返します。
  #
  def absolute_path
    [self.path, self.file_name].join_path("/")
  end
  
  #
  # 相対パスを返します。
  #
  def relative_path base="./"
    [self.path, self.file_name].join_path(base)
  end
  
  #
  #
  #
  def after_create
    self.file_name = self.id.to_s + self.download_name.suffix
    self.save
    
    FileUtils.mkdir_p(self.path)
    File.open(self.relative_path, "wb") { |f| f.write(self.filedata.read) }
  end
  
  #
  #
  #
  def after_destroy
    begin
      FileUtils.rm(self.relative_path)
    rescue
      #TODO log
    end
  end

end

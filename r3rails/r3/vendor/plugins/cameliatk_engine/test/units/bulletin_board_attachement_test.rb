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
# <@(#) $Id: bulletin_board_attachement_test.rb,v 1.2 2007/10/23 12:50:49 jury Exp $>
#
# 改定履歴
# 2007/10/20 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class BulletinBoardAttachmentTest < Test::Unit::TestCase
  fixtures :bulletin_boards
  
  def test_fullpath
    bba = BulletinBoardAttachment.new(:file_name => "filename")
    assert_equal "/filename", bba.absolute_path
    
    bba.path = "dir/dir"
    assert_equal "/dir/dir/filename", bba.absolute_path
    
    bba.path = "dir/dir/"
    assert_equal "/dir/dir/filename", bba.absolute_path

  end

  def test_relative_path
    bba = BulletinBoardAttachment.new(:file_name => "filename")
    bba.path = "dir/dir/"
    assert_equal "./dir/dir/filename", bba.relative_path()

    bba.path = "dir/dir/"
    assert_equal "attach/dir/dir/filename", bba.relative_path("attach")

    bba.path = "dir/dir/"
    assert_equal "attach/dir/dir/filename", bba.relative_path("attach/")
  end
  
  def test_save
    bb = BulletinBoard.find(1)
    bba = BulletinBoardAttachment.new(:file_name => "filename", :name=>"a file")
    bb.attach_files << bba
    assert bba.save
  end
end

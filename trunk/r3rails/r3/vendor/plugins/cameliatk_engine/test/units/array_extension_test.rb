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
# <@(#) $Id: array_extension_test.rb,v 1.1 2007/10/23 12:50:30 jury Exp $>
#
# 改定履歴
# 2007/10/23 (岡村 淳司) 新規作成 [S59] ファイルアップロード
#

require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class ArrayExtensionTest < Test::Unit::TestCase
  def test_join_path
    assert_equal "", ["","","",""].join_path
    assert_equal "", ["/","/","/","/"].join_path
    assert_equal "", ["/","",nil,"/"].join_path
    
    assert_equal "sample/sample/sample.xls", ["sample/sample","sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["sample/sample/","sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["sample/sample/","/sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["/sample/sample/","/sample.xls"].join_path
  end
  
  def test_join_path_bytop
    assert_equal "", ["","","",""].join_path("")
    assert_equal "", ["/","/","/","/"].join_path("")
    assert_equal "", ["/","",nil,"/"].join_path(nil)
    
    assert_equal "sample/sample/sample.xls", ["sample/sample","sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["sample/sample/","sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["sample/sample/","/sample.xls"].join_path
    assert_equal "sample/sample/sample.xls", ["/sample/sample/","/sample.xls"].join_path
  end
end

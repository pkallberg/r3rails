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
# <@(#) $Id: privilege_test.rb,v 1.2 2007/10/07 15:56:38 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/10/01 (岡村 淳司) [S47] 新規作成 統合Plugin化 ロール、アクセス権
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :roles, :privileges_roles, :privileges
  
  def test_privilege
    privilege = privileges(:menu_L1)
    assert_equal 2, privilege.children.size
    assert_equal 2, privilege.children[0].id
    assert_equal 3, privilege.children[1].id
    assert_equal 0, privilege.children[0].children.size
    assert_equal 0, privilege.children[1].children.size
  end
  
  def test_top_nodes
   top_nodes = Privilege.top_nodes()
   assert_equal 7, top_nodes.size
  end

end

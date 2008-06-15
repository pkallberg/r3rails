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
# <@(#) $Id: role_test.rb,v 1.3 2007/10/14 10:26:49 jury Exp $>
#
# 改定履歴
# 2007/10/12 (岡村 淳司) [S51] フレームワーク機能 1st アクセス制限
# 2007/10/05 (岡村 淳司) [S53] ロールメンテナンス
# 2007/09/30 (岡村 淳司) [S47] 新規作成 統合Plugin化 ロール、アクセス権
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :roles, :privileges_roles, :privileges
  
  def test_role_privilege
    role = roles(:role_00001)
    assert_equal 5, role.privileges.size
    
    p = Privilege.find(4)
    role.privileges << p
    
    role.save
    role = roles(:role_00001)
    assert_equal 6, role.privileges.size
  end
  
  def test_del
    assert_equal 5, Privilege.count_by_sql("select count(*) from privileges_roles where role_id = 1")
    
    role = roles(:role_00001)
    p = role.privileges[0]
    role.privileges.delete(p)
    role.save
    
    assert_equal 4, role.privileges.size
    assert_equal 4, Privilege.count_by_sql("select count(*) from privileges_roles where role_id = 1")
  end
  
  def test_get_top_node
    role = roles(:role_00001)
    top_nodes = role.top_nodes
    assert_equal 3, top_nodes.size
    assert_equal "pro1", top_nodes[0].name
    assert_equal "pro7", top_nodes[1].name
    assert_equal "pro8", top_nodes[2].name
  end
  
  def test_scan
    role = roles(:role_00001)
    list = role.sorted_privileges_list
    assert_equal "pro1", list[0].name
    assert_equal "pro2", list[1].name
    assert_equal "pro3", list[2].name
    assert_equal "pro7", list[3].name
    assert_equal "pro8", list[4].name
    assert_equal 5, list.size
  end
  
  def test_verify
    role = roles(:role_00001)
    role.name = ""
    assert !role.save
    assert_equal "名前が指定されていません", role.errors.on("name")
  end
  
  def test_allow
    url = {:controller=>"view/day"}
    bad = {:controller=>"bad/bad/bad"}
    
    role = 
    assert !roles(:role_00001).allow?(url)
    assert roles(:admin).allow?(url)
    
    assert !roles(:admin).allow?()
    assert !roles(:admin).allow?(nil)
    assert !roles(:admin).allow?({})
    
  end
  
end

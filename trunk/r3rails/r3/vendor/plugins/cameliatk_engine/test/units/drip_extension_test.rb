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
# <@(#) $Id: drip_extension_test.rb,v 1.1 2007/09/30 04:27:42 jury Exp $>
#
# 改定履歴
# 2007/10/01 (岡村 淳司) 新規作成 [S49] 予約のメンテナンス に対応して
#                        Modelからの属性抽出機能として作詞絵
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/drip_extension'
class Drip
  include Cameliatk::DripExtension
  def attributes()
    {"id" => "id", "name" => "name"}
  end
end
class NoDrip
end

class DripExtensionTest < Test::Unit::TestCase
  
  def test_drip_extension
    drip = Drip.new
    assert drip.respond_to?(:drip)
    h = {"id" => "id", "name" => "name"}
    assert_equal h, drip.attributes
    assert_equal "id", drip.attributes["id"]
    assert_equal [], drip.drip
    assert_equal [], drip.drip(nil)
    assert_equal [], drip.drip("")
    assert_equal ["id"], drip.drip("id")
    assert_equal ["id","name"], drip.drip(:id,:name)
  end
  
  def test_drippable
    arr = []
    arr << Drip.new
    arr << Drip.new
    arr << Drip.new

    assert_equal [[],[],[]], arr.drip()
    assert_equal [["id"],["id"],["id"]], arr.drip("id")
  end

  def test_drippable2
    arr = []
    arr << Drip.new
    arr << NoDrip.new
    arr << Drip.new

    assert_equal [[],[],[]], arr.drip()
    assert_equal [["id"],[],["id"]], arr.drip("id")
  end

end
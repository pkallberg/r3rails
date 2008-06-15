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
# <@(#) $Id: message_extension_test.rb,v 1.1 2007/09/27 12:34:19 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/message_extension'
String.__send__ :include, Cameliatk::MessageExtension

class MessageExtensionTest < Test::Unit::TestCase
  
  def test_message_extension
    assert_equal "a ? b ? c ?", "a ? b ? c ?".msg()
    assert_equal "a  b ? c ?", "a ? b ? c ?".msg(nil)
    assert_equal "a A b ? c ?", "a ? b ? c ?".msg("A")
    assert_equal "a A b B c ?", "a ? b ? c ?".msg("A","B")
    assert_equal "a A b B c C", "a ? b ? c ?".msg("A","B","C")
    assert_equal "a A b B c C", "a ? b ? c ?".msg("A","B","C","D")
    
    assert_equal "a  b  c ", "a ? b ? c ?".gmsg()
    assert_equal "a  b  c ", "a ? b ? c ?".gmsg(nil)
    assert_equal "a A b  c ", "a ? b ? c ?".gmsg("A")
    assert_equal "a A b B c ", "a ? b ? c ?".gmsg("A","B")
    assert_equal "a A b B c C", "a ? b ? c ?".gmsg("A","B","C")
    assert_equal "a A b B c C", "a ? b ? c ?".gmsg("A","B","C","D")
  end
  
end

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
# <@(#) $Id: string_extension_test.rb,v 1.1 2007/09/27 12:34:19 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/String_extension'
String.__send__ :include, Cameliatk::StringExtension

class StringExtensionTest < Test::Unit::TestCase
  
  def test_to_date
    assert_equal Date.new(2007,7,1), "20070701".to_date
    assert_equal Date.new(2007,7,1), "2007-07-01".to_date
    assert_equal Date.new(2007,7,1), "2007/07/01".to_date
    
    assert_equal nil, "".to_date
    assert_equal nil, "BADPARAM".to_date
  end
  
end

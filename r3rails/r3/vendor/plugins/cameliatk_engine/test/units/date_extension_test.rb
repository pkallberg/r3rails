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
# <@(#) $Id: date_extension_test.rb,v 1.1 2007/09/27 12:34:19 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/date_extension'
Date.__send__ :include, Cameliatk::DateExtension

class DateExtensionTest < Test::Unit::TestCase
  
  def test_to_week
    d = Date.new(2007,7,1)
    y,w = d.to_week()
    assert_equal 2007, y
    assert_equal 26, w
  end
  
  def test_to_ymd
    d = Date.new(2007,7,1)
    assert_equal "20070701",d.to_ymd
  end

end

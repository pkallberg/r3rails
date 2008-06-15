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
# <@(#) $Id: date_util_test.rb,v 1.1 2007/09/27 12:34:19 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/date_util'

class DateUtilTest < Test::Unit::TestCase
  include Cameliatk::DateUtil
  
  def test_valid_week
    assert_equal true, valid_week?(1999,0)
    assert_equal true, valid_week?(1999,1)
    assert_equal true, valid_week?(1999,2)
    assert_equal true, valid_week?(1999,51)
    assert_equal false, valid_week?(1999,52)
    assert_equal false, valid_week?(1999,53)
    
    assert_equal true, valid_week?(2000,0)
    assert_equal true, valid_week?(2000,1)
    assert_equal true, valid_week?(2000,2)
    assert_equal true, valid_week?(2000,51)
    assert_equal true, valid_week?(2000,52)
    assert_equal false, valid_week?(2000,53)
    
    assert_equal false, valid_week?(2001,0)
    assert_equal true, valid_week?(2001,1)
    assert_equal true, valid_week?(2001,2)
    assert_equal true, valid_week?(2001,51)
    assert_equal true, valid_week?(2001,52)
    assert_equal false, valid_week?(2001,53)
    
    assert_equal true, valid_week?(2002,0)
    assert_equal true, valid_week?(2002,1)
    assert_equal true, valid_week?(2002,2)
    assert_equal true, valid_week?(2002,51)
    assert_equal false, valid_week?(2002,52)
    assert_equal false, valid_week?(2002,53)
    
    assert_equal true, valid_week?(2003,0)
    assert_equal true, valid_week?(2003,1)
    assert_equal true, valid_week?(2003,2)
    assert_equal true, valid_week?(2003,51)
    assert_equal false, valid_week?(2003,52)
    assert_equal false, valid_week?(2003,53)
    
    assert_equal true, valid_week?(2004,0)
    assert_equal true, valid_week?(2004,1)
    assert_equal true, valid_week?(2004,2)
    assert_equal true, valid_week?(2004,51)
    assert_equal false, valid_week?(2004,52)
    assert_equal false, valid_week?(2004,53)
    
    assert_equal true, valid_week?(2005,0)
    assert_equal true, valid_week?(2005,1)
    assert_equal true, valid_week?(2005,2)
    assert_equal true, valid_week?(2005,51)
    assert_equal false, valid_week?(2005,52)
    assert_equal false, valid_week?(2005,53)
    
    assert_equal true, valid_week?(2006,0)
    assert_equal true, valid_week?(2006,1)
    assert_equal true, valid_week?(2006,2)
    assert_equal true, valid_week?(2006,51)
    assert_equal true, valid_week?(2006,52)
    assert_equal false, valid_week?(2006,53)
    
    assert_equal false, valid_week?(2007,0)
    assert_equal true, valid_week?(2007,1)
    assert_equal true, valid_week?(2007,2)
    assert_equal true, valid_week?(2007,51)
    assert_equal true, valid_week?(2007,52)
    assert_equal false, valid_week?(2007,53)
  end
  
  def test_week_in_year
    y,w = week_in_year(2005, 0)
    assert_equal [2005,0], [y, w]
    y,w = week_in_year(2005, 1)
    assert_equal [2005,1], [y, w]
    y,w = week_in_year(1999, 0)
    assert_equal [1999,0], [y, w]
    y,w = week_in_year(2001, 0)
    assert_equal [2001,1], [y, w]
    
    y,w = week_in_year(2005, 52)
    assert_equal [2005,51], [y, w]
    y,w = week_in_year(2005, 53)
    assert_equal [2005,51], [y, w]
    y,w = week_in_year(2000, 52)
    assert_equal [2000, 52], [y, w]
    y,w = week_in_year(2000, 53)
    assert_equal [2000,52], [y, w]
    
    y,w = week_in_year(2005, 0)
    assert_equal [2005,0], [y, w]
  end
  
  def test_next_week
    y,w = next_week(2004, 51) 
    assert_equal [2005, 0], [y, w]
    
    y,w = next_week(2004, 52) 
    assert_equal [2005, 0], [y, w]
    
    y,w = next_week(2004, 53) 
    assert_equal [2005, 0], [y, w]
    
    y,w = next_week(2006, 51) 
    assert_equal [2006, 52], [y, w]
    
    y,w = next_week(2006, 52) 
    assert_equal [2007, 1], [y, w]
    
    y,w = next_week(2006, 53) 
    assert_equal [2007, 1], [y, w]
    
    y,w = next_week(2007, 0) 
    assert_equal [2007, 2], [y, w]
    
    y,w = next_week(2007, 1) 
    assert_equal [2007, 2], [y, w]
  end
  
  def test_prev_week
    y,w = prev_week(2004, 51) 
    assert_equal [2004, 50], [y, w]
    y,w = prev_week(2004, 52) 
    assert_equal [2004, 50], [y, w]
    y,w = prev_week(2004, 53) 
    assert_equal [2004, 50], [y, w]
    
    y,w = prev_week(2005, 1) 
    assert_equal [2005, 0], [y, w]
    y,w = prev_week(2005, 0) 
    assert_equal [2004, 51], [y, w]
    
    y,w = prev_week(2007, 2) 
    assert_equal [2007, 1], [y, w]
    
    y,w = prev_week(2007, 1) 
    assert_equal [2006, 52], [y, w]
    
    y,w = prev_week(2007, 0) 
    assert_equal [2006, 52], [y, w]
  end
  
  def test_week_to_range
    assert_equal Date.new(2006,12,25) .. Date.new(2006,12,31),  week_to_range(2006,52)
    assert_equal Date.new(2006,12,25) .. Date.new(2006,12,31),  week_to_range(2006,53) # invalid 2007-W53
    
    assert_equal Date.new(2007,1,1) .. Date.new(2007,1,7),  week_to_range(2007,0) # invalid 2007-W0
    assert_equal Date.new(2007,1,1) .. Date.new(2007,1,7),  week_to_range(2007,1)
  end

end
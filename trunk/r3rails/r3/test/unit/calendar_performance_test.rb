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
# <@(#) $Id: calendar_performance_test.rb,v 1.1 2007/09/27 12:30:59 jury Exp $>
#
# 改定履歴
# 2007/09/15 (岡村 淳司) 新規作成 [S38] 性能試験
#
require File.dirname(__FILE__) + '/../test_helper'

class CalendarPerformanceTest < Test::Unit::TestCase
  fixtures :reservations, :calendars, :rooms
  
  def test_has_unit_by_month
    elapsedSeconds = Benchmark::realtime do
      Calendar.has_units_by_month?(1, 2007, 7)
    end
    assert elapsedSeconds <= 0.5, "realtime:#{elapsedSeconds}"  
  end
  
  def test_get_units
    elapsedSeconds = Benchmark::realtime do
      Calendar.get_units(:date => Date.new(2007,7,1), :room => 1)
    end
    assert elapsedSeconds <= 0.5, "realtime:#{elapsedSeconds}"  
  end
  
  def test_get_units_all
    elapsedSeconds = Benchmark::realtime do
      Calendar.get_units_all(:date => Date.new(2007,7,1))
    end
    assert elapsedSeconds <= 0.5, "realtime:#{elapsedSeconds}"  
  end
  
  def test_open_units_by_month
    elapsedSeconds = Benchmark::realtime do
      Calendar.open_units_by_month(1, 2007, 7)
    end
    assert elapsedSeconds <= 0.5, sprintf("realtime:%.2f",elapsedSeconds)
  end
  
  def test_delete_units_by_month
    elapsedSeconds = Benchmark::realtime do
      Calendar.delete_units_by_month(1, 2007, 7)
    end
    assert elapsedSeconds <= 0.5, printf("realtime:%.2f",elapsedSeconds)  
  end
  
end

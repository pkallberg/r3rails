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
# <@(#) $Id: calendar_helper.rb,v 1.2 2007/09/16 04:43:43 jury Exp $>
#
# 改定履歴
# 2007/09/15 (岡村 淳司) [S25] カレンダのクローズ
#
module Admin::CalendarHelper
  
  #
  # 月選択コンボボックス向けのコレクションを返します。
  #
  def month
    m = []
    1.upto(12) do |i|
      m << ["#{i}月", i]
    end
    m
  end

end

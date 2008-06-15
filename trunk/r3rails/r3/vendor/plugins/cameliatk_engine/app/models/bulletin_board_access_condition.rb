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
# <@(#) $Id: bulletin_board_access_condition.rb,v 1.1 2007/10/12 12:39:39 jury Exp $>
#
# 改定履歴
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#
class BulletinBoardAccessCondition < ActiveRecord::Base
  validates_presence_of :conditions, :message => "条件が指定されていません"

  belongs_to :bulletin_board
  
  def eval_access_conditions params = {}
    return true if conditions.nil? || conditions.empty?
    begin
      return instance_eval(conditions) == true
    rescue
      return false
    end
  end
  
end

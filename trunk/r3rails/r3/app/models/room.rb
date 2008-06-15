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
# <@(#) $Id: room.rb,v 1.3 2007/09/08 03:11:46 jury Exp $>
#
# 改定履歴
# 2007/09/08 (岡村 淳司) [S15] 会議室のプロパティ
# 2007/09/04 (岡村 淳司) [S11] 管理機能 Room
# 2007/08/10 (岡村 淳司) 新規作成
#
class Room < ActiveRecord::Base
  validates_presence_of :name, :message => "会議室名が指定されていません"
  validates_numericality_of :capacity, :message => "席数が数値ではありません", :only_integer => true

end

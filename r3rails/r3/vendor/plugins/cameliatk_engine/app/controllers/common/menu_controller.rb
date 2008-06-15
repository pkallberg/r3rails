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
# <@(#) $Id: menu_controller.rb,v 1.2 2007/10/02 13:54:40 jury Exp $>
#
# 改定履歴
# 2007/10/01 (岡村 淳司) [S47] 新規作成 メニュー機構
#
class Common::MenuController < ApplicationController
  before_filter :login_required
  layout nil
  
  def index
    rid = get_login_user_info()[:role_id]
    begin
      @role = Role.find(rid)
      @menus = @role.top_nodes
      rescue
    end
    @role ||= Role.new(:name => "(なし)")
  end
  
end

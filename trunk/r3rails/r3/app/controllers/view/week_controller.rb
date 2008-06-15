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
# <@(#) $Id: week_controller.rb,v 1.4 2007/10/16 13:40:55 jury Exp $>
#
# 改定履歴
# 2007/10/01 (岡村 淳司) [S47] 統合Plugin化 ロール、アクセス権
# 2007/09/24 (岡村 淳司) [S40] 統合Plugin化
# 2007/09/17 (岡村 淳司) [S14] Week View
#
class View::WeekController < ApplicationController
  before_filter :login_required
  before_filter :password_term_valid_if_login
  before_filter :privilege_required
  after_filter :display_stack_anchor, :only => "index"
  
  def index
    if params[:year].nil? || params[:year].empty? || params[:week_no].nil? || params[:year].empty?
      y,w = Date.today.to_week
      redirect_to :action => "index", :year => y , :week_no => w
      return      
    end
    
    @year, @week_no = week_in_year(params[:year], params[:week_no])
    range = week_to_range(@year, @week_no)
    
    @room = Room.find(1)
    @units_of_week = []
    @weeks = []
     (range).each do |d|
      @weeks << {:date => d, :all_units => Calendar.get_units_all(d)}
    end
  end
  
  def goto_by_date
    d = date_or_today(params[:date])
    
    y,w = d.to_week()
    redirect_to :action => "index", :year => y , :week_no => w
    return      
  end
  
end

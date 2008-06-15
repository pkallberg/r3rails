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
# <@(#) $Id: bulletin_board_controller.rb,v 1.2 2008/01/26 12:55:05 jury Exp $>
#
# 改定履歴
# 2007/10/23 (岡村 淳司) [S59] ファイルアップロード
# 2007/10/10 (岡村 淳司) [S36] 新規作成 フィードバック装置（掲示版）
#

class Common::BulletinBoardController < ApplicationController
  include Admin::BulletinBoardAttachDownloadMixin

  before_filter :login_required
  after_filter :display_stack_anchor, :only => "index"
  
  def index
    @bulletinboards = BulletinBoard.today(:user => User.find(get_login_user_id))
  end
  
  def today
    index
    render :action=>"index"
  end

  def get_attach_file
    bbaf = BulletinBoardAttachment.find(params[:id])
    bbaf.relative_path
    
    # TODO access logging
    send_file bbaf.relative_path, :filename=>bbaf.download_name
  end

end

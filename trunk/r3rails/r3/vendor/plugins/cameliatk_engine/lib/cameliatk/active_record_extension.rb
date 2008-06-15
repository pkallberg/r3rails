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
# <@(#) $Id: active_record_extension.rb,v 1.1 2007/10/11 16:06:15 jury Exp $>
#
# 改定履歴
# 2007/10/10 (岡村 淳司) [S36] フィードバック装置（掲示版） ActiveRecord拡張
#

module Cameliatk
  
  #
  # ActiveRecord拡張
  #
  module ActiveRecordExtension

    #
    # IDとlock_versionによるfind
    #
    def find_exclusive(args={})
      raise "argument failure" if args[:id].nil? || args[:lock_version].nil?
      rtn = self.find(:first, :conditions=>["id=? and lock_version=?",args[:id], args[:lock_version]])
      raise ActiveRecord::RecordNotFound.new("Couldn't find #{self.to_s} with id:?, lock_version:?".msg(args[:id],args[:lock_version])) if rtn.nil?
      rtn
    end
    
  end
  
end

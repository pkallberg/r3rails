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
# <@(#) $Id: test_helper.rb,v 1.2 2007/10/07 15:57:59 jury Exp $>
#
# 改定履歴
# 2007/09/24 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/24 (岡村 淳司) 新規作成 [S40] 統合Plugin化
#
require 'test/unit'
def __DIR__(*args) File.join(File.dirname(__FILE__), *args) end

# テスト用のDB環境は rails プロジェクト本体のものを使用する
ENV["RAILS_ENV"] = "test"
require __DIR__("../../../../config/environment")

# Framework系のライブラリのロード
if File.exists? __DIR__('../../../rails')
  $:.unshift __DIR__('../../../rails/activerecord/lib')
  $:.unshift __DIR__('../../../rails/activesupport/lib')
  $:.unshift __DIR__('../../../rails/actionpack/lib')
else
  require 'rubygems'
end
require 'active_support'
require 'action_pack'
require 'active_record'
require 'active_record/fixtures'

# スキーマ
load __DIR__("../../../../db/schema.rb")

# fixtureパス
Test::Unit::TestCase.fixture_path = __DIR__('../test/fixtures')
#Test::Unit::TestCase.fixture_path = __DIR__('fixtures') # Eclipse経由でやるなら
$:.unshift Test::Unit::TestCase.fixture_path

# テストロードパス
$:.unshift __DIR__('../lib')
$:.unshift __DIR__('../app/models')
$:.unshift __DIR__('../app/controllers')

# プラグイン環境のセットアップ
load __DIR__("../init.rb")

# 
class ApplicationController < ActionController::Base
end

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
# <@(#) $Id: user_test.rb,v 1.3 2007/09/30 05:32:32 jury Exp $>
#
# 改定履歴
# 2007/10/01 (岡村 淳司) [S49] 予約のメンテナンス に対応して
#                        Modelからの属性抽出機能として作詞絵
# 2007/10/01 (岡村 淳司) [S49] 予約のメンテナンス
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/04 (岡村 淳司) [S12] 管理機能 User
# 2007/08/22 (岡村 淳司) [S5] ユーザの予約登録機能
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_password
    user = User.find(1)
    user.password="atk4532"
    assert_not_nil user.password_hash
    assert_not_nil user.password_salt
  end
    
  def test_authenticate_fail
    assert_raise(Exception){
      user = User.authenticate("user1","user0")
    }
    begin
      user = User.authenticate("user1","user0")
      assert_nil user
    rescue Exception
      assert true
    end
  end
  
  def test_dont_authenticate_disabled_user
    assert_raise(Exception){
      user = User.authenticate("disabled","disabled")
    }
  end

  def test_admin_dont_delete
    user = users(:admin)
    assert_raise(Exception){
      user.destroy
    }
  end

  def test_validator_name
    user = users(:admin)
    user.name = nil
    assert_equal false, user.save
    assert_equal "名前が指定されていません", user.errors.on('name')
  end

  def test_validator_admin_update
    user = users(:admin)
    user.admin = false
    assert_equal false, user.save
    assert_equal "アカウント 'admin' の管理者権限を無効にできません", user.errors.on('admin')
  end

  def test_validator_enable_update
    user = users(:admin)
    user.enable = false
    assert_equal false, user.save
    assert_equal "アカウント 'admin' を無効にできません", user.errors.on('admin')
  end
  
  def test_update_password_term_valid
    u = User.find(1)
    assert_equal Date.today + 40, u.password_term_valid
    u.password='password'
    assert_equal Date.today + $LOGIN_PASSWORD_CONFIG[:valid_term], u.password_term_valid  
    
    assert_nothing_raised{u.save}
  end

  def test_lockout
    1.upto(5) do
      begin
        User.authenticate('user1','user0')
      rescue Exception
        assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
      end
    end
    begin
      User.authenticate('user1','user0')
    rescue Exception
      assert_equal $MESSAGES[:common][:locked], $!.to_s
    end
    
    1.upto(6) do
      begin
        User.authenticate('user1','user0')
      rescue Exception
        assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
      end
    end
    
    u = User.find(1);
    assert_equal 6, u.password_faults
  end
  
  def test_login_faults_and_success
    1.upto(4) do
      begin
        User.authenticate('user1','user0')
      rescue Exception
        assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
      end
    end
    
    u = User.authenticate('user1','user1')
    assert_equal 0,u.password_faults
  end

  def test_lockkout_faults_new_password
    1.upto(5) do
      begin
        User.authenticate('newpass','badpassword')
      rescue Exception
        assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
      end
    end
    begin
      User.authenticate('newpass','badpassword')
    rescue Exception
      assert_equal $MESSAGES[:common][:locked], $!.to_s
    end
    begin
      User.authenticate('newpass','badpassword')
    rescue Exception
      assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
    end
  end

  def test_expired_and_too_late_login
    begin
      User.authenticate('neglected','neglected')
    rescue Exception
      assert_equal $MESSAGES[:common][:login_invalid], $!.to_s
    end
    assert_equal false, User.find(users(:neglected).id).enable
  end
  
  def test_enable_users
    list = User.enable_users
    assert !list.nil?
    assert_equal 16, list.size
  end
end

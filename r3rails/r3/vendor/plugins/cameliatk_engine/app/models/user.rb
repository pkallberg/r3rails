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
# <@(#) $Id: user.rb,v 1.4 2007/10/01 13:00:03 jury Exp $>
#
# 改定履歴
# 2007/10/01 (岡村 淳司) [S49] 予約のメンテナンス に対応して
#                        Modelからの属性抽出機能として作詞絵
# 2007/09/27 (岡村 淳司) [S44] 統合Plugin化 2nd
# 2007/09/07 (岡村 淳司) [S13-3] 失効、無効 
# 2007/09/07 (岡村 淳司) [S13-2] ロックアウト
# 2007/09/04 (岡村 淳司) [S13] パスワード有効期限
# 2007/09/04 (岡村 淳司) [S12] 管理機能 User
# 2007/08/31 (岡村 淳司) [S1] ログイン機構
# 2007/08/22 (岡村 淳司) 新規作成 [S5] 予約編集機能
#
require 'digest/sha2'

class User < ActiveRecord::Base
  belongs_to :role
  
  validates_presence_of :name, :message => "名前が指定されていません"
  validates_presence_of :login_id, :message => "ログインIDが指定されていません"
  validates_uniqueness_of :login_id, :message => "ログインIDが重複しています"
  validate :dont_update_admin, :dont_update_enable
  
  before_destroy :dont_destroy_admin
  
  #
  # ユーザを認証します
  # @param loginid ログインID
  # @param pass パスワード
  #
  def self.authenticate(loginid, pass)
    user = User.find(:first, :conditions => ['login_id=? and enable = true', loginid])
    if user.blank?
      raise Exception, $MESSAGES[:common][:login_invalid]
    elsif Digest::SHA256.hexdigest(pass+user.password_salt) != user.password_hash
      user.password_faults += 1
      if user.password_faults > $LOGIN_PASSWORD_CONFIG[:max_faults]
        user.enable = false
        msg = $MESSAGES[:common][:locked]
      else
        msg = $MESSAGES[:common][:login_invalid]
      end
      user.save!
      raise Exception, msg
    elsif user.is_expired_completely?
      user.enable = false
      user.save!
      raise Exception, $MESSAGES[:common][:login_invalid]
    else
      user.password_faults = 0
      user.save!
    end
    user
  end
    
  def is_expired_completely?
    self.enable && (Date.today > self.password_term_valid + $LOGIN_PASSWORD_CONFIG[:abeyance_term])
  end
  
  def password=(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
    self.password_term_valid = Date.today + $LOGIN_PASSWORD_CONFIG[:valid_term]
  end
  
  def is_admin?
    return self.admin
  end
  
  def is_enable?
    return self.enable
  end
  
  def self.new_password
    [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end
  
  def dont_destroy_admin
    raise Exception, "アカウント 'admin' を削除することはできません" if self.login_id == 'admin'
  end

  def dont_update_admin
    errors.add('admin',"アカウント 'admin' の管理者権限を無効にできません") if self.login_id == 'admin' && !self.admin
  end

  def dont_update_enable
    errors.add('admin',"アカウント 'admin' を無効にできません") if self.login_id == 'admin' && !self.enable
  end

  def destroy_and_cancel_reservations
    self.transaction() do
      Reservation.find(:all, :conditions => ["user_id=?",self.id]).each do |rsv|
        rsv.cancel()
      end
      self.destroy
    end
  end
  
  def remained_days
    (self.password_term_valid - Date.today).to_i
  end
  
  def is_expired_warning?
    $LOGIN_PASSWORD_CONFIG[:expired_warning_term] >= self.remained_days() && self.remained_days() >= 0 
  end
  
  def is_expired?
    self.remained_days() < 0
  end
  
  def self.enable_users
    User.find(:all, :conditions => ["enable = true"])
  end
  
end
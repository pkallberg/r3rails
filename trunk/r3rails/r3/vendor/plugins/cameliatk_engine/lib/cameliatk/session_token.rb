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
# <@(#) $Id: session_token.rb,v 1.2 2007/10/19 15:19:14 jury Exp $>
#
# 改定履歴
# 2007/10/17 (岡村 淳司) [S51] Framework機能の拡充 2度押しガード(サーバサイド)
#
require 'digest/sha2'
require 'monitor'

module Cameliatk

  #
  # セッショントークン機能 Mixin
  #
  module SessionTokenMixin
    
    #
    # 現在のセッショントークンを取得します。
    #
    def reset_token
      return Cameliatk::SessionToken.reset_token(session)
    end
    
    #
    # セッショントークンの妥当性をチェックします。
    #
    def is_valid_token? token_string=nil
      token_string ||= request.parameters[:token_string]
      return Cameliatk::SessionToken.is_valid_token?(session, token_string)
    end
    
    #
    # セッショントークンの妥当性をチェックします。
    # 妥当でない場合例外をThrowします。
    #
    def assert_token token_string=nil
      token_string ||= request.parameters[:token_string]
      raise "Session Token is invalid." unless Cameliatk::SessionToken.is_valid_token?(session, token_string)
    end

    #
    # 現在のセッショントークンを取得します。
    #
    def get_token
      return Cameliatk::SessionToken.get_token(session)
    end
    
  end
  
  #
  # セッショントークン機能 Mixin
  #
  module SessionTokenHelperMixin

    #
    # セッショントークンを格納する hiddenタグを生成します。
    #
    def token_field_tag name, options
      hidden_field_tag name, get_token, options
    end

    #
    # 現在のセッショントークンを取得します。
    #
    def get_token
      return Cameliatk::SessionToken.get_token(session)
    end

  end
  
  #
  # セッショントークンを提供します。
  #
  class SessionToken
    @token_keys = ""
    @token = ""
    
    def initialize(key)
      @token_keys = key.to_s.dup
      super()
    end
    
    def token
      return @token.dup
    end
    
    def valid? token_string
      return @token == token_string
    end
    
    def reset
      @token = SessionToken.generate_token(@token_keys)
    end
    
    def self.generate_token key
      salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
      key_salt = DateTime.now.strftime('%H%M%S%s')
      Digest::SHA256.hexdigest(key + key_salt + salt)
    end
    
    #
    # Monitor(for Class)
    #
    @@lock = Monitor.new
    
    #
    # トークンの妥当性をチェックします。
    #
    def self.is_valid_token? sess, token_string
      return false if sess.nil?
      return false unless sess.respond_to?("[]")
      
      @@lock.synchronize do
        session_token = sess[$SESSION_KEYS[:session_token]]
        return false if session_token.nil?
        return session_token.valid?(token_string)
      end
    end
    
    #
    # トークンをリセットします。
    # トークンが準備されていない場合は準備してからリセットします。
    #
    def self.reset_token sess
      return nil if sess.nil?
      return nil unless sess.respond_to?("[]")
      
      @@lock.synchronize do
        session_token = sess[$SESSION_KEYS[:session_token]]
        key_name = sess.respond_to?("session_id") ? sess.session_id : "cameliaTk.jp"
        if session_token.nil?
          session_token = SessionToken.new(key_name)
          sess[$SESSION_KEYS[:session_token]] = session_token
        end
        return session_token.reset
      end
    end
    
    #
    # セッショントークンを返します。
    # 存在しない場合は Empty("") を返します。
    #
    def self.get_token sess
      @@lock.synchronize do
        session_token = sess[$SESSION_KEYS[:session_token]]
        return "" if session_token.nil?
        return session_token.token
      end
      ""
    end
    
  end    
end
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
# <@(#) $Id: password_util.rb,v 1.1 2007/10/16 13:31:52 jury Exp $>
#
# 改定履歴
# 2007/07/19 (岡村 淳司) [S51] Framework機能の拡充 パスワード要件
#

module Cameliatk
  
  #
  # パスワードユーティリティ
  #
  module Cameliatk::PasswordUtil
    
    def self.verify method_symbol, password, params={}
      raise ArgumentError.new("verify method is not symbol") if method_symbol.nil?
      raise ArgumentError.new("verify method is not symbol") unless method_symbol.is_a?(Symbol)

      raise ArgumentError.new("verify method parameter is nil") if params.nil?
      
      return false if password.nil?

      verify_results = true
      
      raise ArgumentError.new("method '#{method_symbol.to_s}' was not found") unless respond_to?(method_symbol.to_s)
      
      verify_results = self.module_eval("#{method_symbol.to_s}(password, params)")
      return verify_results
    end
    
    def self.length password, params={}
      return false if params[:size].nil?
      return false unless params[:size].is_a?(Fixnum)
      
      return password.to_s.size >= params[:size].to_i
    end
    
    #
    #
    #
    def self.exclude_words password, params={}
      return true if params[:words].nil?
      if params[:words].is_a?(Array)
        params[:words].each do |x|
          next if x.nil?
          return false if password.to_s.include?(x.to_s)
        end
        return true
      elsif params[:words].is_a?(String)
        return password != "" if params[:words] == ""
        return !password.to_s.include?(params[:words])        
      else
        return password != "" if params[:words].to_s == ""
        return !password.to_s.include?(params[:words].to_s)        
      end
    end
    
    #
    # 指定した正規
    #
    def self.include_regexp password, params={}
      return true if params[:regexp].nil?
      if params[:regexp].is_a?(Array)
        return true if params[:regexp].empty?
        params[:regexp].each do |x|
          raise ArgumentError.new("invalid Regexp") unless x.is_a?(Regexp)
          return false if (password =~ x).nil?
        end
        return true
      elsif params[:regexp].is_a?(Regexp)
        return !(password =~ params[:regexp]).nil?
      else
        raise ArgumentError.new("invalid Regexp")
      end
      return false
    end
    
    def self.succesive password, params={}
      size = 0
      if params[:size].nil?
        size = 3
      elsif params[:size].is_a?(Fixnum)
        size = params[:size].to_i
      else
        raise ArgumentError.new("invalid size")
      end
      raise ArgumentError.new("size is too short") if size < 2
      
      return !(password=~ /(.)\1{#{size-1},}/)
    end

  end
  
end

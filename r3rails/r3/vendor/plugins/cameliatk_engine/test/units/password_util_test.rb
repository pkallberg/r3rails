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
# <@(#) $Id: password_util_test.rb,v 1.1 2007/10/16 13:31:42 jury Exp $>
#
# 改定履歴
# 2007/07/19 (岡村 淳司) [S51] Framework機能の拡充 パスワード要件
#
require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

require 'cameliatk/password_util'

class PasswordUtilTest < Test::Unit::TestCase
  include Cameliatk::PasswordUtil
  
  def test_call_verify_method_nil
    assert_raise(ArgumentError){ Cameliatk::PasswordUtil.verify([], "abc", {:size=>8}) }
    assert_raise(ArgumentError){ Cameliatk::PasswordUtil.verify(nil, "abc", {:size=>8}) }
    assert_raise(ArgumentError){ Cameliatk::PasswordUtil.verify("length", "abc", {:size=>8}) }
  end
  
  def test_method_not_found
    assert_raise(ArgumentError){ Cameliatk::PasswordUtil.verify(:nothing, "abc", {:size=>8}) }
  end
  
  def test_method_parameter_not_found
    assert_nothing_raised{ Cameliatk::PasswordUtil.verify(:length, "abc") }
    assert_raise(ArgumentError){ Cameliatk::PasswordUtil.verify(:length, "abc", nil) }
  end
  
  def test_verify_length
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "abcdefghij")
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "abcdefghij", {})
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "abcdefghij", {:size=>nil})
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "abcdefghij", {:size=>"abc"})
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "abcd", {:size=>8})
    assert_equal true, Cameliatk::PasswordUtil.verify(:length, "abcdefghij", {:size=>8})
    assert_equal true, Cameliatk::PasswordUtil.verify(:length, "12345678", {:size=>8})
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, "1234567", {:size=>8})
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:length, 8, {:size=>8})
  end
  
  def test_verify_exclude_words
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, nil)
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "")
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, 12)
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij")
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij", {})
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij", {:words=>nil})
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij", {:words=>[]})
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij", {:words=>""})
    assert_equal true, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefghij", {:words=>{}})
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefs11ghij", {:words=>1})
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefs11ghij", {:words=>"abc"})
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdefs11ghij", {:words=>"efs"})
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdes1fghij", {:words=>["bcd",1,"ij"]})
    assert_equal false, Cameliatk::PasswordUtil.verify(:exclude_words, "abcdes1fghij", {:words=>["bcd",1,"xse"]})
  end
  
  def test_verify_include_regexp
    assert_equal false, Cameliatk::PasswordUtil.verify(:include_regexp, nil)
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "")
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, 12)
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, 12)
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "abcdefghij")
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD SWERWE 123", {:regexp=>nil})
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD SWERWE 123", {:regexp=>""})}
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD SWERWE 123", {:regexp=>[]})
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "abcdes1fghij", {:regexp=>/[a-z]+/})
    assert_equal false, Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD SWERWE 123", {:regexp=>/[a-z]+/})
    
    alp_s = /[a-z]/
    alp_l = /[A-Z]/
    num = /[0-9]/
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD avd fSWERWE 123", {:regexp=>[alp_s,alp_l,num]})
    assert_equal false, Cameliatk::PasswordUtil.verify(:include_regexp, "1321AVVD あいうWERWE 123", {:regexp=>[alp_s,alp_l,num]})
    
    assert_equal true,  Cameliatk::PasswordUtil.verify(:include_regexp, "Admin001", {:regexp=>[alp_s, alp_l, num]})
    assert_equal false, Cameliatk::PasswordUtil.verify(:include_regexp, "admin001", {:regexp=>[alp_s, alp_l, num]})
    assert_equal false, Cameliatk::PasswordUtil.verify(:include_regexp, "adminmin", {:regexp=>[alp_s, alp_l, num]})
    
  end
  
  def test_verify_succesive
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, nil)
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:succesive, "")
    assert_equal true, Cameliatk::PasswordUtil.verify(:succesive, 12)
    assert_equal true, Cameliatk::PasswordUtil.verify(:succesive, "abcdefghij")
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "aaabcdefghij") # a *3
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "b   cdefghij") # sp *3
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "b  111cdefghij") # 1 *3
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "b  11あああcdefghij") # あ *3
    
    assert_equal true, Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb bdefghij") 
    assert_equal true, Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij")
    
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb bdefghij", :size=>2) 
    assert_equal false, Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>2)
    
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>"")}
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>1.18)}
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>1)}
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>0)}
    assert_raise(ArgumentError){Cameliatk::PasswordUtil.verify(:succesive, "aabvcbb 121.11bdefghij", :size=>-12)}
  end
  
end
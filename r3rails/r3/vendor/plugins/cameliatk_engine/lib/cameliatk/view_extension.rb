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
# <@(#) $Id: view_extension.rb,v 1.2 2008/01/26 12:55:05 jury Exp $>
#
# 改定履歴
# 2007/10/12 (岡村 淳司) 新規作成 [S61] loading
#

module Cameliatk
  
  #
  # View拡張
  #
  module ViewExtension
    
    #
    # 単純日付タグオプション
    #
    def cameliatk_sdate_options(options={})
      tag_opts = {:size=>10, :maxlength=>10, :onclick=>"dateControlSingle(this);"}
      
      options.each_key do |x|
        if x == :onclick
          tag_opts[:onclick] = tag_opts[:onclick] + options[x]
        else
          tag_opts[x] = options[x]
        end
      end
      tag_opts
    end
    
    #
    # form with loading_splash 
    #
    def cameliatk_form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
      cameliatk_loading = options.delete(:cameliatk_loading)
      cameliatk_loading ||= true
      
      options[:cameliatk_loading] = cameliatk_loading
      form_tag(url_for_options, options, parameters_for_url, &block)
    end
    
    #
    # form-for with loading_splash 
    #
    def cameliatk_form_for(object_name, *args, &proc)
      if args.last.is_a?(Hash)
        unless args.last[:html].nil?
          if args.last[:html][:cameliatk_loading].nil?
            args.last[:html][:cameliatk_loading] = true
          end
        end
      end
      
      form_for(object_name, *args, &proc)
    end
    
    #
    # remote form-for with loading_splash 
    #
    def cameliatk_remote_form_for(object_name, *args, &proc)
      if args.last.is_a?(Hash)
        unless args.last[:html].nil?
          if args.last[:html][:cameliatk_loading].nil?
            args.last[:html][:cameliatk_loading] = true
          end
        end
      end
      
      remote_form_for(object_name, *args, &proc)
    end
    
    #
    # link with loading_splash 
    #
    def cameliatk_link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
      cameliatk_loading = html_options[:cameliatk_loading]
      cameliatk_loading ||= true
      
      html_options[:cameliatk_loading] = cameliatk_loading
      link_to(name, options, html_options, parameters_for_method_reference)
    end
    
    #
    # link-remote with loading_splash 
    #
    def cameliatk_link_to_remote(name, options = {}, html_options = {})
      cameliatk_loading =  html_options.delete(:cameliatk_loading)
      cameliatk_loading ||= true
          
      splash = Cameliatk::ViewExtensionUtil.loading_splash_javascript_function(cameliatk_loading)
      if args[:before].nil?
        args[:before] = splash
      else
        args[:before] = args[:before] + splash
      end
      
      link_to_remote(name, options, html_options)
    end
    
  end
  
  module ViewExtensionUtil
    #
    # javascript for loading-splash
    #
    def self.loading_splash_javascript_function(opt_value)
      return "" if opt_value.nil?
      if opt_value == true
        "$('#{$VIEW_COMPONENT_OPTIONS[:loading_splash_id]}').show();"
      else
        ""
      end
    end  end
end

#
# re-define for link_to
#
module ActionView::Helpers::UrlHelper
  
  def convert_options_to_javascript!(html_options)
    confirm, popup = html_options.delete("confirm"), html_options.delete("popup")
    
    splash = Cameliatk::ViewExtensionUtil.loading_splash_javascript_function(html_options.delete("cameliatk_loading"))
    
    # post is deprecated, but if its specified and method is not, assume that method = :post
    method, post   = html_options.delete("method"), html_options.delete("post")
    if !method && post
      ActiveSupport::Deprecation.warn(
        "Passing :post as a link modifier is deprecated. " +
        "Use :method => \"post\" instead. :post will be removed in Rails 2.0."
      )
      method = :post
    end
    
    html_options["onclick"] = case
    when popup && method
      raise ActionView::ActionViewError, "You can't use :popup and :post in the same link"
    when confirm && popup
              "if (#{confirm_javascript_function(confirm)}) { #{popup_javascript_function(popup)} };return false;"
    when confirm && method
              "if (#{confirm_javascript_function(confirm)}) { #{splash} #{method_javascript_function(method)} };return false;"
    when confirm
              "if (#{confirm_javascript_function(confirm)}) {#{splash} return true;}else{return false};"
    when method
              "#{splash} #{method_javascript_function(method)}return false;"
    when popup
      popup_javascript_function(popup) + 'return false;'
    else
      if html_options["onclick"].nil?
        if splash.blank?
          html_options["onclick"]
        else
          splash
        end
      else
        splash + html_options["onclick"]
      end
    end
  end
  
end    

#
# re-define for form_tag, form_for, remote_form_for
#
module ActionView::Helpers::TagHelper
  def tag(name, options = nil, open = false)
    html_options = options.stringify_keys
    if options
      splash = Cameliatk::ViewExtensionUtil.loading_splash_javascript_function(html_options.delete("cameliatk_loading"))
      unless splash.blank?
        if html_options["onsubmit"].nil?
          html_options["onsubmit"] = splash
        else
          html_options["onsubmit"] = splash + html_options["onsubmit"]
        end
      end
    end
    "<#{name}#{tag_options(html_options) if html_options}" + (open ? ">" : " />")
  end
end

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
# <@(#) $Id: role_helper.rb,v 1.1 2007/10/07 15:57:19 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [S53] 新規作成 ロールメンテナンス
#
module Admin::RoleHelper
  
  def privileges_tree privileges=[], selected_id_list=[], editable=false
    tags = ""
    privileges.each do |priv|
      tag, children = get_node(priv, selected_id_list, [], editable)
      tags << "#{tag}\n"
    end
    tags
  end
  
  def privilege_tree_helper_script
    tag = ""
    tag << "<script type=\"text/javascript\">\n"
    tag << "function doChecked(list) {\n"
    tag << "  for(var i=0; i < list.length; i++) {\n"
    tag << "    $(list[i]).checked = true;\n"
    tag << "  }\n"
    tag << "}\n"
    tag << "function doUnChecked(list) {\n"
    tag << "  for(var i=0; i < list.length; i++) {\n"
    tag << "    $(list[i]).checked = false;\n"
    tag << "  }\n"
    tag << "}\n"
    tag << "</script>\n"
  end
  
  def get_node priv, selected_id_list=[], parent_list = [], editable=false
    tag = ""
    children_tag = ""
    children_list = []
    
    return tag, children_list if selected_id_list.index(priv.id).nil? && !editable
    
    tag << "<li>" # start of this node
    
    unless priv.children.empty?
      children_tag << "<ul class=\"priveleges\">"
      priv.children.each do |child_node|
        children_list << child_node.id
        child_tag, child_ids = get_node(child_node, selected_id_list, parent_list.dup << priv.id, editable)
        children_tag << child_tag
        children_list.concat child_ids
      end
      children_tag << "</ul>"
    end
  
    tag << input_tag_for_checkbox(priv.id, !selected_id_list.index(priv.id).nil?,parent_list,children_list) if editable
    tag << priv.name
    tag << children_tag
    tag << "</li>" # end of this node
    
    return tag, children_list
  end
  
  def input_tag_for_checkbox id, checked, parent_list = [], children_list = []
    input_tag = "<input type=\"checkbox\" id=\"privileges_tree_?\" name=\"privileges[privilege_?]\" value=\"?\"".msg(id,id,id)
    input_tag << " checked" if checked

    input_tag << " onclick=\""
    unless parent_list.empty?
      input_tag << "if(this.checked){doChecked(["
      input_tag << parent_list.collect{|x| "'privileges_tree_#{x}'"}.join(',')
      input_tag << "]);}"
    end
    unless children_list.empty?
      input_tag << "if(!this.checked){doUnChecked(["
      input_tag << children_list.collect{|x| "'privileges_tree_#{x}'"}.join(',')
      input_tag << "]);}"
    end
    input_tag << "\"" # end of onclick

    input_tag << ">"
    input_tag << "</input>"
    input_tag
  end
  
end

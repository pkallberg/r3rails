/*
 * Copyright @year@ @owner@
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * $Id: cameliatk.jp.menu.js,v 1.3 2007/10/19 14:08:28 jury Exp $
 * <@(#) $RCSfile: cameliatk.jp.menu.js,v $ $Revision: 1.3 $>
 * 
 * 更新履歴
 * 2007/10/19 (岡村 淳司) [S51] 新規作成 Framework機能拡充 2度押しガード
 * 2007/10/01 (岡村 淳司) [S47] 新規作成 cameliaTk.jp(java)より移植
 */

/*********************************************************************
 * Config
 *********************************************************************/
var webFXTreeConfig = {
	itemIcon        : '/plugin_assets/cameliatk_engine/images/item.png',
	midasiIcon      : '/plugin_assets/cameliatk_engine/images/midasi.png',
	defaultAction   : 'javascript:void(0);'
};

/*********************************************************************
 * Handler
 *********************************************************************/
var webFXTreeHandler = {
	all       : {},
	idCounter : 0,
	idPrefix  : "web-menu-object-",
	idMenu    : "-tree",
	getId     : function() { 
					return this.idPrefix + this.idCounter++; 
				},
	select    : function (oItem) { 
					this.all[oItem.id].doSelect();
				},
	setLocation     :	function (oItem, location) { 
					return this.all[oItem.id].doSetLocation(location);
				}

};

/*********************************************************************
 * WebFXTreeAbstractNode class
 *********************************************************************/
function WebFXTreeAbstractNode(sId, sText, sAction) {
	this.childNodes  = [];
	this.id     = sId;
	this.text   = sText || webFXTreeConfig.defaultText;
	this.action = sAction || webFXTreeConfig.defaultAction;
	this.lnk = (sAction ? true : false);
	webFXTreeHandler.all[this.id] = this;
}

// ノード追加
WebFXTreeAbstractNode.prototype.add = function (node) {
	node.parentNode = this;
	if (node.lnk) {
		node.lvl = this.lvl;
	} else {
		node.lvl = this.lvl + 1;
	}
	this.childNodes[this.childNodes.length] = node;
	return node;
}

// メニュー選択（オープン／クローズ）
WebFXTreeAbstractNode.prototype.doSelect = function() {
	var vType = ["none","block"];
	var tMenu = document.getElementById(this.id + webFXTreeHandler.idMenu).style;
	tMenu.display = vType[tMenu.display.indexOf("none") + 1];
}


/*********************************************************************
 * WebFXTree class
 *********************************************************************/
function WebFXTree(sId, sText, sAction) {
	this.base = WebFXTreeAbstractNode;
	this.base(sId, sText, sAction);
	this.lvl = 1;
}

// base class
WebFXTree.prototype = new WebFXTreeAbstractNode;

// docment文字列
WebFXTree.prototype.toString = function() {
	var str = "<div id=\"" + this.id + "\" onclick=\"webFXTreeHandler.select(this);\">"
			+ "<p class=\"level" + this.lvl + "\">"
			+ "<a href=\"" + webFXTreeConfig.defaultAction + "\" >" + this.text + "</a>"
			+ "</p>"
			+ "</div>"
			+ "<div id=\"" + this.id + webFXTreeHandler.idMenu + "\" style=\"display: none;\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	
	return str + sb.join("") + "</div>";
};

/*********************************************************************
 * WebFXTreeItem class
 *********************************************************************/
function WebFXTreeItem(sId, sText, sAction) {
	this.base = WebFXTreeAbstractNode;
	this.base(sId, sText, sAction);
}

// base class
WebFXTreeItem.prototype = new WebFXTreeAbstractNode;

// docment文字列
WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	var str = "";
	if (this.lnk) {
		str = "<p class=\"item" + this.lvl + "\">"
			+ "<span class=\"columnLeftItem" + this.lvl + "\">"
		    + "<img src=\"" + webFXTreeConfig.itemIcon + "\"/>"
		    + "</span>"
		    + "<span class=\"columnRightItem" + this.lvl + "\">"
			+ "<a id=\"" + this.id + "\""
			+ " onclick=\"return webFXTreeHandler.setLocation(this, '" + this.action + "');\""
			+ " onmouseover=\"processMouseEvent(this, true, '" + this.action + "');\""
			+ " onmouseout=\"processMouseEvent(this, false);\""
			+ ">" + label + "</a>"
			+ "</span>"
			+ "</p>"
			return str;
	} else {
		str = "<p class=\"level" + this.lvl + "\">"
			+ "<span class=\"columnLeftLevel" + this.lvl + "\">"
		    + "<img src=\"" + webFXTreeConfig.midasiIcon + "\"/>"
		    + "</span>"
		    + "<span class=\"columnRightLevel" + this.lvl + "\">"		    
			+ "<a id=\"" + this.id + "\" href=\"" + webFXTreeConfig.defaultAction + "\""
			+ " onclick=\"webFXTreeHandler.select(this);\">" + this.text + "</a>"
			+ "</span>"
			+ "</p>"
			+ "<div id=\"" + this.id + webFXTreeHandler.idMenu + "\" style=\"display: none;\">";
		var sb = [];
		for (var i = 0; i < this.childNodes.length; i++) {
			sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
		}
		return str + sb.join("") + "</div>";
	}
}

// リンク前チェック
WebFXTreeItem.prototype.doSetLocation = function (location) {
	try {
		if (parent.frames[this.target].document.getElementById('loading').style.display == "") {
			alert('処理中です。\nしばらくお待ちください。');
			return false;
		}else{
			parent.frames[this.target].document.getElementById('loading').style.display = "";
			parent.frames[this.target].location = location;
			parent.frames[this.target].processing = true;
			return true;
		}
	} catch (e) {
		return false;
	}
}

// マウスのイベント処理
var previousStatus = '';
var debugMode = false;
function processMouseEvent(target, active, location) {
	if(active) {
		if(debugMode) {
			previousStatut = top.status;
			top.status = location;
		}
		target.style.textDecoration = 'underline';
		target.style.backgroundColor = '#c5e1ed';
	} else {
		if(debugMode) {
			top.status = previousStatus;
		}
		target.style.textDecoration = 'none';
		target.style.backgroundColor = '#FFFFFF';
	}
}


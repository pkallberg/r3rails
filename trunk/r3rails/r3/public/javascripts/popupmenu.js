/*
 * popupmenu.js - simple JavaScript popup menu library.
 *
 * Copyright (C) 2007 Jiro Nishiguchi <jiro@cpan.org> All rights reserved.
 * This is free software with ABSOLUTELY NO WARRANTY.
 *
 * You can redistribute it and/or modify it under the modified BSD license.
 *
 *  Usage:
 *    var popup = new PopupMenu();
 *    popup.add(menuText, function(target){ ... });
 *    popup.addSeparator();
 *    popup.bind('targetElement');
 *    popup.bind(); // target is document;
 *    
 * <@(#) $Id: popupmenu.js,v 1.5 2007/10/02 13:56:01 jury Exp $>
 *
 * 改定履歴
 * 2007/10/01 (岡村 淳司) [故障] ポップアップメニュー表示
 * 2007/09/16 (岡村 淳司) [故障] 右クリックメニューの書式
 * 2007/08/29 (岡村 淳司) [S5] 予約編集機能
 * 2007/08/19 (岡村 淳司) [S4] day_view 特定日付対応
 * 2007/08/19 (岡村 淳司) [S3] 右クリックメニュー表示時の右クリック制御の調整
 * 2007/08/16 (岡村 淳司) 新規作成
 */
var PopupMenu = function() {
    this.init();
}
PopupMenu.SEPARATOR = 'PopupMenu.SEPARATOR';
PopupMenu.current = null;
PopupMenu.addEventListener = function(element, name, observer, capture) {
    if (typeof element == 'string') {
        element = document.getElementById(element);
    }
    if (element.addEventListener) {
        element.addEventListener(name, observer, capture);
    } else if (element.attachEvent) {
        element.attachEvent('on' + name, observer);
    }
};
PopupMenu.prototype = {
    init: function() {
        this.items  = [];
        this.width  = 0;
        this.height = 0;
    },
    setSize: function(width, height) {
        this.width  = width;
        this.height = height;
        if (this.element) {
            var self = this;
            with (this.element.style) {
                if (self.width)  width  = self.width  + 'px';
                if (self.height) height = self.height + 'px';
            }
        }
    },
    bind: function(element) {
        var self = this;
        if (!element) {
            element = document;
        } else if (typeof element == 'string') {
            element = document.getElementById(element);
        }
        this.target = element;
        this.target.oncontextmenu = function(e) {
            self.show.call(self, e);
            return false;
        };
        var listener = function() { self.hide.call(self) };
        PopupMenu.addEventListener(document, 'click', listener, true);
    },
    bind_by_condition: function(element) {
        var self = this;
        if (!element) {
            element = document;
        } else if (typeof element == 'string') {
            element = document.getElementById(element);
        }
        this.target = element;
        this.target.oncontextmenu = function(e) {
			self.hide.call(self,e);
            return true;
        };
        var listener = function() { self.hide.call(self);return true; };
        PopupMenu.addEventListener(document, 'click', listener, true);
    },
    add: function(text, callback) {
        this.items.push({ text: text, callback: callback });
    },
	resetItems: function() {
		this.items.clear();
	},
    addSeparator: function() {
        this.items.push(PopupMenu.SEPARATOR);
    },
    setPos: function(e) {
        if (!this.element) return;
        if (!e) e = window.event;
        var x, y;
        if (window.opera) {
            x = e.clientX;
            y = e.clientY;
        } else if (document.all) {
            x = document.body.scrollLeft + event.clientX;
            y = document.body.scrollTop + event.clientY;
        } else if (document.layers || document.getElementById) {
            x = e.pageX;
            y = e.pageY;
        }
        this.element.style.top  = y + 'px';
        this.element.style.left = x + 'px';
    },
    show: function(e) {
        if (PopupMenu.current && PopupMenu.current != this) return;
        PopupMenu.current = this;
        if (this.element) {
            this.setPos(e);
            this.element.style.display = '';
        } else {
            this.element = this.createMenu(this.items);
            this.setPos(e);
            document.body.appendChild(this.element);
        }
    },
    show_by_condition: function(e, condition) {
        if (PopupMenu.current && PopupMenu.current != this) return;
        PopupMenu.current = this;
        if (this.element) {
	        document.body.removeChild(this.element);
        }
        this.element = this.createMenu_by_condition(this.items, condition);
        this.setPos(e);
        document.body.appendChild(this.element);
    },
	hide: function() {
        PopupMenu.current = null;
        if (this.element) this.element.style.display = 'none';
    },
    createMenu: function(items) {
        var self = this;
        var menu = document.createElement('div');
        with (menu.style) {
            if (self.width)  width  = self.width  + 'px';
            if (self.height) height = self.height + 'px';
            border     = "1px solid gray";
            background = '#FFFFFF';
            color      = '#000000';
            position   = 'absolute';
            display    = 'block';
            padding    = '2px';
            cursor     = 'default';
        }
        for (var i = 0; i < items.length; i++) {
            var item;
            if (items[i] == PopupMenu.SEPARATOR) {
                item = this.createSeparator();
            } else {
                item = this.createItem(items[i]);
            }
            menu.appendChild(item);
        }
        return menu;
    },
    createMenu_by_condition: function(items, condition) {
        var self = this;
        var menu = document.createElement('div');
        with (menu.style) {
            if (self.width)  width  = self.width  + 'px';
            if (self.height) height = self.height + 'px';
            border     = "1px solid gray";
            background = '#FFFFFF';
            color      = '#000000';
            position   = 'absolute';
            display    = 'block';
            padding    = '2px';
            cursor     = 'default';
			textAlign      = 'left'
        }
        for (var i = 0; i < items.length; i++) {
            var item;
            if (items[i] == PopupMenu.SEPARATOR) {
                item = this.createSeparator();
            } else {
				if (i < condition.length) {
					if (condition[i]) {
		                item = this.createItem(items[i]);
					} else {
		                item = this.createDisabledItem(items[i]);
					}
				} else {
	                item = this.createItem(items[i]);
				}
            }
            menu.appendChild(item);
        }
        return menu;
    },
	createItem: function(item) {
        var self = this;
        var elem = document.createElement('div');
        elem.style.padding = '4px';
        var callback = item.callback;
        PopupMenu.addEventListener(elem, 'click', function(_callback) {
            return function() {
                self.hide();
                _callback(self.target);
            };
        }(callback), true);
        PopupMenu.addEventListener(elem, 'mouseover', function(e) {
            elem.style.background = '#B6BDD2';
        }, true);
        PopupMenu.addEventListener(elem, 'mouseout', function(e) {
            elem.style.background = '#FFFFFF';
        }, true);
        elem.appendChild(document.createTextNode(item.text));
        return elem;
    },
	createDisabledItem: function(item) {
        var self = this;
        var elem = document.createElement('div');
        elem.style.padding = '4px';
        elem.style.color = '#DCDCDC';
        var callback = item.callback;
        PopupMenu.addEventListener(elem, 'mouseover', function(e) {
            elem.style.background = '#B6BDD2';
        }, true);
        PopupMenu.addEventListener(elem, 'mouseout', function(e) {
            elem.style.background = '#FFFFFF';
        }, true);
        elem.appendChild(document.createTextNode(item.text));
        return elem;
    },
    createSeparator: function() {
        var sep = document.createElement('div');
        with (sep.style) {
            borderTop = '1px dotted #CCCCCC';
            fontSize  = '0px';
            height    = '0px';
        }
        return sep;
    }
};


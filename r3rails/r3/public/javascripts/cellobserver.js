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
 * <@(#) $Id: cellobserver.js,v 1.5 2007/08/31 11:23:29 jury Exp $>
 *
 * 改定履歴
 * 2007/08/30 (岡村 淳司) [S5-4] 新規予約
 * 2007/08/22 (岡村 淳司) リファクタリング prototype.js対応
 * 2007/08/19 (岡村 淳司) [S4] day_view 特定日付対応
 * 2007/08/19 (岡村 淳司) [S3] [S3] 予約情報の詳細
 * 2007/08/16 (岡村 淳司) 新規作成
 */

/**
 * このクラスは、特定の親要素配下の子要素に対するクリックイベント監視のオブザーバを提供します。
 */
function CellObserver() {
	this.initialize.apply(this, arguments);
}
CellObserver.prototype = {
	initialize : function(id, _mode) {
		this.target_id = id;
		this.selectedCells = $H({});
		this.left_excludes = $H({});
		this.right_excludes = $H({});
		this.context_menu = null;
		this.bind_list = new $H({});
		this.mode = _mode;
	},
	getId : function() {
		return this.target_id;
	},
	consolelog : function(tag, text) {
		me = this;
		if( this.mode != "" ) {
			CellObserver.console(me.target_id + "(" + me.mode + ")", tag, text);
		}else{
			CellObserver.console(me.target_id, tag, text);
		}
	},
	hashdump : function(tag, aHash) {
		me = this;
		CellObserver.dump(me.target_id , tag , aHash);
	},
	initSelected : function () {
		me = this;
		this.selectedCells.each(function(x) {
			me.unSelected(x.key);
		});
		this.hashdump("initSelected", me.selectedCells);
	},
	bind : function(id) {
		this.consolelog("bind",id);
		this.bind_list[id] = id;
	},
	isBind : function(id) {
		return (bind_list[id] != null);
	},
	reset : function () {
		me = this;
		me.initSelected();
		me.bind_list = $H({});
		me.left_excludes = $H({});
	},
	selected : function(id) {
		this.selectedCells[id]= $(id).getAttribute('x-unitid');
		CellObserver._doSelectEvent(id);
	},
	unSelected : function(id) {
		this.selectedCells.remove(id);
		CellObserver._doUnSelectEvent(id);
	},
	isSelected : function(id) {
		me = this;
		rtn = (me.selectedCells[id] != null || me.selectedCells[id] != undefined );
		return rtn;
	},
	hasSelected : function() {
		this.consolelog("hasSelected", this.selectedCells.size())
		return (this.selectedCells.size() > 0);
	},
	capture_click : function(me, e) {
		if (this.mode != 'single') {
			$('reservation_edit_box').hide();
		}
		
		e = window.event;
		var elsrc = e.srcElement ? e.srcElement.id : "";
		if (e.button == 1) {
			me.consolelog("#capture_click()","left-click to " + elsrc);
			me.capture_click_left(e);
			return true;
		} else if (e.button == 2) {
			me.consolelog("#capture_click()","right-click to " + elsrc);
			me.capture_click_right(e);
			return true;
		}

		return true;
	},
	capture_click_left : function (e) {
		var elsrc = e.srcElement ? e.srcElement.id : "";
		if (this.left_excludes[elsrc] != null) {
			this.consolelog("#capture_click()","return exclude");
			return true;
		}
		
		if (elsrc == "" || elsrc == this.target_id) {
			if (!e.ctrlKey) {
				this.initSelected();
			}
			return true;
		}

		if (this.isSelected(elsrc)) {
			this.consolelog("#capture_click()","already selected. cansel selection " + elsrc);
			this.unSelected(elsrc);
			return true;
		}
		
		if (! e.ctrlKey) {
			if (this.mode != 'single') {
				// Ctrl + Clickによる選択追加を望むなら・・・
				// this.consolelog("#capture_click()","new click");
				// this.initSelected();
			}
		}
		
		if (this.mode != 'single') {
			CellObserver.initSelectedOther(this);
		}
		
		this.selected(elsrc);
	},
	capture_click_right : function (e) {
		if(this.context_menu == null) {
			return true;
		}
		
		this.context_menu.hide();

		var elsrc = e.srcElement ? e.srcElement.id : "";
		if (elsrc == "" || elsrc == null) {
			this.context_menu.show_by_condition(null, new Array(false, true, true));
			return true;
		}

		var node = $(elsrc);
		
		if (elsrc != "" || elsrc != null) {
			if (node == null) {
				return true;
			}
		}else{
			return true;
		}

		new Effect.Pulsate(elsrc);

		var obsname = this.target_id;
		var date = node.getAttribute("x-date");
		var room = node.getAttribute("x-roomid");
		var res = node.getAttribute("x-reservationid");
		var self = this;
		if (this.context_menu != null) {
			if(this.isSelected(elsrc)) {
				//空き時間帯選択時のコンテキストメニュー
				this.consolelog("capture_click_right", "show selected vacant unit");
				this.context_menu.resetItems();
				this.context_menu.add("予約する...", 
					function(target){
						$('loading').show();
						q = CellObserver.getSelectedCells(obsname).values().join('$');
						new Ajax.Request('/view/reservation/new_entry', 
							{	asynchronous:true,
								evalScripts:true,
								postBody: "date=" + date + "&room_id=" + room + "&selected_units=" + q
							});
					});
				this.context_menu.add("キャンセルする", function(target){} );
				this.context_menu.add("詳細...", function(target){} );
				this.context_menu.show_by_condition(null, new Array(true, false, false));
			} else if (res != "") {
				if (this.hasSelected()) {
					this.initSelected();
				}
				//予約済み時間帯選択時のコンテキストメニュー
				this.consolelog("capture_click_right", "show reservated unit");
				this.context_menu.resetItems();
				this.context_menu.add("予約する...", function(target){	} );
				this.context_menu.add("キャンセルする",
					function(target){
						if(confirm("予約をキャンセルします。よろしいですか？")) {
							$('loading').show();
							new Ajax.Request('/view/reservation/cancel/' + res,	{asynchronous:true,	evalScripts:true});
						}
					} );
				this.context_menu.add("詳細...",
					function(target){
						$('loading').show();
						new Ajax.Request('/view/reservation/get/' + res, {asynchronous:true, evalScripts:true});
					} );
				this.context_menu.show_by_condition(null, new Array(false, false, true));
			}
		}
		return true;
	},
	regist_left_exclude : function(id) {
		if (id != null && id != "") {
			this.left_excludes[id] = id;
			this.hashdump("exclude", this.left_excludes);
		}
	},
	regist_context_menu : function(_menu) {
		if (_menu != null) {
			this.context_menu = _menu;
		}
	}
}

/**
 * ダンプ出力コンソールの要素IDのデフォルト値。
 */
CellObserver.consolelogId = "console";
/**
 * ダンプを出力します。
 * @param {Object} tag tag
 * @param {Object} str message
 */
CellObserver.console = function(owner, tag, message) {
	var screen = $(CellObserver.consolelogId);
	if (screen != null) {
		doc = screen.innerHTML;
		doc = "[" + owner + "][" + tag + "]" + message + "<br />" + doc;
		screen.innerHTML = doc;
	}
}

/**
 * ダンプ出力コンソールの要素IDのデフォルト値。
 */
CellObserver.dumpId = "dump";
/**
 * ダンプを出力します。
 * @param {Object} tag tag
 * @param {Object} str message
 */
CellObserver.dump = function(tag, target) {
	var screen = $(CellObserver.dumpId);
	if (screen != null) {
		doc = screen.innerHTML;
		data = target.inspect();

		doc = "[" + tag + "] " + data.escapeHTML() + "<br />" + doc;
		screen.innerHTML = doc;
	}
}

/**
 * オブザーバリスト
 */
CellObserver.watchlist = new Hash();

/**
 * 指定したオブザーバが選択領域を持つかどうかを判定します。
 * @param {String} observer_name オブザーバ名
 */
CellObserver.hasSelectedCells = function(observer_name) {
	var obs = CellObserver.watchlist[observer_name];

	if (obs != null) {
		var i = 0
		for(x in obs.selectedCells) {
			i= i + 1;
		}
		return (i > 0)
	}
	return false;
}

/**
 * 指定したオブザーバの選択領域をハッシュで返します。
 * @param {String} observer_name オブザーバ名
 */
CellObserver.getSelectedCells = function(observer_name) {
	var cells = $H({});
	
	var obs = CellObserver.watchlist[observer_name];
	if (obs != null) {
		return obs.selectedCells;
	}
	return cells;
}

/**
 * 単独のクリック監視オブザーバを作成します。
 * @param {String} target オブザーバ名
 */
CellObserver.registSingleMode = function(observer_name) {
	var observer = new CellObserver(observer_name, 'single');
	CellObserver.watchlist[observer_name] = observer;
	return observer;
}

/**
 * クリック監視オブザーバを作成します。
 * @param {String} target オブザーバ名
 */
CellObserver.regist = function(observer_name) {
	var observer = new CellObserver(observer_name);
	CellObserver.watchlist[observer_name] = observer;
	return observer;
}

/**
 * クリック監視オブザーバを再起動します。
 * @param {String} target オブザーバ名
 */
CellObserver.restart = function(observer_name) {
	var observer = CellObserver.watchlist[observer_name];
	if (observer != null) {
		observer.reset();
	}
}

/**
 * イベントリスナーを登録します。
 * @param {Object} element ターゲットオブジェクト
 * @param {Object} name イベント名
 * @param {Object} observer オブザーバ
 * @param {Object} capture 監視を開始するか否か
 */
CellObserver.addEventListener = function(element, name, observer, capture) {
    element = $(element);
        element.attachEvent('on' + name, observer);
}

/**
 * イベントリスナーを解除します。
 * @param {Object} element ターゲットオブジェクト
 * @param {Object} name イベント名
 * @param {Object} observer オブザーバ
 * @param {Object} capture 監視を開始するか否か
 */
CellObserver.removeEventListener = function(element, name, observer, capture) {
    element = $(element);
        element.detachEvent ('on' + name, observer);
}

/**
 * クリック監視を開始します。
 * @param {String} observer_name オブザーバ名
 * @param {String} target 監視対象要素ID
 */
CellObserver.bindTarget = function(observer_name, target) {
	var observer = CellObserver.watchlist[observer_name];
	if (observer != null) {
		observer.bind(target);

		element = $(target);
		Event.observe(
			element,
			'mousedown',
			function () { observer.capture_click(observer); }
		);
		Event.observe(
			element,
			'contextmenu',
			function() { 
				window.event.cancelBubble = true;
				window.event.returnValue = false;
  				return true;
			}
		);
	}
}

/**
 * 対象の選択操作を強制的に行います。
 * @param {String} observer_name オブザーバ名
 * @param {String} target 監視対象要素ID
 */
CellObserver.selectTarget = function(observer_name, target) {
	var observer = CellObserver.watchlist[observer_name];
	if (observer != null) {
		observer.selected(target);
	}
}

/**
 * クリック監視の除外要素IDを登録します。
 * @param {String} observer_name オブザーバ名
 * @param {String} id 除外ID
 */
CellObserver.setExcludeOnLeft = function(observer_name, id) {
	var observer = CellObserver.watchlist[observer_name];
	if (observer != null) {
		observer.regist_left_exclude(id);
	}
}

/**
 * クリック監視の除外要素IDを登録します。
 * @param {String} observer_name オブザーバ名
 * @param {Popupmenu} _menu popupmenu.jsにて提供されるPopupmenuクラスのインスタンス
 */
CellObserver.setContextMenu = function(observer_name, _menu) {
	var observer = CellObserver.watchlist[observer_name];
	if (observer != null) {
		observer.regist_context_menu(_menu);
	}
}

/**
 * 選択された要素の背景色のデフォルト値。
 */
CellObserver.selectedColor = "red";
/**
 * 要素選択時のデフォルトの動作で、デフォルトの背景色をセットします。
 * @param {String} id 選択された要素のID
 */
CellObserver._doSelectEvent = function(id) {
	var el = $(id);
	if (el != null) {
		el.style.backgroundColor = CellObserver.selectedColor;
	}
}

/**
 * 選択解除された要素の背景色のデフォルト値。
 */
CellObserver.unSelectedColor = "white";
/**
 * 要素選択解除時のデフォルトの動作で、デフォルトの背景色をセットします。
 * @param {String} id 選択された要素のID
 */
CellObserver._doUnSelectEvent = function(id) {
	var el = $(id);
	if (el != null) {
		el.style.backgroundColor = CellObserver.unSelectedColor;
	}
}

/**
 * オブザーバを返します。
 * @param {String} observer_name オブザーバ名
 */
CellObserver.get = function(observer_name) {
	return CellObserver.watchlist[observer_name];
}

/**
 * 自分以外のオブザーバの選択を解除させます。
 * @param {String} observer_name オブザーバ名
 */
CellObserver.initSelectedOther = function(me) {
	CellObserver.watchlist.each(function(x){
		if (x.value != me && x.value.mode != 'single') {
			x.value.initSelected();
		}	
	});
}

/**
 * デバッグツール オブザーバ登録状況
 * @param {String} observer_name オブザーバ名
 */
CellObserver.dump_observer_all = function(me) {
	CellObserver.dump("All", CellObserver.watchlist);
}

/**
 * デバッグツール オブザーババインディング状況
 * @param {String} observer_name オブザーバ名
 */
CellObserver.dump_observer_binding = function(observer_name) {
	CellObserver.dump(observer_name + " binding", CellObserver.get(observer_name).bind_list);
}

/**
 * デバッグツール オブザーバ選択状況
 * @param {String} observer_name オブザーバ名
 */
CellObserver.dump_observer_selection = function(observer_name) {
	CellObserver.dump(observer_name + " selection", CellObserver.get(observer_name).selectedCells);
}
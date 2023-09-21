/*
        TableSort revisited v5.0 by frequency-decoder.com

        Released under a creative commons Attribution-ShareAlike 2.5 license (http://creativecommons.org/licenses/by-sa/2.5/)

        Please credit frequency decoder in any derivative work - thanks

        You are free:

        * to copy, distribute, display, and perform the work
        * to make derivative works
        * to make commercial use of the work

        Under the following conditions:

                by Attribution.
                --------------
                You must attribute the work in the manner specified by the author or licensor.

                sa
                --
                Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under a license identical to this one.

        * For any reuse or distribution, you must make clear to others the license terms of this work.
        * Any of these conditions can be waived if you get permission from the copyright holder.
*/

(function() {
fdTableSort = {
        regExp_Currency:        /^[£$€¥¤]/,
        regExp_Number:          /^(\-)?[0-9]+(\.[0-9]*)?$/,
        pos:                    -1,
        uniqueHash:             1,
        thNode:                 null,
        tableId:                null,
        tableCache:             {},
        tmpCache:               {},
        sortActiveClass:        "sort-active",
        /*@cc_on
        /*@if (@_win32)
        colspan:                "colSpan",
        rowspan:                "rowSpan",
        @else @*/
        colspan:                "colspan",
        rowspan:                "rowspan",
        /*@end
        @*/

        addEvent: function(obj, type, fn, tmp) {
                tmp || (tmp = true);
                if( obj.attachEvent ) {
                        obj["e"+type+fn] = fn;
                        obj[type+fn] = function(){obj["e"+type+fn]( window.event );};
                        obj.attachEvent( "on"+type, obj[type+fn] );
                } else {
                        obj.addEventListener( type, fn, true );
                };
        },
        removeEvent: function(obj, type, fn, tmp) {
                tmp || (tmp = true);
                try {
                        if( obj.detachEvent ) {
                                obj.detachEvent( "on"+type, obj[type+fn] );
                                obj[type+fn] = null;
                        } else {
                                obj.removeEventListener( type, fn, true );
                        };
                } catch(err) {};
        },
        stopEvent: function(e) {
                e = e || window.event;

                if(e.stopPropagation) {
                        e.stopPropagation();
                        e.preventDefault();
                };

                /*@cc_on@*/
                /*@if(@_win32)
                e.cancelBubble = true;
                e.returnValue  = false;
                /*@end@*/
                return false;
        },
        parseClassName: function(head, tbl) {
                var colMatch = tbl.className.match(new RegExp(head + "((-[\\d]+([r]){0,1})+)"));
                return colMatch && colMatch.length ? colMatch[0].replace(head, "").split("-") : [];
        },
        disableSelection: function(element) {
                element.onselectstart = function() {
                        return false;
                };
                element.unselectable = "on";
                element.style.MozUserSelect = "none";
        },
        removeTableCache: function(tableId) {
                if(!(tableId in fdTableSort.tableCache)) return;

                fdTableSort.tableCache[tableId] = null;
                delete fdTableSort.tableCache[tableId];

                var tbl = document.getElementById(tableId);
                if(!tbl) return;
                var ths = tbl.getElementsByTagName("th");
                var a;
                for(var i = 0, th; th = ths[i]; i++) {
                        a = th.getElementsByTagName("a");
                        if(a.length) a[0].onkeydown = a[0].onclick = null;
                        th.onclick = th.onselectstart = th = a = null;
                };
        },
        removeTmpCache: function(tableId) {
                if(!(tableId in fdTableSort.tmpCache)) return;
                var headers = fdTableSort.tmpCache[tableId].headers;
                var a;
                for(var i = 0, row; row = headers[i]; i++) {
                        for(var j = 0, th; th = row[j]; j++) {
                                a = th.getElementsByTagName("a");
                                if(a.length) a[0].onkeydown = a[0].onclick = null;
                                th.onclick = th.onselectstart = th = a = null;
                        };
                };
                fdTableSort.tmpCache[tableId] = null;
                delete fdTableSort.tmpCache[tableId];
        },
        initEvt: function(e) {
                fdTableSort.init(false);
        },
        init: function(tableId) {
                if (!document.getElementsByTagName || !document.createElement || !document.getElementById) return;

                var tables = tableId && document.getElementById(tableId) ? [document.getElementById(tableId)] : document.getElementsByTagName("table");
                var c, ii, len, colMatch, showOnly, match, showArrow, columnNumSortObj, obj, workArr, headers, thtext, aclone, multi, colCnt, cel, allRowArr, rowArr, sortableTable, celCount, colspan, rowspan, rowLength;

                var a          = document.createElement("a");
                a.href         = "#";
                a.className    = "fdTableSortTrigger";

                var span       = document.createElement("span");

                for(var k = 0, tbl; tbl = tables[k]; k++) {

                        if(tbl.id) {
                                fdTableSort.removeTableCache(tbl.id);
                                fdTableSort.removeTmpCache(tbl.id);
                        };

                        allRowArr     = tbl.getElementsByTagName('thead').length ? tbl.getElementsByTagName('thead')[0].getElementsByTagName('tr') : tbl.getElementsByTagName('tr');
                        rowArr        = [];
                        sortableTable = false;

                        for(var i = 0, tr; tr = allRowArr[i]; i++) {
                                if(tr.getElementsByTagName('td').length || !tr.getElementsByTagName('th').length) { continue; };
                                rowArr[rowArr.length] = tr.getElementsByTagName('th');
                                for(var j = 0, th; th = rowArr[rowArr.length - 1][j]; j++) {
                                        if(th.className.search(/sortable/) != -1) { sortableTable = true; };
                                };
                        };

                        if(!sortableTable) continue;

                        if(!tbl.id) { tbl.id = "fd-table-" + fdTableSort.uniqueHash++; };

                        showArrow   = tbl.className.search("no-arrow") == -1;
                        showOnly    = tbl.className.search("sortable-onload-show") != -1;

                        columnNumSortObj = {};
                        colMatch         = fdTableSort.parseClassName(showOnly ? "sortable-onload-show" : "sortable-onload", tbl);
                        for(match = 1; match < colMatch.length; match++) {
                                columnNumSortObj[parseInt(colMatch[match], 10)] = { "reverse":colMatch[match].search("r") != -1 };
                        };

                        rowLength = rowArr[0].length;

                        for(c = 0;c < rowArr[0].length;c++){
                                if(rowArr[0][c].getAttribute(fdTableSort.colspan) && rowArr[0][c].getAttribute(fdTableSort.colspan) > 1){
                                        rowLength = rowLength + (rowArr[0][c].getAttribute(fdTableSort.colspan) - 1);
                                };
                        };

                        workArr = new Array(rowArr.length);
                        for(c = rowArr.length;c--;){ workArr[c]= new Array(rowLength); };

                        for(c = 0;c < workArr.length;c++){
                                celCount = 0;
                                for(i = 0;i < rowLength;i++){
                                        if(!workArr[c][i]){
                                                cel = rowArr[c][celCount];
                                                colspan = (cel.getAttribute(fdTableSort.colspan) > 1) ? cel.getAttribute(fdTableSort.colspan):1;
                                                rowspan = (cel.getAttribute(fdTableSort.rowspan) > 1) ? cel.getAttribute(fdTableSort.rowspan):1;
                                                for(var t = 0;((t < colspan)&&((i+t) < rowLength));t++){
                                                        for(var n = 0;((n < rowspan)&&((c+n) < workArr.length));n++) {
                                                                workArr[(c+n)][(i+t)] = cel;
                                                        };
                                                };
                                                if(++celCount == rowArr[c].length) break;
                                        };
                                };
                        };

                        for(c = 0;c < workArr.length;c++) {
                                for(i = 0;i < workArr[c].length;i++){

                                        if(workArr[c][i].className.search("fd-column-") == -1 && workArr[c][i].className.search("sortable") != -1) workArr[c][i].className = workArr[c][i].className + " fd-column-" + i;

                                        if(workArr[c][i].className.match('sortable')) {
                                                workArr[c][i].className = workArr[c][i].className.replace(/forwardSort|reverseSort/, "");

                                                if(i in columnNumSortObj) {
                                                        columnNumSortObj[i]["thNode"] = workArr[c][i];
                                                        columnNumSortObj["active"] = true;
                                                };

                                                thtext = fdTableSort.getInnerText(workArr[c][i], true);

                                                for(var cn = workArr[c][i].childNodes.length; cn--;) {
                                                        // Skip image nodes and links created by the filter script.
                                                        if(workArr[c][i].childNodes[cn].nodeType == 1 && (workArr[c][i].childNodes[cn].className == "fdFilterTrigger" || /img/i.test(workArr[c][i].childNodes[cn].nodeName))) {
                                                                continue;
                                                        };
                                                        if(workArr[c][i].childNodes[cn].nodeType == 1 && /^a$/i.test(workArr[c][i].childNodes[cn].nodeName)) {
                                                                workArr[c][i].childNodes[cn].onclick = workArr[c][i].childNodes[cn].onkeydown = null;
                                                        };
                                                        workArr[c][i].removeChild(workArr[c][i].childNodes[cn]);
                                                };

                                                aclone = a.cloneNode(true);
                                                //aclone.appendChild(document.createTextNode(thtext));
                                                aclone.innerText = thtext;
                                                aclone.title = "Sort on \u201c" + thtext.replace('<br />', '') + "\u201d";
                                                aclone.onclick = aclone.onkeydown = workArr[c][i].onclick = fdTableSort.initWrapper;
                                                workArr[c][i].appendChild(aclone);
                                                if(showArrow) workArr[c][i].appendChild(span.cloneNode(false));
                                                workArr[c][i].className = workArr[c][i].className.replace(/fd-identical|fd-not-identical/, "");
                                                fdTableSort.disableSelection(workArr[c][i]);
                                                aclone = null;
                                        };
                                };
                        };

                        fdTableSort.tmpCache[tbl.id] = {cols:rowLength, headers:workArr};

                        workArr = null;
                        multi   = 0;

                        if("active" in columnNumSortObj) {
                                fdTableSort.tableId = tbl.id;
                                fdTableSort.prepareTableData(document.getElementById(fdTableSort.tableId));

                                delete columnNumSortObj["active"];

                                for(col in columnNumSortObj) {
                                        obj = columnNumSortObj[col];
                                        if(!("thNode" in obj)) { continue; };
                                        fdTableSort.multi = true;

                                        len = obj.reverse ? 2 : 1;

                                        for(ii = 0; ii < len; ii++) {
                                                fdTableSort.thNode = obj.thNode;
                                                if(!showOnly) {
                                                        fdTableSort.initSort(false, true);
                                                } else {
                                                        fdTableSort.addThNode();
                                                };
                                        };

                                        if(showOnly) {
                                                fdTableSort.removeClass(obj.thNode, "(forwardSort|reverseSort)");
                                                fdTableSort.addClass(obj.thNode, obj.reverse ? "reverseSort" : "forwardSort");
                                                if(showArrow) {
                                                        span = fdTableSort.thNode.getElementsByTagName('span')[0];
                                                        if(span.firstChild) { span.removeChild(span.firstChild); };
                                                        span.appendChild(document.createTextNode(len == 1 ? " \u2193" : " \u2191"));
                                                };
                                        };
                                };
                                if(showOnly && (fdTableSort.tableCache[tbl.id].colStyle || fdTableSort.tableCache[tbl.id].rowStyle)) {
                                        fdTableSort.redraw(tbl.id, false);
                                };
                        } else if(tbl.className.search(/onload-zebra/) != -1) {
                                fdTableSort.tableId = tbl.id;
                                fdTableSort.prepareTableData(tbl);
                                if(fdTableSort.tableCache[tbl.id].rowStyle) { fdTableSort.redraw(tbl.id, false); };
                        };
                };

                fdTableSort.thNode = aclone = a = span = columnNumSortObj = thNode = tbl = allRowArr = rowArr = null;
        },
        initWrapper: function(e) {
                e = e || window.event;
                var kc = e.type == "keydown" ? e.keyCode != null ? e.keyCode : e.charCode : -1;
                if(fdTableSort.thNode == null && (e.type == "click" || kc == 13)) {
                        var targ = this;
                        while(targ.tagName.toLowerCase() != "th") { targ = targ.parentNode; };
                        fdTableSort.thNode = targ;
                        while(targ.tagName.toLowerCase() != "table") { targ = targ.parentNode; };
                        fdTableSort.tableId = targ.id;
                        fdTableSort.multi = e.shiftKey;
                        fdTableSort.addSortActiveClass();
                        setTimeout(fdTableSort.initSort,5,false);
                        return fdTableSort.stopEvent(e);
                };
                return kc != -1 ? true : fdTableSort.stopEvent(e);
        },
        jsWrapper: function(tableid, colNums) {
                if(!(tableid in fdTableSort.tmpCache)) { return false; };
                if(!(tableid in fdTableSort.tableCache)) { fdTableSort.prepareTableData(document.getElementById(tableid)); };
                if(!(colNums instanceof Array)) { colNums = [colNums]; };

                fdTableSort.tableId = tableid;
                var len = colNums.length, colNum;

                if(fdTableSort.tableCache[tableid].thList.length == colNums.length) {
                        var identical = true;
                        var th;
                        for(var i = 0; i < len; i++) {
                                colNum = colNums[i];
                                th = fdTableSort.tmpCache[tableid].headers[0][colNum];
                                if(th != fdTableSort.tableCache[tableid].thList[i]) {
                                        identical = false;
                                        break;
                                };
                        };
                        if(identical) {
                                fdTableSort.thNode = th;
                                fdTableSort.initSort(true);
                                return;
                        };
                };

                fdTableSort.addSortActiveClass();

                for(var i = 0; i < len; i++) {
                        fdTableSort.multi = i;
                        colNum = colNums[i];
                        fdTableSort.thNode = fdTableSort.tmpCache[tableid].headers[0][colNum];
                        fdTableSort.initSort(true);
                };
        },
        addSortActiveClass: function() {
                if(fdTableSort.thNode == null) { return; };
                fdTableSort.addClass(fdTableSort.thNode, fdTableSort.sortActiveClass);
                fdTableSort.addClass(document.getElementsByTagName('body')[0], fdTableSort.sortActiveClass);
        },
        removeSortActiveClass: function() {
                if(fdTableSort.thNode == null) return;
                fdTableSort.removeClass(fdTableSort.thNode, fdTableSort.sortActiveClass);
                fdTableSort.removeClass(document.getElementsByTagName('body')[0], fdTableSort.sortActiveClass);
        },
        doCallback: function(init) {
                if(!fdTableSort.tableId || !(fdTableSort.tableId in fdTableSort.tableCache)) { return; };
                fdTableSort.callback(fdTableSort.tableId, init ? fdTableSort.tableCache[fdTableSort.tableId].initiatedCallback : fdTableSort.tableCache[fdTableSort.tableId].completeCallback);
        },
        addClass: function(e,c) {
                if(new RegExp("(^|\\s)" + c + "(\\s|$)").test(e.className)) { return; };
                e.className += ( e.className ? " " : "" ) + c;
        },
        /*@cc_on
        /*@if (@_win32)
        removeClass: function(e,c) {
                e.className = !c ? "" : e.className.replace(new RegExp("(^|\\s)" + c + "(\\s|$)"), " ").replace(/^\s*((?:[\S\s]*\S)?)\s*$/, '$1');
        },
        @else @*/
        removeClass: function(e,c) {
                e.className = !c ? "" : e.className.replace(new RegExp("(^|\\s)" + c + "(\\s|$)"), " ").replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        },
        /*@end
        @*/
        callback: function(tblId, cb) {
                var func, parts;
                try {
                        if(cb.indexOf(".") != -1) {
                                parts = cb.split('.');
                                obj   = window;
                                for (var x = 0, part; part = obj[parts[x]]; x++) {
                                        if(part instanceof Function) {
                                                (function() {
                                                        var method = part;
                                                        func = function (data) { method.apply(obj, [data]) };
                                                })();
                                        } else {
                                                obj = part;
                                        };
                                };
                        } else if(cb + tblId in window) {
                                func = window[cb + tblId];
                        } else if(cb in window) {
                                func = window[cb];
                        } else {
                                func = null;
                        };
                 } catch(err) {};

                if(!(func instanceof Function)) return;
                func(tblId, fdTableSort.tableCache[tblId].thList);
        },
        prepareTableData: function(table) {
                var data = [];

                var start = table.getElementsByTagName('tbody');
                start = start.length ? start[0] : table;

                var trs = start.rows;
                var ths = table.getElementsByTagName('th');

                var numberOfRows = trs.length;
                var numberOfCols = fdTableSort.tmpCache[table.id].cols;

                var data = [];
                var identical = new Array(numberOfCols);
                var identVal  = new Array(numberOfCols);

                for(var tmp = 0; tmp < numberOfCols; tmp++) identical[tmp] = true;

                var tr, td, th, txt, tds, col, row;

                var re = new RegExp(/fd-column-([0-9]+)/);
                var rowCnt = 0;

                var sortableColumnNumbers = [];

                for(var tmp = 0, th; th = ths[tmp]; tmp++) {
                        if(th.className.search(re) == -1) continue;
                        sortableColumnNumbers[sortableColumnNumbers.length] = th;
                };

                for(row = 0; row < numberOfRows; row++) {

                        tr              = trs[row];
                        if(tr.parentNode != start || tr.getElementsByTagName("th").length || (tr.parentNode && tr.parentNode.tagName.toLowerCase().search(/thead|tfoot/) != -1)) continue;
                        data[rowCnt]    = [];
                        tds             = tr.cells;

                        for(var tmp = 0, th; th = sortableColumnNumbers[tmp]; tmp++) {
                                col = th.className.match(re)[1];

                                td  = tds[col];
                                txt = fdTableSort.getInnerText(td) + " ";
                                txt = txt.replace(/^\s+/,'').replace(/\s+$/,'');

                                if(th.className.search(/sortable-date/) != -1) {
                                        txt = fdTableSort.dateFormat(txt, th.className.search(/sortable-date-dmy/) != -1);
                                } else if(th.className.search(/sortable-numeric|sortable-currency/) != -1) {
                                        txt = parseFloat(txt.replace(/[^0-9\.\-]/g,''));
                                        if(isNaN(txt)) txt = "";
                                } else if(th.className.search(/sortable-text/) != -1) {
                                        txt = txt.toLowerCase();
                                } else if (th.className.search(/sortable-keep/) != -1) {
                                        txt = rowCnt;
                                } else if(th.className.search(/sortable-([a-zA-Z\_]+)/) != -1) {
                                        if((th.className.match(/sortable-([a-zA-Z\_]+)/)[1] + "PrepareData") in window) {
                                                txt = window[th.className.match(/sortable-([a-zA-Z\_]+)/)[1] + "PrepareData"](td, txt);
                                        };
                                } else if(txt != "") {
                                        fdTableSort.removeClass(th, "sortable");
                                        if(fdTableSort.dateFormat(txt) != 0) {
                                                fdTableSort.addClass(th, "sortable-date");
                                                txt = fdTableSort.dateFormat(txt);
                                        } else if(txt.search(fdTableSort.regExp_Number) != -1 || txt.search(fdTableSort.regExp_Currency) != -1) {
                                                fdTableSort.addClass(th, "sortable-numeric");
                                                txt = parseFloat(txt.replace(/[^0-9\.\-]/g,''));
                                                if(isNaN(txt)) txt = "";
                                        } else {
                                                fdTableSort.addClass(th, "sortable-text");
                                                txt = txt.toLowerCase();
                                        };
                                };

                                if(rowCnt > 0 && identical[col] && identVal[col] != txt) { identical[col] = false; };

                                identVal[col]     = txt;
                                data[rowCnt][col] = txt;
                        };
                        data[rowCnt][numberOfCols] = tr;
                        rowCnt++;
                };

                var colStyle = table.className.search(/colstyle-([\S]+)/) != -1 ? table.className.match(/colstyle-([\S]+)/)[1] : false;
                var rowStyle = table.className.search(/rowstyle-([\S]+)/) != -1 ? table.className.match(/rowstyle-([\S]+)/)[1] : false;
                var iCBack   = table.className.search(/sortinitiatedcallback-([\S-]+)/) == -1 ? "sortInitiatedCallback" : table.className.match(/sortinitiatedcallback-([\S]+)/)[1];
                var cCBack   = table.className.search(/sortcompletecallback-([\S-]+)/) == -1 ? "sortCompleteCallback" : table.className.match(/sortcompletecallback-([\S]+)/)[1];
                iCBack = iCBack.replace("-", ".");
                cCBack = cCBack.replace("-", ".");
                fdTableSort.tableCache[table.id] = { hook:start, initiatedCallback:iCBack, completeCallback:cCBack, thList:[], colOrder:{}, data:data, identical:identical, colStyle:colStyle, rowStyle:rowStyle, noArrow:table.className.search(/no-arrow/) != -1 };
                sortableColumnNumbers = data = tr = td = th = trs = identical = identVal = null;
        },
        onUnload: function() {
                for(tbl in fdTableSort.tableCache) { fdTableSort.removeTableCache(tbl); };
                for(tbl in fdTableSort.tmpCache) { fdTableSort.removeTmpCache(tbl); };
                fdTableSort.removeEvent(window, "load", fdTableSort.initEvt);
                fdTableSort.removeEvent(window, "unload", fdTableSort.onUnload);
                fdTableSort.tmpCache = fdTableSort.tableCache = null;
        },
        addThNode: function() {
                var dataObj = fdTableSort.tableCache[fdTableSort.tableId];
                var pos     = fdTableSort.thNode.className.match(/fd-column-([0-9]+)/)[1];
                var alt     = false;

                if(!fdTableSort.multi) {
                        if(dataObj.colStyle) {
                                var len = dataObj.thList.length;
                                for(var i = 0; i < len; i++) {
                                        dataObj.colOrder[dataObj.thList[i].className.match(/fd-column-([0-9]+)/)[1]] = false;
                                };
                        };
                        if(dataObj.thList.length && dataObj.thList[0] == fdTableSort.thNode) alt = true;
                        dataObj.thList = [];
                };

                var found = false;
                var l = dataObj.thList.length;

                for(var i = 0, n; n = dataObj.thList[i]; i++) {
                        if(n == fdTableSort.thNode) {
                                found = true;
                                break;
                        };
                };

                if(!found) {
                        dataObj.thList.push(fdTableSort.thNode);
                        if(dataObj.colStyle) { dataObj.colOrder[pos] = true; };
                };

                var ths = document.getElementById(fdTableSort.tableId).getElementsByTagName("th");
                for(var i = 0, th; th = ths[i]; i++) {
                        found = false;
                        for(var z = 0, n; n = dataObj.thList[z]; z++) {
                                if(n == th) {
                                        found = true;
                                        break;
                                };
                        };
                        if(!found) {
                                fdTableSort.removeClass(th, "(forwardSort|reverseSort)");
                                if(!dataObj.noArrow) {
                                        span = th.getElementsByTagName('span');
                                        if(span.length) {
                                                span = span[0];
                                                while(span.firstChild) span.removeChild(span.firstChild);
                                        };
                                };
                        };
                };

                if(dataObj.thList.length > 1) {
                        classToAdd = fdTableSort.thNode.className.search(/forwardSort/) != -1 ? "reverseSort" : "forwardSort";
                        fdTableSort.removeClass(fdTableSort.thNode, "(forwardSort|reverseSort)");
                        fdTableSort.addClass(fdTableSort.thNode, classToAdd);
                        dataObj.pos = -1
                } else if(alt) { dataObj.pos = fdTableSort.thNode };
        },
        initSort: function(noCallback, ident) {
                var thNode      = fdTableSort.thNode;
                var tableElem   = document.getElementById(fdTableSort.tableId);

                if(!(fdTableSort.tableId in fdTableSort.tableCache)) { fdTableSort.prepareTableData(document.getElementById(fdTableSort.tableId)); };

                fdTableSort.addThNode();

                if(!noCallback) { fdTableSort.doCallback(true); };

                fdTableSort.pos = thNode.className.match(/fd-column-([0-9]+)/)[1];
                var dataObj     = fdTableSort.tableCache[tableElem.id];
                var lastPos     = dataObj.pos && dataObj.pos.className ? dataObj.pos.className.match(/fd-column-([0-9]+)/)[1] : -1;
                var len1        = dataObj.data.length;
                var len2        = dataObj.data.length > 0 ? dataObj.data[0].length - 1 : 0;
                var identical   = dataObj.identical[fdTableSort.pos];
                var classToAdd  = "forwardSort";

                if(dataObj.thList.length > 1) {
                        var js  = "var sortWrapper = function(a,b) {\n";
                        var l   = dataObj.thList.length;
                        var cnt = 0;
                        var e,d,th,p,f;

                        for(var i=0; i < l; i++) {
                                th = dataObj.thList[i];
                                p  = th.className.match(/fd-column-([0-9]+)/)[1];
                                if(dataObj.identical[p]) { continue; };
                                cnt++;

                                if(th.className.match(/sortable-(numeric|currency|date|keep)/)) {
                                        f = "fdTableSort.sortNumeric";
                                } else if(th.className.match('sortable-text')) {
                                        f = "fdTableSort.sortText";
                                } else if(th.className.search(/sortable-([a-zA-Z\_]+)/) != -1 && th.className.match(/sortable-([a-zA-Z\_]+)/)[1] in window) {
                                        f = "window['" + th.className.match(/sortable-([a-zA-Z\_]+)/)[1] + "']";
                                } else  f = "fdTableSort.sortText";

                                e = "e" + i;
                                d = th.className.search('forwardSort') != -1 ? "a,b" : "b,a";
                                js += "fdTableSort.pos   = " + p + ";\n";
                                js += "var " + e + " = "+f+"(" + d +");\n";
                                js += "if(" + e + ") return " + e + ";\n";
                                js += "else { \n";
                        };

                        js += "return 0;\n";

                        for(var i=0; i < cnt; i++) {
                                js += "};\n";
                        };

                        if(cnt) js += "return 0;\n";
                        js += "};\n";

                        eval(js);
                        dataObj.data.sort(sortWrapper);
                        identical = false;
                } else if((lastPos == fdTableSort.pos && !identical) || (thNode.className.search(/sortable-keep/) != -1 && lastPos == -1)) {
                        dataObj.data.reverse();
                        classToAdd = thNode.className.search(/reverseSort/) != -1 ? "forwardSort" : "reverseSort";
                        if(thNode.className.search(/sortable-keep/) != -1 && lastPos == -1) fdTableSort.tableCache[tableElem.id].pos = thNode;
                } else {
                        fdTableSort.tableCache[tableElem.id].pos = thNode;
                        classToAdd = thNode.className.search(/forwardSort/) != -1 ? "reverseSort" : "forwardSort";
                        if(!identical) {
                                if(thNode.className.match(/sortable-(numeric|currency|date|keep)/)) {
                                        dataObj.data.sort(fdTableSort.sortNumeric);
                                } else if(thNode.className.match('sortable-text')) {
                                        dataObj.data.sort(fdTableSort.sortText);
                                } else if(thNode.className.search(/sortable-([a-zA-Z\_]+)/) != -1 && thNode.className.match(/sortable-([a-zA-Z\_]+)/)[1] in window) {
                                        dataObj.data.sort(window[thNode.className.match(/sortable-([a-zA-Z\_]+)/)[1]]);
                                };

                                if(thNode.className.search(/(^|\s)favour-reverse($|\s)/) != -1) {
                                        classToAdd = classToAdd == "forwardSort" ? "reverseSort" : "forwardSort";
                                        dataObj.data.reverse();
                                };
                        };
                };
                if(ident) { identical = false; };
                if(dataObj.thList.length == 1) {
                        fdTableSort.removeClass(thNode, "(forwardSort|reverseSort)");
                        fdTableSort.addClass(thNode, classToAdd);
                };
                if(!dataObj.noArrow) {
                        var span = fdTableSort.thNode.getElementsByTagName('span')[0];
                        if(span.firstChild) span.removeChild(span.firstChild);
                        span.appendChild(document.createTextNode(fdTableSort.thNode.className.search(/forwardSort/) != -1 ? " \u2193" : " \u2191"));
                };
                if(!dataObj.rowStyle && !dataObj.colStyle && identical) {
                        fdTableSort.removeSortActiveClass();
                        if(!noCallback) { fdTableSort.doCallback(false); };
                        fdTableSort.thNode = null;
                        return;
                };
                if("tablePaginater" in window && tablePaginater.tableIsPaginated(fdTableSort.tableId)) {
                        tablePaginater.redraw(fdTableSort.tableId, identical);
                } else {
                        fdTableSort.redraw(fdTableSort.tableId, identical);
                };
                fdTableSort.removeSortActiveClass();
                if(!noCallback) { fdTableSort.doCallback(false); };
                fdTableSort.thNode = null;
        },
        redraw: function(tableid, identical) {
                if(!tableid || !(tableid in fdTableSort.tableCache)) { return; };
                var dataObj     = fdTableSort.tableCache[tableid];
                var data        = dataObj.data;
                var len1        = data.length;
                var len2        = len1 ? data[0].length - 1 : 0;
                var hook        = dataObj.hook;
                var colStyle    = dataObj.colStyle;
                var rowStyle    = dataObj.rowStyle;
                var colOrder    = dataObj.colOrder;
                var highLight   = 0;
                var reg         = /(^|\s)invisibleRow(\s|$)/;
                var tr, tds;

                for(var i = 0; i < len1; i++) {
                        tr = data[i][len2];
                        if(colStyle) {
                                tds = tr.cells;
                                for(thPos in colOrder) {
                                        if(!colOrder[thPos]) fdTableSort.removeClass(tds[thPos], colStyle);
                                        else fdTableSort.addClass(tds[thPos], colStyle);
                                };
                        };
                        if(!identical) {
                                if(rowStyle && tr.className.search(reg) == -1) {
                                        if(highLight++ & 1) fdTableSort.addClass(tr, rowStyle);
                                        else fdTableSort.removeClass(tr, rowStyle);
                                };

                                // Netscape 8.1.2 requires the removeChild call or it freaks out, so add the line if you want to support this browser
                                // hook.removeChild(tr);
                                hook.appendChild(tr);
                        };
                };
                tr = tds = hook = null;
        },
        getInnerText: function(el, allowBrTags) {
                if (typeof el == "string" || typeof el == "undefined") return el;
                if(el.innerText) return el.innerText;
                var txt = '', i;
                for(i = el.firstChild; i; i = i.nextSibling) {
                        if(allowBrTags && i.nodeName && i.nodeName == "BR") txt += "<br />";
                        else if(i.nodeType == 3)       txt += i.nodeValue;
                        else if(i.nodeType == 1)       txt += fdTableSort.getInnerText(i);
                };
                return txt;
        },
        dateFormat: function(dateIn, favourDMY) {
                var dateTest = [
                        { regExp:/^(0?[1-9]|1[012])([- \/.])(0?[1-9]|[12][0-9]|3[01])([- \/.])((\d\d)?\d\d)$/, d:3, m:1, y:5 },  // mdy
                        { regExp:/^(0?[1-9]|[12][0-9]|3[01])([- \/.])(0?[1-9]|1[012])([- \/.])((\d\d)?\d\d)$/, d:1, m:3, y:5 },  // dmy
                        { regExp:/^(\d\d\d\d)([- \/.])(0?[1-9]|1[012])([- \/.])(0?[1-9]|[12][0-9]|3[01])$/, d:5, m:3, y:1 }      // ymd
                        ];
                var start, cnt = 0, numFormats = dateTest.length;
                while(cnt < numFormats) {
                        start = (cnt + (favourDMY ? numFormats + 1 : numFormats)) % numFormats;
                        if(dateIn.match(dateTest[start].regExp)) {
                                res = dateIn.match(dateTest[start].regExp);
                                y = res[dateTest[start].y];
                                m = res[dateTest[start].m];
                                d = res[dateTest[start].d];
                                if(m.length == 1) m = "0" + String(m);
                                if(d.length == 1) d = "0" + String(d);
                                if(y.length != 4) y = (parseInt(y) < 50) ? "20" + String(y) : "19" + String(y);

                                return y+String(m)+d;
                        };
                        cnt++;
                };
                return 0;
        },
        sortNumeric:function(a,b) {
                var aa = a[fdTableSort.pos];
                var bb = b[fdTableSort.pos];
                if(aa == bb) return 0;
                if(aa === "" && !isNaN(bb)) return -1;
                if(bb === "" && !isNaN(aa)) return 1;
                return aa - bb;
        },
        sortText:function(a,b) {
                var aa = a[fdTableSort.pos];
                var bb = b[fdTableSort.pos];
                if(aa == bb) return 0;
                if(aa < bb)  return -1;
                return 1;
        }
};
})();
fdTableSort.addEvent(window, "load",   fdTableSort.initEvt);
fdTableSort.addEvent(window, "unload", fdTableSort.onUnload);

// 탭속의 버튼에서 클릭시 부모페이지의 deleteTabFromChild를 호출
var closeTab = function () {
    // 오류예방 차원에서 본 함수의 실행을 종료하고 setTImeout 이벤트로 창닫기를 실행 ( 여기서 직접 닫으면 리턴할곳이 없어 오류 발생 유발가능 )
    setTimeout(top.deleteTabFromChild, 100);
}

var hidePop = function () {
    //    try { parentAutoLoadControl.hide(); } catch (exception) { } finally { }
    try { parent.Ext.WindowMgr.getActive().close(); } catch (exception) { } finally { }
    
}

// Don't touch this code
var dummy = function () { }
var Notice_Shown = null;

// alter redefine
var EPAlert = function (text, title) {
    if (title == null) title = "Alert";

    if (parent && parent.Ext)
        parent.Ext.Msg.alert(title, text);
    else if (Ext)
        Ext.Msg.alert(title, text);
    else
        alert(text);
}

var EPNotify = function (message, caption) {
    Ext.net.Notification.show({
        //iconCls: 'icon-information',
        pinEvent: 'click',
        html: message,
        title: caption
    });
}


var logoutHandler = function (message) {
    if (message != null && message != "")
        App.direct.LogoutCheck(message);
    else
        App.direct.Logout();
};

var homeHandler = function () {
    App.direct.Home();
};

// 다이렉트 메소드 string 반환용 인터페이스 정의
var getCodeMsg = function (msgCode) {
    var resultText = "";
    top.App.direct.GetCodeMessage(msgCode, { async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var getClientIP = function () {
    var resultText = "";
    top.App.direct.GetClientIP({ async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var getMenuID = function () {
    var resultText = "";
    top.App.direct.GetMenuID({ async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var getMenuID_Name = function () {
    var resultText = "";
    top.App.direct.GetMenuID_Name({ async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var getMenuName = function () {
    var resultText = "";
    top.App.direct.GetMenuName({ async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var getMenuUrl = function (menuId) {
    var resultText = "";
    top.App.direct.GetMenuUrl(menuId, { async: false, success: function (result) { resultText = result; } });

    return resultText;
}

var Valid = function (success, errorMsg, id, text) {
    EPAlert("Please, Input [" +text + "]");

    if (Ext.getCmp(id))
        Ext.getCmp(id).focus();
    else
        if (document.getElementById(id)) document.getElementById(id).focus();
}

var ValidNoTiltleNoFocus = function (success, errorMsg, text) {
    EPAlert(text);
}

var ValidDecimal = function (success, errorMsg, id, text) {
    EPAlert(id + " : " + text);
}

var submitValue = function (grid, hiddenFormat, format) {
    if (hiddenFormat != null && hiddenFormat != "undefined")
        hiddenFormat.setValue(format);

    grid.submitData(false);
};

var template = '<span style="color:{0};">{1}</span>';

var change = function (value) {
    return String.format(template, (value > 0) ? "green" : "red", value);
};

var pctChange = function (value) {
    return String.format(template, (value > 0) ? "green" : "red", value + "%");
};

// Event kill Function
function eventFault(e) {
    if (e) {   //standard         
        e.preventDefault();
    }
    else { // iexplorer
        event.keyCode = 0;
        event.returnValue = false;
    }
}

// 웹페이지에 [ Backspace / Esc / F5(Refresh) ] 기능 죽이기 (입력받스 아니거나 또는 Readonly, Disabled 된 항목일 때)
document.onkeydown = function (e) {
    // 키 코드 값을 구함
    key = (e) ? e.keyCode : event.keyCode;

    // BackSpace 키 죽이기
    if (key == 8) {
        // readOnly 이거나 Diabled 이거나 또는 값이 없을 경우는 입력태그가 아니므로 키 죽이기
        if (event.srcElement.readOnly || event.srcElement.disabled ||
			event.srcElement.readOnly == null || event.srcElement.disabled == null ||
			event.srcElement.type == null) {
            eventFault(e); 	// 이벤트 죽이기
        }
        // 상단의 조건에 만족하지 않을 때 INPUT Tag이며 isTextEdit 를 만족하지 않으면 키 죽이기
        else if (event.srcElement.tagName.toUpperCase() == "INPUT" &&
				 event.srcElement.type.toUpperCase() != "TEXT" &&
				 event.srcElement.type.toUpperCase() != "PASSWORD") {
            eventFault(e); 	// 이벤트 죽이기
        }
    }
    else if (key == 113) {
        //F2 키 입력시 "조회" 처리
        var btn = Ext.getCmp('ButtonSearch');

        if (btn) { btn.fireEvent('click'); } 
        else {
            btn = Ext.getCmp('ButtonM_Search');

            if (btn) { btn.fireEvent('click'); }
            else {
                var panel = Ext.getCmp('TabPanel1');
                if (panel) {
                    var tab = panel.getActiveTab();

                    if (tab && tab.iframe && tab.iframe.dom) {
                        btn = window.frames[tab.iframe.dom.name].Ext.getCmp("ButtonSearch");

                        if (typeof (tab) == "object" && tab.closable) {
                            if (btn) { btn.fireEvent('click'); }
                            else {
                                btn = window.frames[tab.iframe.dom.name].Ext.getCmp("ButtonM_Search");
                                if (btn) btn.fireEvent('click');
                            }
                        }
                    }
                }
            }
        }
    }

    // F5 (Refresh 키 죽이기) - 2014.10.20 김도연 과장 요구  ( 운영서버에서는 F5 키 사용 중지 요청 )
    else if (key == 116 && (document.location.href.indexOf("hanileh.com") >= 0 || document.location.href.indexOf("seoyoneh.com") >= 0 || document.location.href.indexOf("seoyoneh.sk") >= 0 || document.location.href.indexOf("hanilehsk.com") >= 0)) {
        eventFault(e); 	// 이벤트 죽이기
    }

    // ESC 키 죽이기
    //    else if (key == 27) {
    //        eventFault(e); 	// 이벤트 죽이기
    //    }
}

window.onunload = function (e) {
    //    try { App.direct.ActionHandle("", "CLOSE"); } catch (exception) { } finally { }
    try { App.direct.ActionHandle("", "CLOSE", { async: false, success: function (result) { } }); } catch (exception) { } finally { }
}

/* 사용안함
document.oncontextmenu = function () {
    // 운영서버에서 마우스 오른족 버튼 마기
    var len = 0;

    if ((document.location.href.indexOf("hanileh.com") >= 0 && document.location.href.indexOf("seoyoneh.com") < 0)) {
        if (event.srcElement.tagName != null && event.srcElement.tagName.toUpperCase() == "IMG") {
            len = 0;
        }
        else {
            if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)) {
                // INTERNET EXPLORER           
                len = document.selection.createRange().text.length;
            }
            else {
                // OTHER EXPLORER           
                len = window.getSelection().toString().length;
            }

            if (event.srcElement.type == null || event.srcElement.type == "undefine") {
                if (len == 0) {
                    return false;
                }
            }
            else if (event.srcElement.type.toUpperCase() != "TEXT" &&
            event.srcElement.type.toUpperCase() != "TEXTAREA" &&
		    event.srcElement.type.toUpperCase() != "PASSWORD" &&
            len == 0) {
                return false;
            }
        }
    }
};
*/


function isValidDate(dateStr) {
    var year = Number(dateStr.substr(0, 4));
    var month = Number(dateStr.substr(4, 2));
    var day = Number(dateStr.substr(6, 2));

    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) return false;

    if (month == 2) { // check for february 29th        
        var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
        if (day > 29 || (day == 29 && !isleap)) return false;
    }

    return true;
}

function trim(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
String.prototype.trim = function () {
    return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function getByteLength(str) {
    var len = 0;

    if (str == null) return 0;

    for (var i = 0; i < str.length; i++) {
        var c = escape(str.charAt(i));
        if (c.length == 1) len++;
        else if (c.indexOf("%u") != -1) len += 2;
        else if (c.indexOf("%") != -1) len += c.length / 3;
    }

    return len;
}

// http / https 등의 protocol 구해오기
function GetProtocol(_url) {
    return window.location.protocol + "//";
}

// 지정된 경로의 파일 URL 을 받는다. ( 사용안함 )
//function FileDownloadUrlByPath(_filePath) {
//    return "/Download.aspx?FilePath=" + encodeURIComponent(_filePath);
//}

// 지정된 fileID의 파일 URL 을 받는다. ( 사용안함 )
//function FileDownloadUrlByFileID(_fileID) {
//    return "/Download.aspx?FileID=" + encodeURIComponent(_fileID);
//}

// 지정된 경로의 이미지 URL 을 받는다. ( 사용안함 )
//function FileImageUrlByPath(_filePath) {
//    return "/DownloadImage.aspx?FilePath=" + encodeURIComponent(_filePath);
//}

// 지정된 fileID의 이미지 URL 을 받는다. ( 사용안함 )
//function FileImageUrlByFileID(_fileID) {
//    return "/DownloadImage.aspx?FileID=" + encodeURIComponent(_fileID);
//}

// 지정된 경로의 파일을 직접 받는다.
// _filePath 에 "../" 또는 "/" 등의경로가 주어지면 full경로를 찾고    바로 파일명또는 폴더명이 시작하면 /files/ 에서 찾는다.
function FileDirectDownloadByPath(_doc, _filePath) {
    EPNotify("Please wait. The downloads preparing!(잠시만 기다리세요. 다운로드 준비중입니다.)", "System Notice");

    var loader = _doc.getElementById("DirectFileDownFrame");
    if (loader) _doc.body.removeChild(loader);

    var ifrm = _doc.createElement("iframe");
    ifrm.setAttribute("id", "DirectFileDownFrame");
    ifrm.setAttribute("name", "DirectFileDownFrame");
    ifrm.setAttribute("style", "height:0px; width:0px; visibility:hidden")
    ifrm.setAttribute("width", "0");
    ifrm.setAttribute("height", "0");
    ifrm.setAttribute("src", "/Download.aspx?FilePath=" + encodeURIComponent(_filePath));
    ifrm.setAttribute("frameborder", "0");

    _doc.body.appendChild(ifrm);
}

// 지정된 파일아이디로 받는다.
function FileDirectDownloadByFileID(_doc, _fileID) {
    EPNotify("Please wait. The downloads preparing!(잠시만 기다리세요. 다운로드 준비중입니다.)", "System Notice");

    var loader = _doc.getElementById("DirectFileDownFrame");
    if (loader) _doc.body.removeChild(loader);

    var ifrm = _doc.createElement("iframe");
    ifrm.setAttribute("id", "DirectFileDownFrame");
    ifrm.setAttribute("name", "DirectFileDownFrame");
    ifrm.setAttribute("style", "height:0px; width:0px; visibility:hidden")
    ifrm.setAttribute("width", "0");
    ifrm.setAttribute("height", "0");
    ifrm.setAttribute("src", "/Download.aspx?FileID=" + encodeURIComponent(_fileID));
    ifrm.setAttribute("frameborder", "0");

    _doc.body.appendChild(ifrm);
}

// 여러건 동시에 다운로드시 ... 2014-11-14 
//_fileID 에 다운로드할 파일id 정보를 ","로 연결해서 넘겨받음. 예) aaaa,bbbb,cccc 로 넘어오면 [aaaa파일], [bbbb파일], [cccc파일]을 동시에 다운로드함.
function MultiFileDirectDownloadByFileID(_doc, _fileID) {
    EPNotify("Please wait. The downloads preparing!(잠시만 기다리세요. 다운로드 준비중입니다.)", "System Notice");
    var arr = _fileID.split(",");
    var i = 0;
    for (i = 0; i < arr.length; i++) {
        var loader = _doc.getElementById("DirectFileDownFrame"+i.toString());
        if (loader) _doc.body.removeChild(loader);

        var fileid = arr[i];

        var ifrm = _doc.createElement("iframe");
        ifrm.setAttribute("id", "DirectFileDownFrame" + i.toString());
        ifrm.setAttribute("name", "DirectFileDownFrame" + i.toString());
        ifrm.setAttribute("style", "height:0px; width:0px; visibility:hidden")
        ifrm.setAttribute("width", "0");
        ifrm.setAttribute("height", "0");
        ifrm.setAttribute("src", "/Download.aspx?FileID=" + encodeURIComponent(fileid));
        ifrm.setAttribute("frameborder", "0");

        _doc.body.appendChild(ifrm);
    }
}


// Mobile Browser Check
var isMobileDevice = function () {
    var result = false;

    var mobileKeyWords = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson', 'Mobile', 'Symbian', 'Opera Mobi', 'Opera Mini', 'IEmobile');

    for (var i = 0; i < mobileKeyWords.length; i++) {
        if (navigator.userAgent.match(mobileKeyWords[i]) != null) {
            result = true;
            break;
        }
    }
    return result;
};

var isJavaAvailable = function () {
    var javaRegex = /(Java)(\(TM\)| Deployment)/,
      plugins = navigator.plugins;
    if (navigator && plugins) {
        for (plugin in plugins) {
            if (plugins.hasOwnProperty(plugin) && javaRegex.exec(plugins[plugin].name)) {
                return true;
            }
        }
    }
    return false;
}

// NPAPI 지원 브라우저 체크
var isNPAPI = function () {
    var agent = navigator.userAgent.toLowerCase();

    if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
        return true;                // IE 인경우
    } else {
        if (agent.indexOf("chrome") != -1) {
            var chromeVersion = window.navigator.userAgent.match(/Chrome\/(\d+)\./);
            if (chromeVersion && chromeVersion[1]) {
                if (parseInt(chromeVersion[1], 10) >= 42 && !isJavaAvailable()) {
                    return false;   // 크롬 42이상 버전에서 NPAPI 기능 사용 불가한 경우
                }
                else {
                    return true;    // 크롬 42버전이하에서 NPAPI 기능 활성화 된경우
                }
            }
            else {
                return true;        // 구형 크롬 브라우저
            }
        } else {
            return true;            // 크롬이 아닌경우 ( 사파라 / 파폭 등.. )
        }
    }
}
// 관계 싸이트 Show
var ShowRelatedSite = function (menuId, mode, login_type, login_id, login_empno, login_custcd, login_vendcd, login_url)
{
    EPNotify("Please wait. The connection of the site!(잠시만 기다리세요. 싸이트 연결중입니다.)", "System Notice");

    var doc = window.document;
    var frameName = "RelatedSite_Frame";

    // Remove Report Frame
    var oFrame = doc.getElementById(frameName);
    if (oFrame) doc.body.removeChild(oFrame);

    // Create iFrame object
    oFrame = doc.createElement("iframe");
    oFrame.setAttribute("id", frameName);
    oFrame.setAttribute("name", frameName);
    oFrame.setAttribute("style", "height:0px; width:0px; visibility:hidden");
    oFrame.setAttribute("width", "0");
    oFrame.setAttribute("height", "0");
    oFrame.setAttribute("src", "about:blank");
    oFrame.setAttribute("frameborder", "0");
    doc.body.appendChild(oFrame);

    // Open Popup
    //oFrame.contentWindow.document.write("<form name='" + frameName + "Form' action='" + login_url + "' method='post' target='_blank'><input type='hidden' id='menuId' name='menuId' value='" + menuId + "'><input type='hidden' id='mode' name='mode' value='" + mode + "'><input type='hidden' id='login_type' name='login_type' value='" + login_type + "'><input type='hidden' id='login_id' name='login_id' value='" + login_id + "'><input type='hidden' id='login_empno' name='login_empno' value='" + login_empno + "'><input type='hidden' id='login_custcd' name='login_custcd' value='" + login_custcd + "'><input type='hidden' id='login_vendcd' name='login_vendcd' value='" + login_vendcd + "'></form><script>document." + frameName + "Form.submit();<\/script>");
    //oFrame.contentWindow.document.write("<form name='" + frameName + "Form' action='" + login_url + "' method='post' target='_blank'><input type='hidden' id='menuId' name='menuId' value='MAIN00010'><input type='hidden' id='mode' name='mode' value='10'><input type='hidden' id='login_type' name='login_type' value='sso'><input type='hidden' id='login_id' name='login_id' value='" + login_id + "'><input type='hidden' id='login_empno' name='login_empno' value='" + login_empno + "'><input type='hidden' id='login_custcd' name='login_custcd' value='" + login_custcd + "'><input type='hidden' id='login_vendcd' name='login_vendcd' value='" + login_vendcd + "'></form><script>document." + frameName + "Form.submit();<\/script>");
    //oFrame.contentWindow.document.write("<form name='" + frameName + "Form' action='" + "http://sis.seoyoneh.sk/erm/services/ssopage.asp?url=" + escape(login_url + "?login_id=" + login_id) + "' method='post' target='_blank'><input type='hidden' id='menuId' name='menuId' value='MAIN00010'><input type='hidden' id='mode' name='mode' value='10'><input type='hidden' id='login_type' name='login_type' value='sso'><input type='hidden' id='login_empno' name='login_empno' value='" + login_empno + "'><input type='hidden' id='login_custcd' name='login_custcd' value='" + login_custcd + "'><input type='hidden' id='login_vendcd' name='login_vendcd' value='" + login_vendcd + "'></form><script>document." + frameName + "Form.submit();<\/script>");
    //var win = window.open("http://sis.seoyoneh.sk/erm/services/ssopage.asp?url=" + escape(login_url + "?login_id=" + login_id), '_blank');
    var win = window.open("http://sis.seoyoneh.sk/services/ssopage.asp?url=" + escape(login_url + "?login_id=" + login_id), '_blank');
    
    win.focus();
    
};

// pdf file Show (with watermark)
var ShowPdf = function (url) {
    EPNotify("Please wait. The document preparing!(잠시만 기다리세요. 문서 생성 중입니다.)", "System Notice");

    var doc = window.document;
    var frameName = "Pdf_Frame";

    // Remove Report Frame
    var oFrame = doc.getElementById(frameName);
    if (oFrame) doc.body.removeChild(oFrame);

    // Create iFrame object
    oFrame = doc.createElement("iframe");
    oFrame.setAttribute("id", frameName);
    oFrame.setAttribute("name", frameName);
    oFrame.setAttribute("style", "height:0px; width:0px; visibility:hidden");
    oFrame.setAttribute("width", "0");
    oFrame.setAttribute("height", "0");
    oFrame.setAttribute("src", "about:blank");
    oFrame.setAttribute("frameborder", "0");
    doc.body.appendChild(oFrame);

    // Open Popup
    oFrame.contentWindow.document.write("<form name='" + frameName + "Form' action='" + url + "' method='post' target='_blank'></form><script>document." + frameName + "Form.submit();<\/script>");
};


var lastReportFrame = 0;

// Report server call Function
var ShowReport = function (userId, reportUrl, header, key, value, locale, mode) {
    lastReportFrame++;

    if (lastReportFrame == 5) lastReportFrame = 0;
    // 버튼 핸들링으로 이동
    //EPNotify("잠시만 기다리세요. 출력 준비중입니다.(Please wait. The print preparing!)", "System Notice");

    var doc = window.document;
    var frameName = "RexReport30_Frame" + lastReportFrame;

    // Remove Report Frame
    var oFrame = doc.getElementById(frameName);
    if (oFrame) doc.body.removeChild(oFrame);

    // Create iFrame object
    oFrame = doc.createElement("iframe");
    oFrame.setAttribute("id", frameName);
    oFrame.setAttribute("name", frameName);
    oFrame.setAttribute("style", "height:0px; width:0px; visibility:hidden");
    oFrame.setAttribute("width", "0");
    oFrame.setAttribute("height", "0");
    oFrame.setAttribute("src", "about:blank");
    oFrame.setAttribute("frameborder", "0");
    doc.body.appendChild(oFrame);

    //mode = "PDF";

    // mode 설정값에 의해 동작이 되나 장치가 모바일 디바이스 이거나 NPAPI 지원이 불가한 브라우저면 PDF 처리
    if (isMobileDevice() || !isNPAPI()) mode = "PDF"; // 해외버전은 다음값을 무시  서버에서 무조건 PDF 로 렌저하도록 처리함 

    // mode = "PDF";
    var protocol = GetProtocol(document.location.href);
    var url = reportUrl;

    if (url.toUpperCase().indexOf("HTTPS://") >= 0) url = url.substr(8);
    if (url.toUpperCase().indexOf("HTTP://") >= 0) url = url.substr(7);

    url = protocol + url;

    // Open Popup
    oFrame.contentWindow.document.write("<form name='" + frameName + "Form' action='" + url + "' method='post'><input type='hidden' id='locale' name='locale' value='" + locale + "'><input type='hidden' id='mode' name='mode' value='" + mode + "'><input type='hidden' id='" + key + "' name='" + key + "' value='" + value + "'></form><script>document." + frameName + "Form.submit();<\/script>");
};

// Electronic Approval Call Function
var ShowApproval = function (userId, approvalUrl) {
    EPNotify("잠시만 기다리세요. 결재화면 준비중입니다.(Please wait. The approval preparing!)", "System Notice");

    var win = window.open(approvalUrl, '_blank');
    win.focus();
};

var x = new Array();
// 이미지 팝업 윈도우 핸들러 정의.  (ImageZoomPopup 를 통해서 호출됨)
var ImageZoomPopWindowHandler;
var ImageZoomPopWindow = function (_url, _id, _title, _width, _height, _src) {
    ImageZoomPopWindowHandler = new Ext.Window({
        id: _id,
        renderTo: Ext.getBody(),
        modal: true,
        layout: 'absolute',
        width: _width - 40,
        height: _height,
        title: _title,
        closable: true,
        resizable: true,
        maximizable: true,
        hidden: false,
        loader: {
            loadMask: {
                showMask: true,
                msg: "Image Loading " + _title + "..."
            },
            renderer: "frame",
            encode: true,
            autoLoad: true,
            url: _url,
            listeners: {
                load: function () {
 
                    if (top.frames[_id + "_IFrame"]) {
                        top.frames[_id + "_IFrame"].RenderImage(_src);
                    }
                }
            }
        }
    });

    return ImageZoomPopWindowHandler;
};


// 이미지 팝업 함수 정의   ( img 태그에   zoom="true" 를 설정하거나 또는 img 태그에 onclick = "ImageZoomPopup(this)" 를 지정한다. )
var ImageZoomPopup = function (sender) {
    if (sender == null || sender == "") return;
    if (sender.imageUrl) sender.src = sender.imageUrl;
    if (!sender.src) return;

    var LoaderUrl = "/ImageVIew.aspx";
    var windowID = "ImageZoom_" + (new Date()).getTime();

    var win = top.ImageZoomPopWindow(LoaderUrl, windowID, "Image Viewer (Zoom)", 850, 600, sender.src);

    // top.frames[windowID + "_IFrame"].RenderImage(sender.src);
}

// 이미지 팝업 함수 정의 ( URL 을 직접 지정 )
var ImageZoomPopupUrl = function (url) {
    if (!url) return;

    var LoaderUrl = "/ImageVIew.aspx?imgsrc=" + escape(url);
    var win = top.ImageZoomPopWindow(LoaderUrl, "ImageZoom_" + (new Date()).getTime(), "Image Viewer (Zoom)", 850, 600, null);
}

// Event Add Function
var AddListener = function (target, event, handler) {
    if (target.addEventListener)
        target.addEventListener(event, handler, false);
    else if (target.attachEvent)
        target.attachEvent("on" + event, handler);
    else
        target["on" + event] = handler;
}


/*---------------------------------------------------------------------------------------------------------------------------------------------------
1. 그리드 콤보전용 렌더러
그리드의 콤보박스에서 필수로 사용한다. (이유 : 그리드에 포함된 EDITOR에는 DISPLAYFIELD, VALUEFIELD가 정확히 매칭이 되지만 쿼리에서 가져오는 데이터는 VALUEFIELD에 맞게 가져오므로
그리드에서 VALUE만 보이게 된다. 예를 들엇 쿼리에서 1001 울산사업장을 가져오면 COMBOX에서는 정확시 매칭이 되지만 콤보박스를 감싸고 있는 COLUMN에서는 1001이 보이므로 아래의 메서드를
렌더링 함으로써 정확히 값이 보이도록 한다.
---------------------------------------------------------------------------------------------------------------------------------------------------*/
//var gridComboRenderer = function (value, meta, record, rowIndex, colIndex, store, view) {
//    var column = view.ownerCt.columns[colIndex];
//    var combo = (column.editor) ? column.editor.field : Ext.getCmp(column.field.editorId);
//    var find = combo.store.find(combo.valueField, value);

//    if (find != -1) {        
//        var comboRecord = combo.store.getAt(find);
//        return comboRecord.data[combo.displayField];
//    }
//    else {        
//        return value;
//    }
//}
// 4.X
var gridComboRenderer = function (value, meta, record, rowIndex, colIndex, store, view) {
    var column = view.ownerCt.columns[colIndex];
    var combo = (column.hasEditor()) ? column.getEditor().field : Ext.getCmp(column.getEditor().field.id);
    var find = combo.store.find(combo.valueField, value);

    if (find != -1) {
        var comboRecord = combo.store.getAt(find);
        return comboRecord.data[combo.displayField];
    }
    else {
        return value;
    }
}

/*---------------------------------------------------------------------------------------------------------------------------------------------------
그리드의 No를 자동으로 생성하는로직 (dirty시 행을 구하기 위해서 사용]
1. 만약 그리드가 Add Row, Delete Row시에 No를 새롭게 바인딩한다. 
2. 새로게 바인딩 되는 시점에서 값이 비어있다면 No컬럼의 Editor에 값을 바인딩하지 않는다. 값이 있다는 의미는 그리드 해당로의 다른 셀이 dirty가 되었다는 의미
예를 들어서 search를 한 다음 3번째row의 특정컬럼을 비움 -> No의 editor가 해당 row index(2)가 바인딩된다. 이후에 신규행을 추가하면 No는 새롭게 1,2,3~으로 바인딩 되고
Editor에 값이 비어있지 않으므로 3번째 행의 editor값이 새롭게 reder된 값인 3이 바인딩된다. -> 이후에 저장을 누르면 0행, 3행 즉, 1번째 row, 4번째 row의 값만 서버측으로 전달되고
1번째 행의 무슨컬럼이 비었습니다.가 뜬다. 그리고 1번째 행을 채우면 다시 4번째 행의 무슨컬럼이 비었습니다. 라고 메시지가 정확히 뜬다.
---------------------------------------------------------------------------------------------------------------------------------------------------*/
var rendererNo = function (value, meta, record, rowIndex, colIndex, store, view) {
    var grid = view.ownerCt;
    var rowIndex2 = rowIndex;

    if (rowIndex2 == null || rowIndex2 == '') rowIndex2 = 0;

    grid.getStore().getAt(rowIndex2).data["NO"] = rowIndex2 + 1;

    return rowIndex2 + 1;
}

// 화면 grid의 cell을 style을 변경해준다.
var renderBlueColor = function (value, meta, record, rowIndex) {
    meta.tdAttr += 'style="color:blue;"';
    return value;
}

// 화면 grid의 cell을 style을 변경해준다.
var renderRedColor = function (value, meta, record, rowIndex) {
    meta.tdAttr += 'style="color:red;"';
    return value;
}

// 화면 grid의 cell을 style을 변경해준다.
var renderGreenColor = function (value, meta, record, rowIndex) {
    meta.tdAttr += 'style="color:green;"';
    return value;
}


/*---------------------------------------------------------------------------------------------------------------------------------------------------
// checkbox에서 전체선택을 위해서 헤더에 checkbox삽입시 사용 (정확히는 잘 모르겠음)
---------------------------------------------------------------------------------------------------------------------------------------------------*/
var selectionCheckInitalize = function (e, t) {
    var ownerHeaderCt = this.getOwnerHeaderCt();

    if (ownerHeaderCt && !ownerHeaderCt.ddLock) {
        if (this.triggerEl && (e.target === this.triggerEl.dom || t === this.triggerEl.dom || e.within(this.triggerEl))) {
            ownerHeaderCt.onHeaderTriggerClick(this, e, t);
        } else {
            if (e.getKey() || (!this.isOnLeftEdge(e) && !this.isOnRightEdge(e))) {
                if (!Ext.fly(t).hasCls("my-header-checkbox")) {
                    this.toggleSortState();
                }
                ownerHeaderCt.onSelectionCheckHeaderChange(this, e, t);
            }
        }
    }
};


var onSelectionCheckHeaderChange = function (ct, column, e, t) {
    
    if (Ext.fly(t).hasCls("my-header-checkbox")) {
        var grid = ct.ownerCt;
        
        for (i = 0; i < grid.store.count(); i++) {
            grid.store.getAt(i).data["NO"] = i + 1;
            grid.store.getAt(i).data["CHECK_VALUE"] = t.checked;
            grid.store.getAt(i).dirty = t.checked;
        }
        grid.view.refresh();
    }
};

/*---------------------------------------------------------------------------------------------------------------------------------------------------
checkbox column이용시에 체크를 intercept하기 위해서 사용한다.
1. 예) 체크박스 클릭시 특정 textbox에 값이 있어야만 할 경우에 여기서 textbox를 먼저 확인하고 값이 없으면 check가 되지 않도록 할 수있다
2. checkcolum에서 listener를 달아서 사용한다.
---------------------------------------------------------------------------------------------------------------------------------------------------*/

var onSelectionCheckContentChange = function (column, rowIndex, record, checked) {
    
    var header_check = document.getElementById('my-header-checkbox');
    var grid = column.grid;

    var flag = true;
    for (i = 0; i < grid.store.count(); i++) {
        if (grid.store.getAt(i).data[column.dataIndex] == false) {
            flag = false;
            break;
        }
    }

    if (header_check) header_check.checked = flag;
}

// EXT Override Function 은 여기에 넣어야 함
//var ExtOverrideCustom = function () {
    //음수값인 경우 Format이 제대로 안먹히는 문제가 있음. override해서 "-"를 앞에 붙여줌.
    //IE7,8 에서 ISO8601 타입이 지원안되는 문제 해결
Ext.define('SRM.util.Format', {
    override: 'Ext.util.Format',
    originalNumberFormatter: Ext.util.Format.number,
    number: function (v, formatString) {

        if (v < 0) {
            return '-' + this.originalNumberFormatter(v * -1, formatString);
        } else {
            return this.originalNumberFormatter(v, formatString);
        }
    },
    //    override: 'Ext.util.Format', 
    originalDateFormatter: Ext.util.Format.date,
    date: function (v, formatString) {
        // 	  크롬 IE 동일하게 적용
        //        if (Ext.isIE && !Ext.isDate(v)) {
        //            if (v && v.toString().indexOf('T')>-1) {
        //v = Ext.Date.parse(v, 'Y-m-dTH:i:s.u');
        //v = parseISO8601(v.toString());
        //	      }
        //	  }	

        if (v == null || v == "" || v == NaN) {
            return "";
        }
        else {
            v = parseISO8601(v.toString());
            v = new Date(Date.parse(v));

            return this.originalDateFormatter(v, formatString);
        }
    },
});

// -//2019.03.27 변경 날짜 포맷 변경 
Ext.override(Ext.grid.column.Date, {
    constructor: function () {
        this.format = Ext.Date.defaultFormat;
        this.callOverridden(arguments);
    }
});

//}

// Ext Document Ready 시 Search 버튼에 대한 추적기 가동
var ExtDocumentReady = function () {
    // Image Zoom 기능 Attach ( for ( obj in  array ) 가 안먹어서 그냥 count 만큼
    for (var i = 0; i < document.getElementsByTagName("img").length; i++) {
        var imgObj = document.getElementsByTagName("img")[i];

        // 이미지 태그에 Zoom 속성값이 true 일 경우 팝업창 자동 연계   .. 2014.07.14 김건우
        if (imgObj.attributes['zoom'])
            if (imgObj.attributes['zoom'].value.toLowerCase() == "true")
                AddListener(imgObj, "click", (function anonymous() { ImageZoomPopup(this); }));
    }

    // Google Trancking Service Attach
    var obj;

    //obj = Ext.get("ButtonSearch");
    //if (obj) { }

    try {
        if (Ext != null) {
            obj = Ext.get("ButtonExcel");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The downloads preparing!(잠시만 기다리세요. 다운로드 준비중입니다.)", "System Notice"); })); }

            obj = Ext.get("ButtonExcelDL");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The downloads preparing!(잠시만 기다리세요. 다운로드 준비중입니다.)", "System Notice"); })); }

            obj = Ext.get("ButtonPrint");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The print preparing!(잠시만 기다리세요. 출력 준비중입니다.)", "System Notice"); })); }

            obj = Ext.get("btn01_PRINT_REPORT");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The print preparing!(잠시만 기다리세요. 출력 준비중입니다.)", "System Notice"); })); }

            obj = Ext.get("btn01_BLANK_REPORT");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The print preparing!(잠시만 기다리세요. 출력 준비중입니다.)", "System Notice"); })); }


            obj = Ext.get("btn01_PRINT_SUMMARY");
            if (obj) { obj.on('click', (function () { EPNotify("Please wait. The print preparing!(잠시만 기다리세요. 출력 준비중입니다.)", "System Notice"); })); }
        }

        // UI_Shown 을 호출하고 팝업공지가 있으면 Notice_Shown 을 호출한다.
        //if (ExtOverrideCustom) ExtOverrideCustom();
        if (UI_Shown) UI_Shown();
        if (Notice_Shown) Notice_Shown();
    }
    catch (exception) { }
    finally { }
};


// parseISO8601 표준 포맷 적용 ( IE7,8 에서 Date 형 Parsing 시 문제 해결 )
function parseISO8601(dateStringInRange) {
    var isoExp = /^\s*(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)\s*$/,
        date = new Date(NaN), month,
        parts = isoExp.exec(dateStringInRange);

    if (parts) {
        month = +parts[2];
        date.setFullYear(parts[1], month - 1, parts[3]);

        if (parts[4]) date.setHours(parts[4]);
        if (parts[5]) date.setMinutes(parts[5]);
        if (parts[6]) date.setSeconds(parts[6]);

        if (month != date.getMonth() + 1) {
            date.setTime(NaN);
        }
    }
    else {
        isoExp = /^\s*(\d{4})-(\d\d)-(\d\d)\s*$/,
	date = new Date(NaN), month,
        parts = isoExp.exec(dateStringInRange);

        if (parts) {
            month = +parts[2];
            date.setFullYear(parts[1], month - 1, parts[3]);
        }
        else {
            isoExp = /^\s*(\d{4})-(\d\d)\s*$/,
	    date = new Date(NaN), month,
            parts = isoExp.exec(dateStringInRange);

            if (parts) {
                month = +parts[2];
                date.setFullYear(parts[1], month - 1, 1);
            }
            else {
                isoExp = /^\s*(\d\d)-(\d\d)\s*$/,
	        date = new Date(NaN), month,
                parts = isoExp.exec(dateStringInRange);

                if (parts) {
                    month = +parts[1];
                    date.setFullYear((new Date()).getFullYear(), month - 1, parts[2]);
                }
                else {
                    date = new Date(Date.parse(dateStringInRange));
                }
            }
        }
    }

    return date.toString();
}

// Program Tab Add 
var addUserTab = function (pgmID, pgmUrl, prm) {

    if (pgmUrl == "") {
        EPAlert("Not exists program [" + pgmID + " ].", "Error");
        return;
    }

    var tabPanel = top.App.TabPanel1;

    if (tabPanel) {
        var tab = tabPanel.getComponent(pgmID);

        if (typeof (tab) == "object") tabPanel.closeTab(tab);  // 이미 열려있으면 닫고 다시 연다.
        if (tabPanel.items.length > 10) tabPanel.closeTab(tabPanel.getComponent(1));   // 가장 오래된 창 Close

        // 아래 프로그램은 단순 링크로 동작하도록 한다.(프로그램 ID 가 L 로 끝날때) ( 예외처리 )
        if (pgmID.substr(pgmID.length - 1, 1) == "L")
            top.OpenLink(pgmUrl);
        else
            top.App.direct.MakeTap2(pgmID, pgmUrl, "2", prm);
    }
    else {
        //새창 뜨기 코드 넣을것.
        window.open("/" + pgmUrl + prm, pgmID);
    }
}

// Grid Store Ready common action
var GridStoreReady = function (gridStatus, rowCount) {
    // 그리드 상태 표시줄 처리
    if (gridStatus) gridStatus.setText(rowCount + ' Records To Display...');

    // 그리드 스토에중에 입력그리드에서 체크박스가 있을경우 값을 강제로 해제하는 처리
    var allCheckBox = document.getElementById('my-header-checkbox');
    if (allCheckBox) document.getElementById('my-header-checkbox').checked = false;
}

// 코드박스 엔터키 핸들러 공용으로 재정의 ( 단, 입력/조회만  그리드는 기존대로 동일 )
var CodeBox_PopupHandler = function (editor, e) {
    if (e.getKey() === e.ENTER) {
        var ctlID = editor.id;
        var btnHelper = Ext.getCmp(ctlID.substr(0, ctlID.length - 6) + "HELPER");
        btnHelper.fireEvent('click');
    }
}

// Codebox Set value 코드박스 값 처리용 ( 그리드는 각 페이지 fn_GridSetValues 를 별로 적용해야함 )
var fn_SetValues = function (popupID, objectID, typeNM, typeCD, record) {
    var CtlPopup = Ext.getCmp(popupID);
    CtlPopup.hide();

    if (popupID.substr(0, 4).toUpperCase() == "GRID") {
        if (fn_GridSetValues)
            fn_GridSetValues(popupID, objectID, typeNM, typeCD, record);
        else
            EPAlert('Not defined function \'fn_GridSetValues\'! (\'fn_GridSetValues\'이 정의되지 않았습니다!)', 'Warning');
    }
    else {
        // CodeBox 컨트롤을 찾아온다.
        var CtlObjectID = Ext.getCmp(popupID + "_OBJECTID");
        var CtlTypeCD = Ext.getCmp(popupID + "_TYPECD");
        var CtlTypeNM = Ext.getCmp(popupID + "_TYPENM");

        // 유형코드가 아닐대는 typeCD 가 없으므로 objectID 값을 그대로 typeCD 에 담아 준다.
        if (!typeCD || typeCD == "") typeCD = objectID;

        // 선택된 값을 코드박스에 담아 준다.
        CtlTypeCD.setValue(typeCD);         // 화면에 보여지는 코드를 제일 먼저 담는다 ( 순서중요 )
        CtlTypeNM.setValue(typeNM);
        CtlObjectID.setValue(objectID);

        // 기본값 왜에 다른값을 더 가져오려 한다면 해당페이지에 fn_UserSetValues Function 을 이용하여 record 로 부터 값을 가져가서 처리할 수 있다.
        if (fn_UserSetValues) fn_UserSetValues(popupID, objectID, typeNM, typeCD, record);
    }
};


/*  Base64 Encode & Decode 용 base64Key string */
var base64keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

// Base64 Encode English / Korean is base64EncodeHan 사용
function base64Encode(input) {
    var output = "";
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;

    do {
        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }

        output = output + base64keyStr.charAt(enc1) + base64keyStr.charAt(enc2) +
        base64keyStr.charAt(enc3) + base64keyStr.charAt(enc4);
    } while (i < input.length);

    return output;
}

// Base64 Decode english / korea is base64DecodeHan to use
function base64Decode(input) {
    var output = "";
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;

    // remove all characters that are not A-Z, a-z, 0-9, +, /, or = 
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
    do {
        enc1 = base64keyStr.indexOf(input.charAt(i++));
        enc2 = base64keyStr.indexOf(input.charAt(i++));
        enc3 = base64keyStr.indexOf(input.charAt(i++));
        enc4 = base64keyStr.indexOf(input.charAt(i++));

        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;

        output = output + String.fromCharCode(chr1);

        if (enc3 != 64) {
            output = output + String.fromCharCode(chr2);
        }

        if (enc4 != 64) {
            output = output + String.fromCharCode(chr3);
        }
    } while (i < input.length);

    return output;
}

// Base64 Encode Korean
function base64EncodeHan(str) {
    return base64Encode(escape(str))
}

// Base64 Decode Korean
function base64DecodeHan(str) {
    return unescape(base64Decode(str))
} 

// 날짜 차이 계산 함수
// date1 : 기준 날짜(YYYY-MM-DD), date2 : 대상 날짜(YYYY-MM-DD)
function getDateDiff(date1, date2) {

    var arrDate1 = date1.split("-");
    var getDate1 = new Date(Number(arrDate1[0]), Number(arrDate1[1]) - 1, Number(arrDate1[2]));

    var arrDate2 = date2.split("-");
    var getDate2 = new Date(Number(arrDate2[0]), Number(arrDate2[1]) - 1, Number(arrDate2[2]));

    var getDiffTime = getDate1.getTime() - getDate2.getTime();

    return Math.floor(getDiffTime / (1000 * 60 * 60 * 24));
}

//공지사항인 경우에만 사용하세요. (중요하지 않는 데이터인 경우) 실제 업무데이터에서는 사용하지 말것!!!
function getEPTimeStamp() {
    var d = new Date();
    var s =
            leadingZeros(d.getFullYear(), 4) + '-' +
            leadingZeros(d.getMonth() + 1, 2) + '-' +
            leadingZeros(d.getDate(), 2);

    return s;
}
function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (i = 0; i < digits - n.length; i++)
            zero += '0';
    }
    return zero + n;
}


//편집불가 컬럼을 ctrl+c 하기 위한 로직임.(ie인 경우에만)
function copyToClipboard(grid) {
    
    //selectionModel 이 "cellmodel"인 경우에만 이 로직 사용함. (셀 선택시에만 복사기능 사용)
    if (grid.getSelectionModel().selType != "cellmodel")
        return;

    //해당 컬럼이 편집되는 컬럼이면 그냥 종료.
    if (grid.getSelectionModel().view.editingPlugin != null &&
        grid.getSelectionModel().view.editingPlugin.activeEditor != null)
        return;
//    if (grid.getSelectionModel().getCurrentPosition().columnHeader.hasEditor())
//        return;
    
    if (Ext.isIE) {
        //ie인 경우에만 적용.
        var col_field = grid.getSelectionModel().getCurrentPosition().columnHeader.dataIndex;
        var val = grid.getSelectionModel().selected.items[0].data[col_field];
        //alert("col : " + col_field + ", val = " + val);
        window.clipboardData.setData("Text", val.toString());
    }
}
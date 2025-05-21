/// <refe222rence path="./Common.js" />

// noticePopup('1,2,3,4,5', '600', '605', '10', '200');
//팝업관련


var noticePopup_Array = new Array();

// 공지사항 자동 팜업용
function noticePopup(notice_seq, corcd, size_width, size_height, position_width, position_height) {
    var arr = notice_seq.split(",");
    var arr2 = corcd.split(",");
    var LeftPosition = (screen.width) ? (screen.width - size_width) / 2 : 0;
    var TopPosition = (screen.height) ? (screen.height - size_height) / 2 : 0;

    // 만약 IE 6 이라면 강제 팝업 안뒤움
    if (navigator.appVersion.indexOf("MSIE 6") > -1)
        return;

    noticePopup_Array = new Array();

    for (var i = 0; i < arr.length; i++)//배열로 담은것을 출력
    {
        // 쿠키가 done 이면 표시안함
        if (getCookie("p_" + arr[i]) != "done") noticePopup_Array[i] = arr[i] + "|" + arr2[i] + "|" + size_width + "|" + size_height;
    }

    try {
        // 팝업창 로드 ( Notice_Shown 을 Override 한다. )
        Notice_Shown = function anonymous() {
            for (var i = 0; i < noticePopup_Array.length; i++) {
                if (noticePopup_Array[i]) {
                    var arr = noticePopup_Array[i].split("|");
                    noticePopupWindowHandle(arr[0], arr[1], Number(arr[2]), Number(arr[3]));
                }
            }
        }
    }
    catch (exception) {
    }
    finally {
    }
}

// 팝업창 핸들러
function noticePopupWindowHandle(winid, corcd, size_width, size_height) {
    var wint1 = new Ext.Window({
        id: "Popup_chk_" + winid,
        nid: winid,
        renderTo: Ext.getBody(),
        modal: true,
        layout: 'absolute',
        width: size_width,
        height: size_height,
        title: "Notice",
        closable: true,
        minimizable: false,
        resizable: true,
        maximizable: true,
        hidden: false,
        loader: {
            loadMask: {
                showMask: true,
                msg: "Loading……"
            },
            scroll: false,
            encode: true,
            autoLoad: true,
            renderer: "frame",
            url: "../../Home/EPAdmin/EP_XM23001P2.aspx?param1=" + winid + "&param2=" + corcd
        },
        listeners: {
            hide: function (a) {
                if (frames[this.id + "_IFrame"]) {
                    // 팝업창이 닫힐때 체크가 되어 있으면 쿠키 쓰기 (단 하루)
                    var objDayShow = frames[this.id + "_IFrame"].Ext.getCmp('chkDayShow');
                    var objShow = frames[this.id + "_IFrame"].Ext.getCmp('chkShow');

                    if (objDayShow) {
                        if (objDayShow.getValue()) setCookie("p_" + this.nid, "done", 1);
                    };
                    // 팝업창이 닫힐때 체크가 되어 있으면 쿠키 쓰기 (영원히)
                    if (objShow) {
                        if (objShow.getValue()) setCookie("p_" + this.nid, "done", 1000000);
                    };
                }
            }
        }
    });
}

/**
* 쿠키 설정
* @param name 설정 쿠키명
* @param value 값
* @param expiredays 유효날짜
*/
function setCookie(name, value, expiredays) {
    var todayDate = new Date();
    todayDate.setDate(todayDate.getDate() + expiredays);
    document.cookie = name + "=" + escape(value) + "; path=/; expires=" +
	   todayDate.toGMTString() + ";";
}

function closeWin(id) {
    setCookie("p_" + id, "done", 1);
    self.close();
}

function getCookie(name) {
    var nameOfCookie = name + "=";
    var x = 0;
    while (x <= document.cookie.length) {
        var y = (x + nameOfCookie.length);        
        if (document.cookie.substring(x, y) == nameOfCookie) {
            if ((endOfCookie = document.cookie.indexOf(";", y)) == -1)
                endOfCookie = document.cookie.length;
            return unescape(document.cookie.substring(y, endOfCookie));
        }
        x = document.cookie.indexOf(" ", x) + 1;
        if (x == 0)
            break;
    }
    return "";
}

/**
* 쿠키 삭제
* @param cookieName 삭제할 쿠키명
*/
function deleteCookie(cookieName) {
    var expireDate = new Date();

    //어제 날짜를 쿠키 소멸 날짜로 설정한다.
    expireDate.setDate(expireDate.getDate() - 1);
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
}





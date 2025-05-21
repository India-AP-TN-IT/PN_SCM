<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPMain.aspx.cs"  Inherits="Ax.EP.WP.Home.EPBase.EPMain"  EnableViewStateMac="False"  %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
<meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
<meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />
<head id="Head1">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
    <meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />

    <title><%=Ax.EP.Utility.EPAppSection.ToString("TITLE") %> (<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_REGION") %>)</title>

    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Style" />
    <ext:ResourcePlaceHolder ID="ResourcePlaceHolder2" runat="server" Mode="Script" />

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <!--
    <link rel="shortcut icon" type="image/x-icon" sizes="128x128" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="64x64" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="32x32" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="24x24" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="16x16" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    -->

    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        var sCtl = "";

        // teebarcode control
        sCtl += "<object id='axTBarCode5'  classid='CLSID:10ED9AE3-DA1A-461C-826A-CD9C850C58E2' CODEBASE='../../files/cab/TBarCode5.cab#version=5,3,0,49' type='application/x-oleobject' style='display: none'></object>";
        // teebarcode control 10
        //sCtl += "<object id='axTBarCode10'  classid='CLSID:FEF2D6AE-79C4-497C-8D69-4E0F45FCFBC5' CODEBASE='../../files/cab/TBarCode10.cab#version=10,2,2,13543' type='application/x-oleobject' style='display: none'></object>";

        document.write(sCtl);  // TBarCode 사용 ( 2D 바코드 )

        // 2017.11.14 사용안함  ( 그룹웨어 AEO 게시판으로 이동 )
        //window.open('../../files/notice/Noti20130930.htm', 'noti20130930p', 'scrollbars=yes,toolbar=yes,resizable=yes,width=800,height=600,left=0,top=0').focus();
    </script>
    <script type="text/javascript">
        //        var successFlag = false;    // 호환성 모드 처리용



        var addTab = function (tabPanel, record, userId, type, prm) {
            if (userId == '') { logoutHandler(); return; }
            var tab = tabPanel.getComponent(record.getId());

            if (typeof (tab) == "object") {
                tabPanel.setActiveTab(tab);
                return;
                //tabPanel.closeTab(tab);  // 이미 열려있으면 닫고 다시 연다.
            }

            if (tabPanel.items.length > 9) { // Main탭이르 제외한 9개이상 초과시 
                tabPanel.closeTab(tabPanel.getComponent(1));   // 가장 오래된 창 Close
                //App.direct.MsgCodeAlert("MSG-00009");     // 더이상열수 없다는 메세지 표시 
                //return;
            }

            // 아래 프로그램은 단순 링크로 동작하도록 한다.(프로그램 ID 가 L 로 끝날때) ( 예외처리 )
            if (record.getId().substr(record.getId().length - 1, 1) == "L")
                OpenLink(record.data.href);
            else
                App.direct.MakeTap2(record.getId(), record.data.href, type, prm);
        }

        // 탭속의 버튼에서 클릭을 했을 경우
        var deleteTabFromChild = function () {
            var tabPanel = App.TabPanel1;
            var tab = tabPanel.getComponent(tabPanel.getActiveTab().id);
            if (typeof (tab) == "object" && tab.closable) {
                tabPanel.closeTab(tab);
                tab.close();
                return;
            }
        }

        function goMain() {
            location.href = '<%=Ax.EP.Utility.EPAppSection.ToString("MAIN_PAGE_ID") %>.aspx';
        }

        var searchExecuted = function () {
            window.scrollTo(0, 0); // 상위로
        }

        var hideMenu = function (menu) {
            menu.hide();
        }

        function hideMenu(e, t) {
            if (!e.within(this.ul)) {
                this.hide();
            }
        }
        var ttt, nnn;
        var refreshTree = function (tree, groupcd, title) {
            App.GroupCd.setValue(groupcd);
            App.PgmTitle.setValue(title);

            App.direct.RefreshMenu({
                success: function (result) {

                    var nodes = eval(result);
                    if (nodes.length > 0) {
                        //tree.initChildren(nodes);     // Ext v1.x
                        tree.setRootNode(nodes[0]);     // Ext v2.x 에서는 initChildren 이 삭제됨 ( setRootNode 를 대체사용 )
                        tree.expandAll();               // Ext v3~v4에서는 expaned 해주어야함.
                    }
                    else {
                        if (tree) tree.getRootNode().removeChildren();
                    }
                }
            });
        }

        var firstNodeExpand = function (tree) {
            if (tree.getRootNode() != null && tree.getRootNode().childNodes.length > 0) {
                var node = tree.getRootNode().childNodes[0];

                for (i = node.childNodes.length - 1; i >= 0; i--) {
                    node.childNodes[i].collapse();
                }
            }
        }

        function OpenLink(href) {
            var addr = "http://" + href.replace("http://", "").replace("https://", "");
            var win = window.open(addr);
        }

        function UI_Shown() {
            // 정상로드일경우 호환성 모드 리로드 설정을 해제한다.
            //            successFlag = true;         
            //            document.getElementById("PreepairMsg").style.display = "none";

            // 메뉴 재호출
            this.refreshTree(App.TreePanel1, App.GroupCd.getValue(), App.PgmTitle.getValue());

            // 김영훈 대리 요청 2013년 09월 30일 김건우 대리 수정
            // 무한로딩 문제가 있어서 아래로 이동함
            //var noti20130930 = window.open('../../files/notice/Noti20130930.htm', 'noti20130930p', 'scrollbars=yes,toolbar=yes,resizable=yes,width=800,height=600,left=0,top=0');
            //if (noti20130930) noti20130930.focus();
        }

        // 호환성 모드 처리용 페이지 리로드
        //        function reLoad() { if (!successFlag) document.location.reload(); }
        //        function reMsg() { if (!successFlag) document.getElementById("PreepairMsg").style.display = "block"; setTimeout(reLoad, 3000); }

        // 호환성 모드일경우 3초후 페이지 리로드 처리
        //        setTimeout(reMsg, 500);

    </script>
    <style type="text/css">
        @import url(//fonts.googleapis.com/earlyaccess/nanumgothic.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>);
        /* 왼쪽메뉴 */        
        .x-panel-header-default { background:#0056b6;}        
        .x-title-item{font-size:13px;color:White;} /*4.X추가*/
        .x-tool-collapse-left   {background:url(../../images/main/arrow_left.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;}        
        .x-tool-over .x-tool-img {filter: alpha(opacity=100);opacity: 100;}
        .x-tool .x-tool-img {filter: alpha(opacity=100);opacity: 100;}
        .x-panel-header-default .x-tool-img {background-color:#0056b6;}                
        .x-tool-expand-right    {background:url(../../images/main/arrow_right.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;}        
        .x-tool-collapse-bottom {background:url(../../images/main/arrow_bottom.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;}
        .x-tool-expand-top    {background:url(../../images/main/arrow_top.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;}
        /* 4.X x-btn-default-small-icon-text-left -> x-btn-default-small */
        .x-noborder-trbl{background:white !important;} /*4.X추가*/
        
        /* 대메뉴 확정성을 위해 개별 스타일이 아닌 공통으로 먹임 */
        .x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        .x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}/*4.X padding-left변경*/        
        .x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        .x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        .x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        /*
        a#SRM_VM.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_VM.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}
        a#SRM_VM.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_VM.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_VM.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#SRM_MM.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_MM.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}
        a#SRM_MM.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_MM.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_MM.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#SRM_QA.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_QA.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#SRM_QA.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_QA.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_QA.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#SRM_MP.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_MP.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#SRM_MP.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_MP.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_MP.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#SRM_SD.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_SD.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#SRM_SD.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_SD.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_SD.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#SRM_ALC.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#SRM_ALC.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#SRM_ALC.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_ALC.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#SRM_ALC.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#EP_XM.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#EP_XM.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#EP_XM.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#EP_XM.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#EP_XM.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}

        a#EP.x-btn-default-small {height: 30px !important;-webkit-border-radius: 0;-moz-border-radius: 0;-ms-border-radius: 0;-o-border-radius: 0;padding: 0px 0px 0px 5px !important;border-width: 0;border-style: solid;border-bottom:1px solid #838383 !important;background:url(../../images/common/leftmenu_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}        
        a#EP.x-btn-default-small .x-btn-inner {line-height: 16px;padding-left: 4px; color:#3a3b45;}        
        a#EP.x-btn-default-small:hover {height: 30px !important; background: url(../../images/common/leftmenu_bg2.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#EP.x-btn-default-small:focus {height: 30px !important; background: url(../../images/common/leftmenu_bg3.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) left top repeat-x !important;}
        a#EP.x-btn-default-small:focus .x-btn-inner  { color:#fff !important;}
        */
        
        /*.x-btn-default-small {border-color: #126daf; padding-left:5px !important;}        */

                
        /* 익스 8  LEFTMENU */ 
        .x-frame-tl { background:none !important;}
        .x-frame-ml { background:none !important;}
        .x-frame-bl { background:none !important;}
        .x-frame-tr { background:none !important;}
        .x-frame-mr { background:none !important;}
        .x-frame-br { background:none !important;}
        .x-frame-tc { background:none !important;}
        .x-frame-bc { background:none !important;}
        .x-frame-mc { background:none !important;}
        .x-nbr .x-btn-default-small { border-bottom:1px solid #838383 !important;}        
        .mainMenuIcon   {background-size:16px 16px;}
        .x-btn-default-small-icon-text-left .x-btn-icon-el  { width:30px !important;}
        
        /* 익스8 TAB */
       
        .x-tab-tl   {background:url(../../images/common/tab_tl_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-tc   {background:url(../../images/common/tab_tc_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}
        .x-tab-tr   {background:url(../../images/common/tab_tr_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-ml   { background:url(../../images/common/tab_ml_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-mc   { background:url(../../images/common/tab_mc_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}
        .x-tab-mr   { background:url(../../images/common/tab_mr_off.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}       
        
        
        .x-tab-default-active-tl{background:url(../../images/common/tab_tl.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-default-active-tc{background:url(../../images/common/tab_tc.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}
        .x-tab-default-active-tr{background:url(../../images/common/tab_tr.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-default-active-ml{ background:url(../../images/common/tab_ml.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        .x-tab-default-active-mc{ background:url(../../images/common/tab_mc.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;}
        .x-tab-default-active-mr{ background:url(../../images/common/tab_mr.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat !important;}
        
        
        /* 탭 */
        .x-tab-bar-default  {  background:#fff; padding-top:4px;}
        .x-tab-bar-strip {top: 29px !important;}        
        .x-tab-bar-strip-default {border-width: 0;border-style: solid;border-color:#0056b6;background-color: #0056b6;height:1px  !important;}                        
        .x-tab-bar .x-tab-bar-body .x-box-inner .x-tab{z-index:500;}
        .x-tab-bar-body-default {padding-bottom: 0 !important;}
        .x-tab.x-tab-active.x-tab-default .x-tab-inner-default{color:Black;}
        
        .x-tab-default .x-tab-inner {color: #a1a1a1; font-weight:normal !important; line-height:13px !important; }

        .x-tab-wrap {text-align:center; }
        .x-tab-active .x-tab-default .x-tab-inner-default{font-weight:bold !important;}
        
        .x-tab-bar .x-tab-bar-body .x-box-inner .x-tab {height: 27px !important;}
         a.x-tab {text-decoration: none;}
        .x-tab-default-top-active, .x-tab-default-left-active, .x-tab-default-right-active {border-bottom: 0 solid #0056b6 !important;}
        .x-tab-active{border-bottom: 0 solid #0056b6 !important;}
        .x-tab-active {background:url(../../images/common/tab_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) repeat-x !important;} /*4.X x-tab-default-active =>x-tab-active */
        /*.x-tab-default-active .x-tab-inner { color:#231f20; font-weight:bold !important;}*/
        .x-tab-active .x-tab-inner{ color:#231f20; font-weight:bold !important;}
        /*.x-tab-inner .x-tab-inner-default{ color:black !important;}*/
        
        .x-tab-bar-default-top .x-box-scroller-tab-bar-default{margin-top:-24px !important;}
        
        .x-tab-inner-center { color:#000;}
        .x-tab-default-top, .x-tab-default-left, .x-tab-default-right {border-bottom: 0 solid #157fcc;}
        .x-tab-default {border-color: #838383 !important;margin: 0 0 0 3px;cursor: pointer;}
        .x-tab-default-top {-moz-border-radius-topleft: 3px;
                            -webkit-border-top-left-radius: 3px;
                            border-top-left-radius: 3px;
                            -moz-border-radius-topright: 3px;
                            -webkit-border-top-right-radius: 3px;
                            border-top-right-radius: 3px;
                            -moz-border-radius-bottomright: 0;
                            -webkit-border-bottom-right-radius: 0;
                            border-bottom-right-radius: 0;
                            -moz-border-radius-bottomleft: 0;
                            -webkit-border-bottom-left-radius: 0;
                            border-bottom-left-radius: 0;
                            padding: 7px 12px 7px 12px !important;
                            border-width: 0;
                            border-style: solid;
                            background-color:#e3e3e3;                                                        
                            border-bottom:2px solid #0056b6 !important;                            
                            border-left:1px solid #b1b1b1 !important;
                            border-right:1px solid #b1b1b1 !important;
                            border-top:1px solid #b1b1b1 !important;
                            
                            }
        .x-tab-active {z-index: 3; border:1px solid #0056b6 !important;}
        .x-tab {display: block;white-space: nowrap;z-index: 1;}
        .x-box-item {position: absolute!important;left: 0;top: 0;}
        
        .x-tab-default .x-tab-close-btn {width: 15px;height: 22px; background:url(../../images/common/tab_btn_close2.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat right 7px !important;}
        .x-tab-default .x-tab-close-btn-over {width: 15px;height: 22px; background:url(../../images/common/tab_btn_close.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat right 7px !important;}
        .x-tab-close-btn {position: absolute;font-size: 0;line-height: 0;background: no-repeat;}
        .x-tab-default:hover{background-color:#e3e3e3 !important}

        .x-box-scroller-tab-bar-default.x-box-scroller-right{float:right;background:url(../../images/common/tab_right_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;top:-2px;left:-24px;height:25px !important;}
        .x-box-scroller-tab-bar-default.x-box-scroller-left{float:left;background:url(../../images/common/tab_left_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;top:24px;height:25px !important;}        
        .x-tab-tabmenu-right {background:url(../../images/common/tab_bottom_bg.gif?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) no-repeat;width: 25px;top:4px !important;right:18px !important;height:25px !important;cursor: pointer;zoom: 1; z-index: 6;float: right;top:5px;}                        
     

        /* 세로 바 */
        /* .splitter_config {border-left: 1px solid #888888; border-right: 1px solid #888888; background:#fff; border-top:0; border-bottom:0;} */
        .splitter_config {border-left: 1px solid #888888; border-right:0; background:#fff; border-top:0; border-bottom:0; width:1px !important}
        .x-splitter-vertical {cursor: e-resize;cursor: col-resize;}
        .x-splitter {font-size: 1px;}       
                
        /* 푸터 */
        .mainFooter {clear: both;background: #ccc;height: 30px;width: 100%;border: none; font-family:"나눔고딕","Nanum Gothic","돋움",Dotum,Arial,Verdana,Geneva,"sans-serif";}
        
        #lbl_LANG_<%=this.UserInfo.LanguageShort%> .x-label-value { color:gold; }
        /*.x-btn-inner  { Color:black !important; font-weight:normal !important; }*/         
        
        /* 신규 아이콘 */
        
        .icon-folderhome { background-image:url(../../images/icon/tree_icon1.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) !important; }
        .icon-foldertable { background-image:url(../../images/icon/tree_icon2.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) !important; }
        .icon-layout { background-image:url(../../images/icon/tree_icon3.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) !important; }
        
        /*
         .x-btn-default-small-icon-text-left .x-btn-inner { color:White; }
         .x-btn-default-small-icon-text-left { background:null;:;}
         */
         
         .x-title-item{font-family:Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif; font-size:12px;}
         
        .x-grid-item-over .x-grid-td {border-top-width:0px;  border-bottom-width:0px;/* over 시 하단라인색 */ }                                            
        .x-grid-item-selected .x-grid-td {border-top-width:0px;  border-bottom-width:0px;/* over 시 하단라인색 */ }                                                       
        #cboRelatedSites-triggerWrap
        {
            height: 22px !important;
        }
        #cboRelatedSites-inputEl
        {
            height: 20px !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
<%--    <div id="PreepairMsg" style="padding-top:100px;width:100%; text-align:center; font-size:12px; color:blue; display:none;">
         <div style="color:Red;">The message is displayed only for PC compatibility mode. <br/>Wait a second! The restart page.</div><br/><br/>If you do not wish us to turn off compatibility mode in the browser.<br/><br/><hr/><br/>
	 <div style="color:Red;">호환성 모드 설정 PC 에서만 표시되는 메세지 입니다.<br/>잠시만 기다리세요. 페이지가 재시작됩니다.</div><br/><br/>원치않으시면 브라우저에서 호환성 모드를 해제하여 주시기 바랍니다.<br /><br/><br/><br/>
	 <input type="button" value=" Page reload, now! (바로 재시작 하기) " onclick="reLoad();" style="background:#157fcc; border:0; color:#ffffff; padding:10px; font-size:12px;" />
    </div>--%>
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="GroupCd" Hidden="true" runat="server" />
    <ext:TextField ID="PgmTitle" Hidden="true" runat="server" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout">
        <Items>
            <ext:Panel ID="Panel1" runat="server" Region="North" Split="false" Height="60" BodyPadding="0" MinHeight="60" Collapsible="false">
                <Content>
                    <div class="mainHeader">
                        <h1><img src="../../images/main/main_logo.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" alt="Seoyon SRM System Logo" title="Seoyon SRM System Logo" onclick="App.ImageButtonHome.fireEvent('click');"  style="cursor:pointer" /></h1>
                        <div style="color:gray; font-size:12px;  position: absolute; left: 316px; top: 20px;">| <%=Ax.EP.Utility.EPAppSection.ToString("COPERATION")%></div>
                        <ext:Hyperlink ID="Link_SCM" runat="server" NavigateUrl="http://oldscm.seoyoneh.com" Text="SCM Old Version" Target="_blank" Style="color:Blue; text-decoration:underline; font-size:20px; font-weight:bold; position: absolute; left: 500px; top: 17px;display:none;"/>
                        
                        
                        <div class="web_user">
                            <img src="../../images/main/header_icon_user.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" alt="User" style="padding-top:3px;"/>
                            <ext:Label ID="Label7" runat="server" Text="&nbsp;" />
                            <ext:Label ID="LabelUser" runat="server" Text="[" />
                            <span>
                                <ext:Label ID="LabelLoginInfo" runat="server" />
                                <ext:Label ID="LabelEnd1" runat="server" Text="]" />
                            </span>                                                        
                            <ext:Label ID="Label11" runat="server" Text="&nbsp;&nbsp;&nbsp;&nbsp;" />

                            <ext:Label ID="Label9" runat="server" Text=" [" />
                            <span onclick="App.direct.ChangeLangSet('T2KO')"><ext:Label ID="lbl_LANG_KO" runat="server" Text="KO" /></span>
                            <ext:Label ID="Label2" runat="server" Text=" | " />
                            <span onclick="App.direct.ChangeLangSet('T2EN')"><ext:Label ID="lbl_LANG_EN" runat="server" Text="EN" /></span>

                            <%--<ext:Label ID="Label3" runat="server" Text=" | " />
                            <span onclick="App.direct.ChangeLangSet('T2PT')"><ext:Label ID="lbl_LANG_PT" runat="server" Text="BR" /></span>
                            <ext:Label ID="Label4" runat="server" Text=" | " />
                            <span onclick="App.direct.ChangeLangSet('T2ZH')"><ext:Label ID="lbl_LANG_ZH" runat="server" Text="CN" /></span>
                            <ext:Label ID="Label5" runat="server" Text=" | " />
                            <span onclick="App.direct.ChangeLangSet('T2SK')"><ext:Label ID="lbl_LANG_SK" runat="server" Text="SK" /></span>
                            <ext:Label ID="Label6" runat="server" Text=" ] " />
                            <span onclick="App.direct.ChangeLangSet('T2PL')"><ext:Label ID="lbl_LANG_PL" runat="server" Text="PL" /></span>                            --%>

                            <ext:Label ID="Label10" runat="server" Text=" ]" />    
                        </div>
                        <div class="unb">
                            <ul>
                                <%--
                                <li>
                                    <img src="../../images/main/header_icon_user.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" alt="User" style="padding-top:3px;"/>
                                </li>
                                <li>
                                    <ext:Label ID="Label7" runat="server" Text="&nbsp;&nbsp;" />
                                </li>

                                <li>
                                    <ext:Label ID="LabelUser" runat="server" Text="[" />
                                </li>
                                <li>
                                    <ext:Label ID="LabelLoginInfo" runat="server" />
                                </li>
                                <li>
                                    <ext:Label ID="LabelEnd1" runat="server" Text="]" />
                                </li>
                                --%>
                                <li>
                                    <ext:Label ID="Label1" runat="server" Text="&nbsp;&nbsp;&nbsp;&nbsp;" />
                                </li>
                                <li>
                                    <ext:ImageButton ID="ImageButtonHome" runat="server"  ImageUrl="../../images/common/t_home.png" OverImageUrl="../../images/common/t_home_over.png"  />
                                </li>
                                <li>
                                    <ext:ImageButton ID="ImageButtonChangePassword" runat="server" ImageUrl="../../images/common/t_pw.png" OverImageUrl="../../images/common/t_pw_over.png">
                                        <DirectEvents>
                                            <Click OnEvent="Popup">
                                                <ExtraParams>
                                                    <ext:Parameter Name="title" Value="Change Password" />
                                                    <ext:Parameter Name="chagePw" Value="Change Password" />
                                                    <ext:Parameter Name="width" Value="361" />
                                                    <ext:Parameter Name="height" Value="470" />
                                                    <ext:Parameter Name="modal" Value="true" />
                                                    <ext:Parameter Name="url" Value="EPPwdChange.aspx" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:ImageButton>
                                </li>
                                <li>
                                    <ext:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../images/common/t_help.png" OverImageUrl="../../images/common/t_help_over.png">
                                        <DirectEvents>
                                            <Click OnEvent="PopupHelp">
                                                <ExtraParams>
                                                    <ext:Parameter Name="title" Value="Help Document" />
                                                    <ext:Parameter Name="chagePw" Value="Help" />
                                                    <ext:Parameter Name="width" Value="450" />
                                                    <ext:Parameter Name="height" Value="420" />
                                                    <ext:Parameter Name="modal" Value="true" />
                                                    <ext:Parameter Name="url" Value="EPHelpDoc.aspx" />
                                                </ExtraParams>
                                            </Click>
                                        </DirectEvents>
                                    </ext:ImageButton>
                                </li>
                                <li>
                                    <ext:ImageButton ID="ImageButtonLogout" runat="server" ImageUrl="../../images/common/t_logout.png" OverImageUrl="../../images/common/t_logout_over.png">
                                    </ext:ImageButton>
                                </li>
                            </ul>
                        </div>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="Panel2" runat="server" Region="West" Collapsible="true" MinWidth="200"
                Split="true" Width="291" Title="Navigation" Layout="BorderLayout" CollapseMode="Default"
                CtCls="west-panel" StyleSpec="padding-top:4px; background:#fff; overflow-x:hidden;" >
                <SplitterConfig ID="SplitterConfig1" runat="server" Width="1" Cls="splitter_config"></SplitterConfig>
                <HeaderConfig Height="30" Padding="5"></HeaderConfig>
                <Items>
                </Items>
                <TopBar>
                </TopBar>
                <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                    <LoadMask ShowMask="true" />
                </Loader>
            </ext:Panel>
            <ext:TabPanel ID="TabPanel1" Height="660" Region="Center" runat="server" ResizeTabs="true" MinTabWidth="100" EnableTabScroll="true" AnimScroll="false" Collapsed="false" Plain="false" StyleSpec="border-bottom:1px solid #838383;">
                <%-- AutoScroll="true" 삭제함 가로스크롤문제 --%>
                <Items>
                    <ext:Panel ID="TabMain" runat="server" Title="MAIN" Padding="0" AutoFocus="false">
                        <Content />
                        <TabConfig ID="TabConfig1" runat="server" Height="28" ToolTip="[MAIN] WebPortal System" />
                    </ext:Panel>
                </Items>
                <Plugins>
                    <ext:TabCloseMenu ID="TabCloseMenu1" runat="server" />
                    <ext:TabScrollerMenu ID="TabScrollerMenu1" runat="server" PageSize="5">
                    </ext:TabScrollerMenu>
                </Plugins>
                <Listeners>
                    <TabChange Handler="searchExecuted();" />
                </Listeners>
            </ext:TabPanel>
            <ext:Panel ID="Panel10" runat="server" Region="South" Split="false" BodyPadding="0"
                Height="30" Collapsed="false">
                <Content>
                    <div style="position:absolute; left:10px; width:500px;">
                        <div style="width:80px; float:left; line-height:30px;">Related Sites</div>
                        <ext:SelectBox OnDirectSelect="RelatedSites_Selected"
                        ID="cboRelatedSites"
                        runat="server" 
                        DisplayField="SITENAME" Width="160"
                        ValueField="SITEURL"
                        EmptyText="[ Select a site... ]"  FieldStyle="height:20px !important;"  StyleSpec="float:left; width:200px; margin-top:4px;"
                        >
                        <Store>
                            <ext:Store ID="Store1" runat="server">
                                <Model>
                                    <ext:Model ID="Model1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="SITENAME" />
                                            <ext:ModelField Name="SITEURL" />
                                        </Fields>
                                    </ext:Model>
                                </Model>            
                            </ext:Store>    
                        </Store>

                    </ext:SelectBox>
                    </div>
                    <div class="mainFooter" style="height: 30px;">
                        <address>
                            COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED.
                        </address>
                    </div>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
<!--[if lt IE 9]>   
<script type="text/javascript">
    // IE 9 보다 그 이전 버전일 경우
    successFlag = true;
<% if (Request.Headers["Accept-Language"].Substring(0, 2).ToUpper().Equals("KO")) {  %>
	alert("* 경고 *\n\n인터넷 익스플로러 8.x 이하 버전은 사용할 수 없습니다.\nIE 9.0 또는 그 이상의 버전을 사용하시기 바랍니다.\n\n추천: 파이어폭스, 크롬, IE (9,10,1), 사파리, ...\n\nVattz 시스템으로 인해 IE 9 이상 버전을 사용할 수 없는 경우 \nIE 를 제외한 그 외 브라우저를 사용하시기 바랍니다.");
<% } else { %>
    alert("* WARNING *\n\nInternet Explorer 8.x or lower version is not available.\n9.0 or a higher version must be used.\n\nRecommended: Firefox, Google Chrome, IE 9 or higher, Safari, ...\n\nVattz system due to the longer version of IE 9 is not available, \nplease use other browsers except IE.");
<% } %>
</script>
<![endif]-->


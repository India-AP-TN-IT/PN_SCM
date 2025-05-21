<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MMain.aspx.cs"  Inherits="Ax.EP.WP.Mobile.MBase.EPMain"  EnableViewStateMac="False"  %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
    <meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
    <meta name="format-detection" content="telephone=no, address=no, email=no" />

    <title>Seoyon E-Hwa Potal::서연이화::</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        var sCtl = "";

        // teebarcode control
        sCtl += "<object id='axTBarCode5'  classid='CLSID:10ED9AE3-DA1A-461C-826A-CD9C850C58E2' CODEBASE='../../files/cab/TBarCode5.cab#version=5,3,0,49' type='application/x-oleobject' style='display: none'></object>";
        // teebarcode control 10
        sCtl += "<object id='axTBarCode10'  classid='CLSID:FEF2D6AE-79C4-497C-8D69-4E0F45FCFBC5' CODEBASE='../../files/cab/TBarCode10.cab#version=10,2,2,13543' type='application/x-oleobject' style='display: none'></object>";

        //document.write(sCtl);
    </script>
    <script type="text/javascript">
//        var successFlag = false;    // 호환성 모드 처리용

//        var addTab = function (tabPanel, record, userId, type, prm) {
//            if (userId == '') { logoutHandler(); return; }
//            var tab = tabPanel.getComponent(record.getId());

//            if (typeof (tab) == "object") {
//                tabPanel.setActiveTab(tab);
//                return;
//                //tabPanel.closeTab(tab);  // 이미 열려있으면 닫고 다시 연다.
//            }

//            //타이머 중복으로 인해 서열투입실적 열었을 시 ALC투입실적화면을 닫는다.
//            if (record.getId() == "SRM_ALC30002") {
//                tabPanel.closeTab("SRM_ALC30003"); 
//            }
//            else if (record.getId() == "SRM_ALC30003") {
//                tabPanel.closeTab("SRM_ALC30002"); 
//            }

//            if (tabPanel.items.length > 10) { // Main탭이르 제외한 10개이상 초과시 
//                tabPanel.closeTab(tabPanel.getComponent(1));   // 가장 오래된 창 Close
//                //App.direct.MsgCodeAlert("MSG-00009");     // 더이상열수 없다는 메세지 표시 
//                //return;
//            }

//            // 아래 프로그램은 단순 링크로 동작하도록 한다.(프로그램 ID 가 L 로 끝날때) ( 예외처리 )
//            if (record.getId().substr(record.getId().length - 1, 1) == "L")
//                OpenLink(record.data.href);
//            else
//                App.direct.MakeTap2(record.getId(), record.data.href, type, prm);
//        }

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
            location.href = "MMain.aspx";
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

        var refreshTree = function (tree, groupcd, title) {
            App.GroupCd.setValue(groupcd);
            App.PgmTitle.setValue(title);

            App.direct.RefreshMenu({
                success: function (result) {

                    var nodes = eval(result);
                    if (nodes.length > 0) {
                        //tree.initChildren(nodes);     // Ext v1.x
                        tree.setRootNode(nodes[0]);     // Ext v2.x 에서는 initChildren 이 삭제됨 ( setRootNode 를 대체사용 )
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
            var addr = "http://" + href.replace("http://", "").replace("https://","");
            var win = window.open(addr);
        }

        function UI_Shown() {
            // 정상로드일경우 호환성 모드 리로드 설정을 해제한다.
//            successFlag = true;         
//            document.getElementById("PreepairMsg").style.display = "none";

            // 메뉴 재호출
            this.refreshTree(App.TreePanel1, App.GroupCd.getValue(), App.PgmTitle.getValue());
        }

//        // 호환성 모드 처리용 페이지 리로드
//        function reLoad() { if (!successFlag) document.location.reload(); }
//        function reMsg() { if (!successFlag) document.getElementById("PreepairMsg").style.display = "block"; setTimeout(reLoad, 3000); }

//        // 호환성 모드일경우 3초후 페이지 리로드 처리
//        setTimeout(reMsg, 500);

    </script>
<link rel="Stylesheet" type="text/css" href="../css/mobile.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
</head>
<body>
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="GroupCd" Hidden="true" runat="server" />
    <ext:TextField ID="PgmTitle" Hidden="true" runat="server" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout">
        <Items>
        <ext:Panel ID="Panel1" runat="server" Region="Center">
            <Content>
                <div id="wrap">
	                <!-- 헤더 -->
                    <div class="header2">
                        <div class="mlogo"><ext:ImageButton ID="ImageButtonHome" runat="server" ImageUrl="../images/mlogo.gif" Height="50">
                            <Listeners>
                                <Click Handler="App.direct.Home();" />
                            </Listeners>
                        </ext:ImageButton></div>

                        <div class="mlogout"><ext:ImageButton ID="ImageButtonLogout" runat="server" ImageUrl="../images/btn/m_btn_logout.gif">
                            <Listeners>
                                <Click Handler="App.direct.Logout();" />
                            </Listeners>
                        </ext:ImageButton></div>
                    </div>
                    <!-- //헤더 -->
                    <!-- 비쥬얼 -->
                    <div class="visual"><img src="../images/m_mvisual.png" alt="" width="320" /></div>
                    <!-- //비쥬얼 -->
                    <!-- login -->
                    <div class="menu">
    	                <ul>
        	                <li><a href="../SRM_MM/SRM_MM21001.aspx" class="menu1">A/S, S/P, CKD 자재 발주 현황</a></li>
                            <li><a href="../SRM_MM/SRM_MM31002.aspx" class="menu2">OEM 자재발주 현황</a></li>
                        </ul>
                    </div>
                    <!-- //login -->
                    <!-- 푸터 -->
                    <div class="footer">COPYRIGHT(c) SEOYON E-HWA. ALL RIGHTS RESERVED.</div>
                    <!-- //푸터 -->
                </div>              
            </Content>
        </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
<!--[if lt IE 8]>   
<script type="text/javascript">
    // IE 8 보다 그 이전 버전일 경우
    successFlag = true;
	alert("* WARNING(경고) *\n\n인터넷 익스플로러 7.x 이하 버전은 사용할 수 없습니다.\nIE 8.0 또는 그 이상의 버전을 사용하시기 바랍니다.\n\n추천: IE8 또는 상위버전, 크롬, 사파리, 파이어폭스, ...\n\nVattz 시스템으로 인해 IE 8 이상 버전을 사용할 수 없는 경우 \nIE 를 제외한 그 외 브라우저를 사용하시기 바랍니다.\n\n--------------------------------------------------------------\n\nInternet Explorer 7.x or lower version is not available.\n8.0 or a higher version must be used.\n\nRecommended: IE 8 or higher, Google Chrome, Safari, Firefox, ...\n\nVattz system due to the longer version of IE 8 is not available, \nplease use other browsers except IE.");
</script>
<![endif]-->


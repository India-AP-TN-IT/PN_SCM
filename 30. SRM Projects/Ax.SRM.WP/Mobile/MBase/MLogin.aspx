<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MLogin.aspx.cs" Inherits="Ax.EP.WP.Mobile.MBase.MLogin"  %>
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
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
    <meta name="format-detection" content="telephone=no, address=no, email=no" />

    <meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
    <meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />

    <title>Seoyon E-Hwa Potal::서연이화::</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--<link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />--%>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <script type="text/javascript">
//        var successFlag = false;    // 호환성 모드 처리용

        var goMain = function (isLogin) {
            var frmLogin = document.getElementById("frmLogin");
            
            if (isLogin == "Y") {
                App.HiddenLanguage.setValue(App.SelectBoxLanguage.getValue());

                document.location.href = "MMain.ASPX";

            } else {
                App.TextFieldLogin.focus();
            }
        }

        function UI_Resize() {
            // 로그인 창 위치를 핸들링한다.
//            var lf = document.getelementbyid("login_form");
//            var h = 650- document.documentelement.clientheight;
//            if (h > 0) lf.style.margintop = (290 - h) + "px";
        }

//        function UI_Shown() {
//            // 정상로드일경우 호환성 모드 리로드 설정을 해제한다.
//            successFlag = true;
//            document.getElementById("PreepairMsg").style.display = "none";

//            UI_Resize();
//        }

        // 호환성 모드 처리용 페이지 리로드
//        function reLoad() { if (!successFlag) document.location.reload(); }
//        function reMsg() { if (!successFlag) document.getElementById("PreepairMsg").style.display = "block"; setTimeout(reLoad, 3000); }

//        window.onload = function anonymous() {

//            try {
//                window.moveTo(0, 0);
//                if (document.all) {
//                    window.resizeTo(screen.availWidth, screen.availHeight);
//                }

//                else if (document.layers || document.getElementById) {
//                    if (window.outerHeight < screen.availHeight || window.outerWidth < screen.availWidth) {
//                        window.outerHeight = screen.availHeight;
//                        window.outerWidth = screen.availWidth;
//                    }
//                }
//            }
//            catch (exception) { }
//            finally { }            
//        }

//        // 호환성 모드일경우 3초후 페이지 리로드 처리
//        setTimeout(reMsg, 500);
    </script>
    <link rel="Stylesheet" type="text/css" href="../css/mobile.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
</head>
<body>
    <form id="frmLogin" runat="server" method="post">
    <ext:ResourceManager ID="ResourceManager1" runat="server"><Listeners><DocumentReady Handler="ExtDocumentReady();" /></Listeners></ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
        <ext:Panel runat="server" Region="Center" AutoScroll="true">
            <Content>
                <div id="Div1">
	                <!-- 헤더 -->
                    <div class="header"><img src="../images/mlogo.gif" alt="" height="50"/></div>
                    <!-- //헤더 -->
                    <!-- 비쥬얼 -->
                    <div class="visual"><img src="../images/m_visual.png" alt="" width="320" /></div>
                    <!-- //비쥬얼 -->
                    <!-- login -->
                    <div class="login">
    	                <div class="login_box">
        	                <div><img src="../images/m_logint.jpg" width="280" ></div>
                            <div>
            	                <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                	                <tr>
                    	                <td height="30" width="93"><img src="../images/m_id.jpg" alt="" height="23" /></td>
                                        <td><ext:TextField ID="TextFieldLogin" runat="server" Cls="login_id" Width="188" /></td>
                                    </tr>
                                    <tr>
                    	                <td height="30"><img src="../images/m_pw.jpg" alt=""  height="23" /></td>
                                        <td><ext:TextField ID="TextFieldPassword" runat="server" Cls="login_pw" InputType="Password" Width="188" /></td>
                                    </tr>
                                    <tr>
                    	                <td height="30"><img src="../images/m_lan.jpg" alt=""  height="23" /></td>
                                        <td>
                                            <ext:SelectBox ID="SelectBoxLanguage" runat="server"  Mode="Local" ForceSelection="true"
                                                DisplayField="CODE" ValueField="ID" TriggerAction="All" Width="188">
                                                <Store>
                                                    <ext:Store ID="Store5" runat="server" >
                                                        <Model>
                                                            <ext:Model ID="Model1" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="ID" />
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="COMBO_VALUE" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>

                                                    </ext:Store>
                                                </Store>
                                            </ext:SelectBox>
                                        </td>
                                    </tr>
                                    <tr>
                    	                <td height="10" colspan="2"></td>
                                    </tr>
                                    <tr>
                    	                <td colspan="2">
                                            <ext:ImageButton ID="ImageButtonLogin" runat="server" ImageUrl="../images/m_btn_ok.jpg"
                                                width="280" >
                                                <DirectEvents>
                                                    <Click OnEvent="Login"/>
                                                </DirectEvents>
                                            </ext:ImageButton>
                                            <!-- 로그인 버튼 영역 -->
                                            <ext:Hidden ID="HiddenLanguage" runat="server">
                                            </ext:Hidden>
                                            <ext:KeyMap ID="KeyMap1" runat="server" Target="App.TextFieldLogin">
                                                <Binding>
                                                    <ext:KeyBinding DefaultEventAction="StopEvent" Handler="App.ImageButtonLogin.fireEvent('click')">
                                                        <Keys>
                                                            <ext:Key Code="ENTER" />
                                                        </Keys>
                                                    </ext:KeyBinding>
                                                </Binding>
                                            </ext:KeyMap>
                                            <ext:KeyMap ID="KeyMap2" runat="server" Target="App.TextFieldPassword">
                                                <Binding>
                                                    <ext:KeyBinding DefaultEventAction="StopEvent" Handler="App.ImageButtonLogin.fireEvent('click')">
                                                        <Keys>
                                                            <ext:Key Code="ENTER" />
                                                        </Keys>
                                                    </ext:KeyBinding>
                                                </Binding>
                                            </ext:KeyMap>
                                            <!-- 로그인 버튼영역 끝 -->
                                        </td>
                                    </tr>
                                </table>                   
                            </div>
                        </div>
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

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPLogin.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPLogin"  %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
<meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
<meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />
<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />
    <meta name="description" content="<%=Ax.EP.Utility.EPAppSection.ToString("DESCRIPTION") %>" />
    <meta name="keywords" content="<%=Ax.EP.Utility.EPAppSection.ToString("KEYWORDS") %>" />

    <title><%=Ax.EP.Utility.EPAppSection.ToString("TITLE") %> (<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_REGION") %>)</title>

        

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <!--
    <link rel="shortcut icon" type="image/x-icon" sizes="128x128" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="64x64" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="32x32" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="24x24" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="shortcut icon" type="image/x-icon" sizes="16x16" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    -->
    <!-- <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  /> -->

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script src="../../Script/PopupCookie.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <script type="text/javascript">

        function unhighlight(x) {
            x.style.color = "#00519C";
            x.style.cursor = 'default';
        }
        
        function highlight(x) {
            x.style.color = "blue";
            x.style.cursor = 'pointer'; 
        }

        var goMain = function (isLogin) {
            var frmLogin = document.getElementById("frmLogin");
            
            if (isLogin == "Y") {
                App.HiddenLanguage.setValue(App.SelectBoxLanguage.getValue());

                document.location.href = "EPMain.ASPX?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>";

            } else {
                App.TextFieldLogin.focus();
            }
        }

        function UI_Resize() {

        }

        function UI_Shown() {
            UI_Resize();
        }

        function upperID()
        {
            App.TextFieldLogin.setValue(App.TextFieldLogin.getValue().toUpperCase());
        }
    </script>

     <style type="text/css">
        @import url(//fonts.googleapis.com/earlyaccess/nanumgothic.css);
        *	{ margin:0; padding:0;}
        .x-body, body	{ margin:0; padding:0; background:#b3c0d1; }
        .login_bg	{ width:100%; min-height:700px; background:url(../../images/login/bg_<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_REGION") %>.jpg) top center no-repeat;}
        .login_logo	{ width:1100px; margin:0 auto; padding-top:30px;}
        .login_box	{ width:100%; height:380px; background:url(../../images/login/login_bg.png?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>) center no-repeat; position:absolute; top:50%; }
        .login_area	{ position:absolute; left:50%; padding-left:210px; width:290px;  padding-top:170px; overflow:hidden;}
        .useridpw	{ width:180px; padding-right:10px; float:left}
        .loginok	{  float:left; padding-top:2px;}
        table, table td 	{ border-collapse:collapse;border-spacing:0 padding:0; margin:0;}
        input	{ height:28px !important; width:177px; border-radius:3px !important; border:0 !important;}
        .x-form-trigger-wrap input	{ height:28px !important; width:177px; border-radius:0px !important; border:0 !important;}
        input#SelectBoxLanguage-inputEl { height:28px !important; width:158px; border-radius:0px !important; border:0 !important;}
        .login_copy	{ position:absolute; width:100%; text-align:center; color:#fff; font-size:13px; bottom:30px; }
        .x-form-trigger-wrap  { border-radius:3px !important }
        .x-trigger-cell  { padding-top:3px !important;}
    </style>

</head>
<body>
    <form id="frmLogin" runat="server" method="post">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
            <BeforeAjaxRequest Handler="upperID();" />
        </Listeners>
    </ext:ResourceManager>

    <!-- 로그인 영역 시작 -->
    <div class="login_bg">
	    <div class="login_logo"><ext:Image runat="server" ID="LOGO" Width="370" Height="55"></ext:Image>        
            <div style="color:gray; font-size:12px;  position:relative; left: 370px; top: -33px;">| <ext:Label ID="lbl_CORPERATION" runat="server" StyleSpec="color:#eb8012; font-size:12px; font-weight: bold;"/></div>
        </div>
	    <div class="login_box">
    	    <div class="login_area">
        	    <div class="useridpw">
            	    <table>
                	    <tr>
                    	    <td height="34"><ext:TextField ID="TextFieldLogin" runat="server" Width="178"  FieldStyle="text-transform:uppercase;" InputType="Text" /></td>
                        </tr>
                        <tr>
                    	    <td height="34"><ext:TextField ID="TextFieldPassword" runat="server" Width="178" InputType="Password" /></td>
                        </tr>
                        <tr>
                    	    <td height="34">
                                <ext:SelectBox ID="SelectBoxLanguage" runat="server"  Mode="Local" ForceSelection="true"
                                            DisplayField="CODE" ValueField="ID" TriggerAction="All" Width="178">
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
                    </table>
                </div>
                <div class="loginok">
                    <ext:ImageButton ID="ImageButtonLogin" runat="server" ImageUrl="../../images/login/login_btn.png" Cls="btn_login">
                        <DirectEvents>
                            <Click OnEvent="Login"/>
                        </DirectEvents>
                    </ext:ImageButton>
                    <!-- 로그인 버튼 영역 -->
                    <ext:Hidden ID="HiddenLanguage" runat="server"/>
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
                </div>
            </div>
        </div>
        <div class="login_copy">
            <span onclick="App.direct.PopPwd()" onmouseover="highlight(this)" onmouseout="unhighlight(this)" style="color:#00519C;text-decoration: underline;"><ext:Label runat="server" ID="BIZMGR" Text="비밀번호 분실시 연락처보기"></ext:Label></span><br />
    	    Address : <ext:Label ID="lbl01_Addr" runat="server" /><br/>
            Copyright(c) SEOYON E-HWA. All Rights Reserved.
        </div>
    </div>
    <!-- 로그인 영역 끝 -->
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

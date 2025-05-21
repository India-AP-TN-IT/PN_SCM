<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPPwdExpire.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPPwdExpire" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>Password expiration guidance</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server"><Listeners><DocumentReady Handler="var func = ExtDocumentReady; if (func) func();" /></Listeners></ext:ResourceManager>
    <!-- size : 330x140 -->
    <div class="pop_pw" >
        <h1>
            Password expiration guidance
            <ext:ImageButton ID="ImageButton2" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close">
                <Listeners>
                    <Click Handler ="hidePop()" />
                </Listeners>
            </ext:ImageButton>
        </h1>
        <div class="pw_div" style="height:100px;" >    
        <% if (LANG_SET.Equals("T2KO"))
           {%>          
            <table class="pw_view" style="height:100px;">
                <tr >
                    <td >    
                        <B>현재 비밀번호 유효기간이 <%=REST_DATE%>일 남았습니다.</B><br />
                        <br />비밀번호 만료일자는 (<%=Pwd_Date%>) 입니다<br />비밀번호 변경주기는 <%=PWDCHANGEPERIOD%>일입니다.<br />만료일자 기간내에 패스워드를 변경해주세요
                    </td>
                </tr>
            </table>
        <% }
           else
           {%>
            <table class="pw_view" style="height:100px;">
                <tr >
                    <td >    
                        <B><%=REST_DATE%> days later, the password Expires.</B><br />
                        <br />1. Expiration date: <%=Pwd_Date%><br />2. Password change period is <%=PWDCHANGEPERIOD%> days.<br />3. Before expiration, you should change your password.
                    </td>
                </tr>
            </table>
        <% } %>
        </div>
    </div>
    </form>
</body>
</html>

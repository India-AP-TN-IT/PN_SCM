<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EPPwdChange.aspx.cs" Inherits="Ax.EP.WP.Home.EPBase.EPPwdChange" %>
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

    <title>Change Password</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            UI_Resize()
        }

        function UI_Resize() {

        }

        var checkPw = function (uid, lang) {
            if (fnCheckPassword(uid, App.TextFieldUser_id.getValue(), lang)) {
                if (App.TextFieldUser_id.getValue() != App.TextFieldPassword.getValue()) {
                    Ext.Msg.alert("Warning", "비밀번호가 맞지 않습니다.<br/>(Password is diffrent.)");
                    App.TextFieldPassword.focus();
                } else {
                    App.direct.ChangePaword(App.TextFieldPassword.getValue());
                }
            } else {
                App.TextFieldUser_id.focus();

            }
        }

        function fnCheckPassword(uid, upw, lang) {
            var first_message;
            var second_message;
            var third_message;
            var forth_message;

            if (lang != 'KO') {
                first_message = 'Passwod have to be combined number with English and use 8~12 lenths ';
                second_message = 'Passwod have to be combined number with English';
                third_message = 'Do not use same 4 characters ';
                forth_message = 'Do not use password included id';
            }
            else {
                first_message = '비밀번호는 숫자와 영문자 및 기호 조합으로 6~12자리를 사용해야 합니다.';
                second_message = '비밀번호는 숫자와 영문자 및 기호를 혼용하여야 합니다.';
                third_message = '비밀번호에 같은 문자를 4번 이상 사용하실 수 없습니다.';
                forth_message = 'ID가 포함된 비밀번호는 사용하실 수 없습니다.';
            }

            if (upw.length < 6) {
                parent.Ext.Msg.alert("Warning", first_message);
                return false;
            }

            if (!upw.match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)) {
                parent.Ext.Msg.alert("Warning", second_message);
                return false;
            }

            if (/(\w)\1\1\1/.test(upw)) {
                parent.Ext.Msg.alert("Warning", third_message);
                return false;
            }

            if (upw.search(uid) > -1) {
                parent.Ext.Msg.alert("Warning", forth_message);
                return false;
            }
            return true;
        }
    </script>
    <style type="text/css">
        .x-btn-inner  { Color:black !important; font-weight:normal !important; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <!-- size : 330x140 -->
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="60">
                <Content>
                    <div class="pop_pw" style="height:60px;">
                        <h1 style="padding-top:14px;">
                            <ext:Label ID="lbl01_EPPwdChange" runat="server" Text="Change Password" />
                            <ext:ImageButton ID="ImageButton2" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close">
                                <Listeners>
                                    <Click Handler="hidePop()" />
                                </Listeners>
                            </ext:ImageButton>
                        </h1>
                    </div>
                    <input type="hidden" runat="server" id="loggbn" />
                </Content>
            </ext:Panel>
            <ext:Panel ID="ContentPanel" runat="server" Cls="pw_view" Region="Center">
                <Content>
                    <table class="pw_view">
                        <tr>
                            <th width="120">
                                Old Password
                            </th>
                            <td>
                                <ext:TextField ID="TextFieldCurrentPW" Width="180" runat="server" Vtype="password" InputType="Password"
                                    MsgTarget="Side" Cls="pw_pw">
                                </ext:TextField>
                            </td>
                        </tr>
                        <tr>        
                            <th>
                                New Password
                            </th>
                            <td>
                                <ext:TextField ID="TextFieldUser_id" Width="180" runat="server"  InputType="Password"
                                    Cls="pw_pw">                            
                                </ext:TextField>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                New Confirm
                            </th>
                            <td>
                                <ext:TextField ID="TextFieldPassword"  Width="180" runat="server" Vtype="password" InputType="Password"
                                    MsgTarget="Side" Cls="pw_pw">
                                </ext:TextField>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="btn_c"> 
                                <ext:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../images/btn/btn_pwsave.gif"
                                    Cls="btn_login" OnDirectClick="Submit_Password">                
                                </ext:ImageButton>
                            </td>
                        </tr>
                    </table>
                    <div class="blank01"></div>
                    <ul class="li_title">
                        <li><ext:Label ID="lbl01_EPPwdChange_01" runat="server" StyleSpec="font-weight:bold;" Text="비밀번호 제약조건" />
                            <ul >
                                <li>1. <ext:Label ID="lbl01_EPPwdChange_02" runat="server">숫자와 영문자 및 기호 조합으로 6자 이상</ext:Label></li>
                                <li>2. <ext:Label ID="lbl01_EPPwdChange_03" runat="server">숫자와 영문자 및 기호 혼용</ext:Label></li>
                                <li>3. <ext:Label ID="lbl01_EPPwdChange_04" runat="server">같은 문자를 4번이상 사용하지 못함</ext:Label></li>
                                <li>4. <ext:Label ID="lbl01_EPPwdChange_05" runat="server">ID가 포함된 비밀번호 사용하지 못함</ext:Label></li>
                            </ul>
                        </li>
                    </ul>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

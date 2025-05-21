<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM20001P1.aspx.cs" Inherits="Ax.EP.WP.Home.EP_XM.EP_XM20001P1" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
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

    <title>Customer Search Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
        }
    </script>
</head>
<body>
    <form id="EP_XM20001P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0" Cls="pdb10">
        <Listeners>
            <Resize Fn="UI_Resize" />
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North">
                <Content>
                    <div class="popup_area">
                        <h1>
                            <ext:Label ID="lbl01_EP_XM20001P1" runat="server" /><%--Text="복사대상 사용자ID 입력 팝업" />--%>
                            <ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close" OnDirectClick="Button_Click" />
                        </h1>
                    </div>
                    <%-- 숨겨 사용하기 ^^;;; --%>
                    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
                </Content>
            </ext:Panel>
            <ext:Panel ID="ButtonPanel" runat="server" Height="30" Region="North" Cls="search_area_title_btn lrmargin10">
                <Items>
                    <%-- 상단 이미지버튼 --%>
                </Items>
            </ext:Panel>   
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col/>
                        </colgroup>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_USERID" runat="server" />  <%--Text="사용자 아이디"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_USERID" Cls="inputText" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_OPTION" runat="server" /> <%--Text="대상자 권한삭제"--%>
                            </th>
                            <td>
                                <ext:Checkbox ID="chk01_XM20001P1_CHK_1" runat="server" />
                            </td>   
                            <td></td>               
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>                                 
        </Items>
    </ext:Viewport>    
    </form>
</body>
</html>

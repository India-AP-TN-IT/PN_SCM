<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="POPUP_SAMPLE.aspx.cs" Inherits="Ax.SRM.WP.Home.EPSample.POPUP_SAMPLE" %>
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

    <title>팝업샘플</title>

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
            //            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        var fn_sendParentWindow = function (popupID, objectID, typeNM, typeCD, record) {
            parent.fn_SetValues(popupID, objectID, typeNM, typeCD, Ext.decode(record));
        }

    </script>
</head>
<body>
    <form id="SRM_QA21003P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_CORCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_BIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_RROG_DIV" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
 
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0"  Cls="pdb10">  <%--Padding="10"을 0으로 변경, CLS 추가 해주세요--%>
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North">
                <Content>
                    <div class="popup_area"><%-- style="padding-top:11px;"스타일삭제 스타일삭제 스타일삭제 스타일삭제 스타일삭제스타일삭제스타일삭제스타일삭제스타일삭제스타일삭제스타일삭제스타일삭제--%>
                        <h1>
                            <ext:Label ID="lbl01_SRM_QA21003P1" runat="server" Text="이의제기 공문" />
                            <ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close"  /> 
                            <%--위의 이미지버튼에 OnDirectClick="Button_Click"를 넣어주세요--%>
                        </h1>
                    </div>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ButtonPanel" runat="server" Region="North" Height="30" Cls="search_area_title_btn lrmargin10"><%--lrmargin10 스타일을 각 패널에 추가--%>
                <Items>
                    <%-- 상단 이미지버튼 페이지 경로가 맞으면 버튼 똑바로 나옵니다. --%>
                </Items>
            </ext:Panel>            
            <ext:Label ID="Label1" runat="server" Region="North" Cls="pop_t_01 lrmargin10" Text="협력업체용"></ext:Label><%--lrmargin10 스타일을 각 패널에 추가--%>
            <ext:Panel ID="ContentPanel1" runat="server" Region="North" Cls="search_area_table lrmargin10" Height="270"><%--lrmargin10 스타일을 각 패널에 추가--%>
                <Content>
                <table>
                <colgroup>
                    <col width="150" />
                    <col />                    
                </colgroup>
                    <tr>
                        <th>
                            <ext:Label ID="lbl02_DOCRPTNO" runat="server" />
                        </th>
                        <td>
                            <ext:TextField ID="txt02_DOCRPTNO" Cls="inputText" FieldCls="inputText" runat="server" ReadOnly="true" Height ="22"  Width="420" />
                        </td>
                    </tr>                         
                    </tr> 
                </table>
                </Content>
            </ext:Panel>
            
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

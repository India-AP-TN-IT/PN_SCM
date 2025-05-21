<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP20003P2.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP20003P2" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible"/>
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>상세 견적 첨부</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
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
    <form id="SRM_PopCustItemcdGrid" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <%-- 숨겨진 데이터  --%>
    <ext:TextField runat="server" ID="txt01_ID" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_ATT_FILENM" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_BIZCD" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_PRNO" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_PRNO_SEQ" Hidden="true" />
    <ext:TextField runat="server" ID="txt01_SEQ" Hidden="true" />

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_MP20003P2" runat="server" Cls="search_area_title_name" /><%--Text="" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <ext:Panel ID="Panel1" Region="Center" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl02_ATTACH_FILE" runat="server" />
                            </th>
                            <td>
                               <ext:FieldContainer ID="FieldContainer3" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Flex="1" Cls="inputText" ButtonText="Upload" Width="200">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID1_DEL" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <ext:HyperlinkButton ID="lkb02_FILEID1" runat="server" Icon="Attach" Width="349" StyleSpec="color:#000;float:left;overflow:hidden">
                                            <DirectEvents><Click OnEvent="etc_Button_Click" /></DirectEvents>
                                        </ext:HyperlinkButton>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            
        </Items>
    </ext:Viewport>

    </form>
</body>
</html>

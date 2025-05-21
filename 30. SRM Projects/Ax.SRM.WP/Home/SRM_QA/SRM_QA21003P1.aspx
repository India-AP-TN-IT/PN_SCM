<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA21003P1.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA21003P1" %>
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

    <title>이의제기 공문</title>

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
    <ext:Hidden ID="hid02_FILEID1" runat="server" />
 
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="0">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North">
                <Content>
                    <div class="popup_area">
                        <h1>
                            <ext:Label ID="lbl01_SRM_QA21003P1" runat="server" Text="이의제기 공문" />
                            <ext:ImageButton ID="btn01_CLOSE" runat="server" ImageUrl="../../images/main/close.gif" Cls="pop_close" OnDirectClick="Button_Click" />
                        </h1>
                    </div>
                </Content>
            </ext:Panel>            

            <ext:Panel ID="panel10" runat="server" Region="North" Cls="pop_padding">
            <Items>

            <ext:Panel ID="ButtonPanel" runat="server" Height="30" Cls="search_area_title_btn">
                <Items>
                    <%-- 상단 이미지버튼 --%>
                </Items>
            </ext:Panel>            

                <ext:Label runat="server" Cls="pop_t_01" Text="협력업체용"></ext:Label>
                    
                <ext:Panel ID="ContentPanel1" runat="server" Cls="search_area_table" Height="270">
                    <Content>
                    <table>
                    <colgroup>
                        <col width="150" />
                        <col />                    
                    </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_DOCRPTNO" runat="server" /><%--Text="통보서 번호" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_DOCRPTNO" Cls="inputText" FieldCls="inputText" runat="server" ReadOnly="true" Height ="22"  Width="420" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_FORMOBJNO" runat="server" /><%--Text="이의제기번호" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_FORMOBJNO" Cls="inputText" FieldCls="inputText" runat="server" ReadOnly="true" Height ="22" Width="420" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_SUBJECT" runat="server" /><%--Text="제목" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_REQT_SUBJECT" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="420" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_REASON" runat="server" /><%--Text="사유" />--%>
                            </th>
                            <td>
                                <ext:TextArea ID="txt02_REQT_REASON" runat="server" Width="420" Height="100" Cls="textarea_m3" />                               
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_ATTACH_FILE" runat="server" /><%--Text="첨부파일" />--%>
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
                                <%--<ext:TextField ID="txt02_ATT_FILE_NM" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="420" />--%>
                            </td>
                        </tr> 
                         <tr>
                            <th>
                                <ext:Label ID="lbl03_ATTACH_FILE" runat="server" /><%--Text="첨부파일" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID2" runat="server" Flex="1" Cls="inputText" ButtonText="Upload" Width="200">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID2_DEL" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <ext:HyperlinkButton ID="lkb02_FILEID2" runat="server" Icon="Attach" Width="349" StyleSpec="color:#000;float:left;overflow:hidden">
                                            <DirectEvents><Click OnEvent="etc_Button_Click" /></DirectEvents>
                                        </ext:HyperlinkButton>
                                    </Items>
                                </ext:FieldContainer>
                                <%--<ext:TextField ID="txt02_ATT_FILE_NM02" Cls="inputText" FieldCls="inputText" runat="server" Editable="true" Height ="22" Width="420" />--%>
                            </td>
                        </tr> 
                    </table>
                    </Content>
                </ext:Panel>

                <ext:Label ID="Label1" runat="server" Cls="pop_t_02" Text="이의처리결과"></ext:Label>                  

                <ext:Panel ID="Panel2" runat="server" Cls="search_area_table">
                    <Content>
                    <table style="height:150px;">
                    <colgroup>
                        <col width="150" />
                        <col />                    
                    </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl03_SUBJECT" runat="server" /><%--Text="제목" />--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt02_RSLT_SUBJECT" Cls="inputText" FieldCls="inputText" runat="server" ReadOnly="true" Height ="22" Width="420" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_RESULT" runat="server" /><%--eTxt="결과" />--%>
                            </th>
                            <td>
                                <ext:TextArea ID="txt02_RSLT_CNTT" runat="server" ReadOnly="true" Width="420" Height="100" Cls="textarea_m3" />                                
                            </td>
                        </tr> 
                    </table>
                    </Content>
                </ext:Panel>

            </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

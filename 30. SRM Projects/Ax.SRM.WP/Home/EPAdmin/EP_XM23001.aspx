<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM23001.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM23001" %>
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

    <title>Notice Management</title>

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
            App.Grid01.setHeight(App.GridPanel.getHeight());

            if (App.heb02_CONTENTS) {
                // 내용창의 리사이징을 위해 기본값인 22로 복구했다가 다시 리사이징 처리
                App.heb02_CONTENTS.setHeight(22);
                App.heb02_CONTENTS.setHeight(App.ContentPanel.getHeight() - document.getElementById("tableContent").clientHeight + 22 - 3);
            }
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        //최근 일주일 내에 등록된 공지는 제목 옆에 "N"이미지 표시
        var TitleNew = function (value, meta, record) {
            var template = '{0}<span class="new_icon"><img  src="../../images/main/new_icon.gif" /></span>';

            if (getDateDiff(getEPTimeStamp(), record.data['UPDATE_DATE']) < 7) {

                return Ext.String.format(template, value);

            }
            else {
                return value;
            }

        }

    </script>
</head>
<body>
    <form id="EP_XM23001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Hidden ID="hid02_FILEID1" runat="server" />
    <ext:Hidden ID="hid02_FILEID2" runat="server" />
    <ext:Hidden ID="hid02_FILEID3" runat="server" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM23001" runat="server" Cls="search_area_title_name" Text="공지사항" />
                    <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_SUBJECT" runat="server" Text="Subject" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_SUBJECT" Width="250" Cls="inputText" runat="server" />
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model runat="server">
                                        <Fields>
                                            <ext:ModelField Name="NOTICE_SEQ" />
                                            <ext:ModelField Name="SUBJECT" />
                                            <ext:ModelField Name="IMPT_DIVNM" />
                                            <ext:ModelField Name="NOTICE_DATE" />
                                            <ext:ModelField Name="STATUS" />
                                            <ext:ModelField Name="UPDATE_DATE" />
                                        </Fields>
                                    </ext:Model>
                                </Model>
                                <Listeners>
                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                    <Load Delay="1" Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>
                                </Listeners>
                            </ext:Store>
                        </Store>
                        <Plugins>
                            <ext:BufferedRenderer ID="BufferedRenderer1" runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" runat="server" Width="40" Text="No" Align="Center" />
                                <ext:Column ID="NOTICE_SEQ" runat="server" Text="Seq" DataIndex="NOTICE_SEQ" Hidden="true" />
                                <ext:Column ID="SUBJECT" runat="server" Text="Subject" DataIndex="SUBJECT" Flex="1" Align="Left" >
                                    <Renderer Fn="TitleNew" />
                                </ext:Column>
                                <ext:Column ID="IMPT_DIVNM" runat="server" Text="Important" DataIndex="IMPT_DIVNM" Width="70" Align="Center" />
                                <ext:DateColumn ID="NOTICE_DATE" runat="server" Text="Date" DataIndex="NOTICE_DATE" Width="85" Align="Center" />
                                <ext:Column ID="STATUS" runat="server" Text="Status" DataIndex="STATUS" Width="65" Align="Center" />
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <DirectEvents> 
                            <Select OnEvent="RowSelect">
                                <ExtraParams>
                                    <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                </ExtraParams>
                            </Select>
                        </DirectEvents>
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."/>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>
            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="North" Height="26" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>
            <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
            <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="East" Width="650" StyleSpec="margin-top:0px; margin-left:10px;">
                <Content>
                    <table id="tableContent" style="height:0px">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 225px;" />
                            <col style="width: 100px;" />
                            <col style="width: 225px;" />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_NOTICE_BEG_DATE" runat="server" Text="시작일" />
                            </th>
                            <td>
                                <ext:DateField ID="df02_NOTICE_BEG_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                            </td>
                            <th class="ess">
                                <ext:Label ID="lbl02_NOTICE_END_DATE" runat="server" Text="종료일" />
                            </th>
                            <td>
                                <ext:DateField ID="df02_NOTICE_END_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_NOTICE_SEQ" runat="server" Text="번호" />
                            </th>
                            <td>
                                <ext:TextField ID="txt02_NOTICE_SEQ" runat="server" Width="220" Cls="inputText" ReadOnly="true"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_INSERT_ID" runat="server" Text="등록자" />
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="220" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt02_INSERT_ID" runat="server" Flex="1" Width="95" Cls="inputText" ReadOnly="true" StyleSpec="margin-right:5px;" />
                                        <ext:TextField ID="txt02_INSERT_NAME" runat="server" Width="120" Cls="inputText" ReadOnly="true"/>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_DIVISION" runat="server" Text="구분" />
                            </th>
                            <td>
                                <ext:Checkbox ID="chk02_NOTICE_DIV" Flex="1" runat="server" Width="220" Cls="inputText"  BoxLabel="공지종료"/>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_IMPT_DIV" runat="server" Text="중요도" />
                            </th>
                            <td>
                                <ext:RadioGroup ID="RadioGroup1" runat="server" Width="220" Cls="inputText"  ColumnsWidths="60,60,60">
                                    <Items>
                                        <ext:Radio ID="rdo02_GENERAL" Flex="1"  Cls="inputText"  runat="server" Checked="true" />
                                        <ext:Radio ID="rdo02_IMPORTANCE" Flex="1"  Cls="inputText"  runat="server" />
                                        <ext:Radio ID="rdo02_URGENCY" Flex="1"  Cls="inputText"  runat="server" />
                                    </Items>
                                </ext:RadioGroup>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl02_NOTICE_DIV2" runat="server"  Text="공지구분" />
                            </th>
                            <td>
                                <ext:CheckboxGroup ID="CheckboxGroup1" runat="server" Width="220" Cls="inputText"  ColumnsWidths="70,120">
                                    <Items>
                                        <ext:Checkbox ID="chk02_POP_YN" Flex="1"  Cls="inputText"  runat="server" BoxLabel="팝업공지" />
                                        <ext:Checkbox ID="chk02_PRE_LOGIN_YN" Flex="1"  Cls="inputText"  runat="server" BoxLabel="로그인 전 팝업공지" />
                                    </Items>
                                </ext:CheckboxGroup>
                            </td>
                            <th>
                                <ext:Label ID="lbl02_POP_DATE" runat="server" Text="팝업기간" />
                            </th>
                            <td>
                                <%--<ext:FieldContainer ID="CompositeField3" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>--%>
                                    <table id="table1" style="height:0px">
                                    <colgroup>
                                        <col style="width: 120px;" />
                                        <col style="width:  30px;" />
                                        <col style="width: 120px;" />
                                    </colgroup>
                                    <tr>
                                        <td><ext:DateField ID="df02_POP_BEG_DATE" Width="135"  Cls="inputDate" Type="Date" runat="server" Editable="true"   /></td>
                                        <td><ext:DisplayField ID="DisplayField1" Width="30" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " /></td>
                                        <td><ext:DateField ID="df02_POP_END_DATE" Width="135"  Cls="inputDate" Type="Date" runat="server" Editable="true"   /></td>                                        
                                    </tr>
                                    </table>
                                    <%--</Items>
                                </ext:FieldContainer>--%>
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_SUBJECT" runat="server" Text="제목" />
                            </th>
                            <td colspan="3">
                                <ext:TextField ID="txt02_SUBJECT" runat="server" Width="549" Cls="inputText"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl02_CONTENTS" runat="server" Text="내용" />
                            </th>
                            <td colspan="3">
                                <ext:HtmlEditor ID="heb02_CONTENTS" FontFamilies="Tahoma, Arial, 굴림, Gulim, Helvetica, AppleGothic, Malgun Gothic, 맑은 고딕, Verdana, Sans-serif" 
                                    runat="server" Width="549" HideLabel="true" Cls="inputText" Text="Mouse over toolbar for tooltips."/>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3">
                                <ext:Label ID="lbl02_ATTACH" runat="server" Text="첨부파일" />
                            </th>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer3" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID1" runat="server" Flex="1" Cls="inputText" ButtonText="Upload" Width="295">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID1_DEL" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <%--<ext:Hidden ID="hid02_FILEID1" runat="server" />--%>
                                        <ext:Hyperlink ID="dwn02_FILEID1" runat="server" Icon="Attach" Width="175" StyleSpec="color:#000;float:left;overflow:hidden"/>
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID2" runat="server" Flex="1" Cls="inputText" ButtonText="Upload" Width="295">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID2_DEL" runat="server" ToggleGroup="Group1" Width="69" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <%--<ext:Hidden ID="hid02_FILEID2" runat="server" />--%>
                                        <ext:Hyperlink ID="dwn02_FILEID2" runat="server" Icon="Attach" Width="175" StyleSpec="color:#000;float:left;overflow:hidden" />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <ext:FieldContainer ID="FieldContainer4" runat="server" Width="549" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:FileUploadField ID="fud02_FILEID3" runat="server" Flex="1"  Cls="inputText" ButtonText="Upload" Width="295">
                                        </ext:FileUploadField>
                                        <ext:ImageButton ID="btn01_FILEID3_DEL" runat="server" ToggleGroup="Group1" ImageUrl="../../images/btn/btn_upload_delete.gif"
                                            OverImageUrl="../../images/btn/btn_upload_delete.gif" DisabledImageUrl="../../images/btn/btn_upload_delete.gif"
                                            PressedImageUrl="../../images/btn/btn_upload_delete.gif">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" />
                                            </DirectEvents>
                                        </ext:ImageButton>
                                        <%--<ext:Hidden ID="hid02_FILEID3" runat="server" />--%>
                                        <ext:Hyperlink ID="dwn02_FILEID3" runat="server" Icon="Attach" Width="175" StyleSpec="color:#000;float:left;overflow:hidden" />
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

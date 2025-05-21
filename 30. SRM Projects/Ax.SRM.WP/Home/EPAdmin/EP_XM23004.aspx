<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EP_XM23004.aspx.cs" Inherits="Ax.EP.WP.Home.EPAdmin.EP_XM23004" %>
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
            App.Grid02.setHeight(App.Panel4.getHeight());

            if (App.heb02_CONTENTS) {
                // 내용창의 리사이징을 위해 기본값인 22로 복구했다가 다시 리사이징 처리
                App.heb02_CONTENTS.setHeight(22);
                App.ContentPanel.setHeight(App.GridPanel.getHeight() - App.Panel_North.getHeight());
                App.heb02_CONTENTS.setHeight(App.GridPanel.getHeight() - App.Panel_North.getHeight() - document.getElementById("tableContent").clientHeight + 22 - 3);
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

        //답글 등록
        var fn_Save_Reply = function () {
            Ext.Msg.confirm("ConFirm", getCodeMsg("COM-00909"), function (btn) {
                if (btn == 'yes') {
                    App.direct.Save_Reply();
                }
            });
        };

        //답글 삭제
        var fn_Delete_Reply = function (editor, command, row, rowIndex, colIndex) {
            var grd = editor.ownerCt.grid;

            var CORCD = grd.getStore().getAt(rowIndex).data["CORCD"];
            var NOTICE_SEQ = grd.getStore().getAt(rowIndex).data["NOTICE_SEQ"];
            var REPLY_SEQ = grd.getStore().getAt(rowIndex).data["REPLY_SEQ"];
            var INSERT_ID = grd.getStore().getAt(rowIndex).data["INSERT_ID"];

            Ext.Msg.confirm("ConFirm", getCodeMsg("COM-00801"), function (btn) {
                if (btn == 'yes') {
                    App.direct.Delete_Reply(rowIndex, CORCD, NOTICE_SEQ, REPLY_SEQ, INSERT_ID);
                }
            });
        }

    </script>

        <style type="text/css">
        .grid_area2 .x-layout-fit { border-top:2px solid #666; border-bottom:2px solid #666 !important;}
        /*x-grid-body x-panel-body-default x-layout-fit x-panel-body-default x-noborder-rbl*/
        .grid_area2 .x-grid-header-ct { display:none !important;}
        /*x-docked x-grid-header-ct-default x-docked-top x-grid-header-ct-docked-top x-grid-header-ct-default-docked-top x-box-layout-ct x-noborder-trl*/
        .grid_area2 .x-grid-row-alt { background:#fff !important;}
        .grid_area2 .x-grid-td{ background:#fff !important;}
         
        .grid_area2 .x-grid-with-col-lines .x-grid-cell {border-right-width: 0px !important;}
        .grid_area2 .x-grid-with-row-lines .x-grid-td {border-bottom-width: 0px !important;}
         
        .grid_area2 .x-grid-cell-CONTENTS{ color:#000 !important;}
        .grid_area2 .x-grid-cell-USER_ID{ color:#026fb3 !important;}
         
        .grid_area2 .inputc .x-form-field { background:#eaeaea;}
        .grid_area2 .x-form-text  {}  
        
        .grid_area2 .x-grid-cell-first .x-grid-cell-inner   { color:#026fb3 !important;}
        .grid_area2 .x-grid-cell-last .x-grid-cell-inner    { color:#000 !important;}
         
        .grid_area2 .x-grid-row-over .x-grid-cell-inner { color:#026fb3 !important;}
         
        .grid_area2 .x-grid-row-selected .x-grid-td {color:#000 !important;}
         
        .grid_area2 .x-grid-cell-CONTENTS .x-grid-cell-inner  {white-space:initial !important; height:auto !important;}   /* CONTENTS 컬럼 Height 및 자동 줄바꿈 처리 */
         
        .grid_area2 .x-grid-row-selected .x-grid-cell-USER_ID { color:#026fb3 !important;}    /* Selection 시 USER_ID  컬럼은 색깔 안바끼게 */
       
        .grid_area2 inputc .x-form-item-body   { width:100% !important;}
    </style>

</head>
<body>
    <form id="EP_XM23004" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Hidden ID="hid02_FILEID1" runat="server" />
    <ext:Hidden ID="hid02_FILEID2" runat="server" />
    <ext:Hidden ID="hid02_FILEID3" runat="server" />
    <ext:TextField ID="txt01_NOTICE_SEQ" runat="server" Hidden="true"/>
    <ext:TextField ID="txt01_INSERT_ID" runat="server" Hidden="true"/>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_EP_XM23004" runat="server" Cls="search_area_title_name" Text="공지사항" />
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
                            <col style="width: 150px;" />
                            <col style="width: 154px;" />
                            <col />   
                        </colgroup>
                        <tr>
                            <td style="height:30px;">
                                <ext:SelectBox ID="cbo01_PARAM" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="TYPENM" ValueField="OBJECT_ID" TriggerAction="All">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model4" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="TYPENM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>
                            <td>
                                <ext:TextField ID="txt01_PARAMT" Cls="inputText" runat="server" />
                            </td>
                            <td align="left">
                                <ext:Button ID="btn01_HR_SEARCH" TextAlign="Center" runat="server" >
                                    <DirectEvents>
                                        <Click OnEvent="etc_Button_Click"/>
                                    </DirectEvents>
                                </ext:Button>
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
                                    <ext:Model ID="Model1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="CORCD"/>
                                            <ext:ModelField Name="NOTICE_YN"/>
                                            <ext:ModelField Name="NOTICE_SEQ"/>
                                            <ext:ModelField Name="NOTICE_BEG_DATE"/>
                                            <ext:ModelField Name="NOTICE_END_DATE" />                                            
                                            <ext:ModelField Name="SUBJECT"/>
                                            <ext:ModelField Name="CONTENTS"/>
                                            <ext:ModelField Name="IMPT_DIV"/>
                                            <ext:ModelField Name="ATTACH_YN"/>
                                            <ext:ModelField Name="FILEID1"/>
                                            <ext:ModelField Name="FILEID2"/>
                                            <ext:ModelField Name="FILEID3"/>
                                            <ext:ModelField Name="INSERT_DATE"/>
                                            <ext:ModelField Name="INSERT_ID"/>
                                            <ext:ModelField Name="UPDATE_DATE"/>
                                            <ext:ModelField Name="UPDATE_ID"/>
                                            <ext:ModelField Name="WRITE_EMP"/>
                                            <ext:ModelField Name="HIT_COUNT"/>
                                            <ext:ModelField Name="IMPT_DIVNM"/>
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
                                <ext:Column ID="NOTICE_YN" ItemID="NOTICE_YN" runat="server" DataIndex="NOTICE_YN" Width="60" Align="Center" />  <%--Text="공지"--%> 
                                <ext:Column ID="IMPT_DIVNM" ItemID="IMPORTANCE" runat="server" DataIndex="IMPT_DIVNM" Width="60" Hidden="true" Align="Center" />  <%--Text="중요"--%> 
                                <ext:Column ID="ATTACH_YN" ItemID="ATTACHMENT" runat="server" DataIndex="ATTACH_YN" Width="60" Align="Center"  />  <%--Text="첨부"--%> 
                                <ext:Column ID="SUBJECT" ItemID="SUBJECT" runat="server" DataIndex="SUBJECT" MinWidth="150" Align="Left" Flex="1"   />  <%--Text="제목"--%> 
                                <ext:Column ID="WRITE_EMP" ItemID="WRITE_EMP" runat="server" DataIndex="WRITE_EMP" Width="100" Align="Center" />  <%--Text="작성자"--%> 
                                <ext:Column ID="INSERT_DATE" ItemID="WRITE_DAY" runat="server" DataIndex="INSERT_DATE" Width="80" Align="Center" />  <%--Text="게시일자"--%> 
                                <ext:Column ID="HIT_COUNT" ItemID="HIT_COUNT" runat="server" DataIndex="HIT_COUNT" Width="60" Align="Center" Hidden="true" />  <%--Text="조회수"--%> 
                                <ext:Column ID="CORCD" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="NOTICE_SEQ" ItemID="NOTICE_SEQ" runat="server" DataIndex="NOTICE_SEQ" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="NOTICE_BEG_DATE" ItemID="NOTICE_BEG_DATE" runat="server" DataIndex="NOTICE_BEG_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="NOTICE_END_DATE" ItemID="NOTICE_END_DATE" runat="server" DataIndex="NOTICE_END_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="CONTENTS" ItemID="CONTENTS" runat="server" DataIndex="CONTENTS" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="IMPT_DIV" ItemID="IMPT_DIV" runat="server" DataIndex="IMPT_DIV" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FILEID1" ItemID="FILEID1" runat="server" DataIndex="FILEID1" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FILEID2" ItemID="FILEID2" runat="server" DataIndex="FILEID2" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="FILEID3" ItemID="FILEID3" runat="server" DataIndex="FILEID3" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="INSERT_ID" ItemID="INSERT_ID" runat="server" DataIndex="INSERT_ID" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="UPDATE_DATE" ItemID="UPDATE_DATE" runat="server" DataIndex="UPDATE_DATE" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="UPDATE_ID" ItemID="UPDATE_ID" runat="server" DataIndex="UPDATE_ID" Width="0" Align="Left" />  <%--Text=""--%> 
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="1" Flex="1" Align="Left" />  <%--Text=""--%> 
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
            <ext:Panel ID="Panel1" Region="East" runat="server">
                <Items>
                    <%--ContentPanel 의 Width, StyleSpec 내용은 Region 이 South 일 경우 필요 없음--%>
                    <ext:Panel ID="ContentPanel" Cls="bottom_area_table" runat="server" Region="Center" Width="650" StyleSpec="margin-top:0px; margin-left:10px;">
                        <Content>
        <table id="tableContent" style="height:0px">
                                <colgroup>
                                    <col style="width: 100px;" />
                                    <col style="width: 250px;" />
                                    <col style="width: 100px;" />
                                    <col />
                                </colgroup>
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl02_WRITE_EMP" runat="server"  /><%--Text="작성자"--%>
                                    </th>
                                    <td>
                                        <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="220" Layout="TableLayout">
                                            <Items>
                                                <ext:TextField ID="txt02_INSERT_ID" runat="server" Flex="1" Width="95" Cls="inputText" ReadOnly="true" StyleSpec="margin-right:5px;" />
                                                <ext:TextField ID="txt02_INSERT_NAME" runat="server" Width="120" Cls="inputText" ReadOnly="true"/>
                                            </Items>
                                        </ext:FieldContainer>
                                    </td>
                                    <th>
                                        <ext:Label ID="lbl02_NOTICE_YN" runat="server"  /><%--Text="공지"--%>
                                    </th>
                                    <td>
                                        <ext:Checkbox ID="chk02_NOTICE_YN" runat="server" Text="" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="ess">
                                        <ext:Label ID="lbl02_WRITE_DAY" runat="server"  /><%--Text="게시일자"--%>
                                    </th>
                                    <td>
                                        <ext:DateField ID="df02_NOTICE_BEG_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                    </td>
                                    <th class="ess">
                                        <ext:Label ID="lbl02_EXPIR_DATE" runat="server"  /><%--Text="만료일자"--%>
                                    </th>
                                    <td>
                                        <ext:DateField ID="df02_NOTICE_END_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl02_IMPT_DIV" runat="server"  /><%--Text="중요도"--%>
                                    </th>
                                    <td>
                                        <ext:RadioGroup ID="RadioGroup1" runat="server" Width="220" Cls="inputText"  ColumnsWidths="60,60,60">
                                            <Items>
                                                <ext:Radio ID="rdo02_GENERAL" Flex="1"  Cls="inputText"  runat="server" Checked="true" />
                                                <ext:Radio ID="rdo02_IMPORTANT" Flex="1"  Cls="inputText"  runat="server" />
                                                <ext:Radio ID="rdo02_URGENCY" Flex="1"  Cls="inputText"  runat="server" />
                                            </Items>
                                        </ext:RadioGroup>
                                    </td>
                                    <th class="ess">
                                        <ext:Label ID="lbl02_WRITE_DATE" runat="server"  /><%--Text="작성일자"--%>
                                    </th>
                                    <td>
                                        <ext:DateField ID="df02_INSERT_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="false" ReadOnly="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th rowspan="3">
                                        <ext:Label ID="lbl02_ATTACH" runat="server" /><%--Text="첨부파일" --%>
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
                                <tr>
                                    <th class="ess">
                                        <ext:Label ID="lbl02_SUBJECT" runat="server" /><%--Text="제목" --%>
                                    </th>
                                    <td colspan="3">
                                        <ext:TextField ID="txt02_SUBJECT" runat="server"  Width="549" Cls="inputText"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="ess">
                                        <ext:Label ID="lbl02_CONTENTS" runat="server"  /><%--Text="내용"--%>
                                    </th>
                                    <td colspan="3">
                                        <ext:HtmlEditor ID="heb02_CONTENTS" FontFamilies="Tahoma, Arial, 굴림, Gulim, Helvetica, AppleGothic, Malgun Gothic, 맑은 고딕, Verdana, Sans-serif" 
                                            runat="server" Width="549" HideLabel="true" Cls="inputText" />
                                    </td>
                                </tr>
                            </table>
                        </Content>
                    </ext:Panel>
                    <ext:Panel ID="Panel_North" Region="North" Cls="lrmargin10" Width="650" Height="127" runat="server" StyleSpec="padding-top:2px !important">
                        <Items>
                            <ext:Panel ID="Panel3" runat="server" Region="South" Layout="BorderLayout" Height="100" Padding="10">
                                <Items>
                                    <ext:Panel ID="Panel4" Region="Center" Border="false" runat="server" Cls="grid_area2" StyleSpec="border-top:none !important;">
                                        <Items>
                                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true">
                                                <Store>
                                                    <ext:Store ID="Store2" runat="server" PageSize="50">
                                                        <Model>
                                                            <ext:Model ID="Model2" runat="server">
                                                                <Fields>
                                                                    <ext:ModelField Name="CORCD"/>
                                                                    <ext:ModelField Name="NOTICE_SEQ"/>
                                                                    <ext:ModelField Name="REPLY_SEQ"/>
                                                                    <ext:ModelField Name="CONTENTS"/>
                                                                    <ext:ModelField Name="USER_ID"/>
                                                                    <ext:ModelField Name="INSERT_ID"/>
                                                                    <ext:ModelField Name="UPDATE_DATE"/>
                                                                    <ext:ModelField Name="UPDATE_ID"/>
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
                                                    <ext:BufferedRenderer ID="BufferedRenderer2" runat="server"/>
                                                </Plugins>  
                                                <ColumnModel ID="ColumnModel2" runat="server">
                                                    <Columns>
                                                        <ext:RowNumbererColumn ID="RowNumbererColumn1" runat="server" Width="0" Text="No" Align="Center" Hidden="true" />
                                                         <%-- 그리드에 이미지를 클릭할 수 있는 column (팝업을 위한 그리드의 돋보기 버튼)--%>
                                                        <ext:ImageCommandColumn ID="ImageCommandColumn1" MenuDisabled="true" Resizable="false" Sortable="false" runat="server" Width="22" Align="Center" >
                                                           <Commands>
                                                              <ext:ImageCommand Icon="Delete" ToolTip-Text="Delete Contents" CommandName="search" Style="margin: 3px 0px 0px 2px !important;" />      
                                                           </Commands>
                                                           <Listeners>
                                                              <Command Fn="fn_Delete_Reply" />                                         
                                                           </Listeners>
                                                        </ext:ImageCommandColumn>  
                                                        <ext:Column ID="Column2" ItemID="CORCD" runat="server" DataIndex="CORCD" Width="0" Align="Center" Hidden="true" />  <%--Text="중요"--%> 
                                                        <ext:Column ID="Column3" ItemID="NOTICE_SEQ" runat="server" DataIndex="NOTICE_SEQ" Width="0" Align="Center" Hidden="true" />  <%--Text="첨부"--%> 
                                                        <ext:Column ID="REPLY_SEQ" ItemID="REPLY_SEQ" runat="server" DataIndex="REPLY_SEQ" Width="0" Align="Left" Flex="1" Hidden="true" />  <%--Text="제목"--%> 
                                                        <ext:Column ID="USER_ID" ItemID="USER_ID" runat="server" DataIndex="USER_ID" Width="180" Align="Left" />  <%--Text="작성자"--%> 
                                                        <ext:Column ID="Column4" ItemID="CONTENTS" runat="server" DataIndex="CONTENTS" Align="Left" Flex="1" />  <%--Text="내용"--%> 
                                                        <ext:Column ID="Column5" ItemID="INSERT_ID" runat="server" DataIndex="INSERT_ID" Width="0" Align="Center" Hidden="true"/>  <%--Text="게시일자"--%> 
                                                        <ext:Column ID="Column6" ItemID="UPDATE_DATE" runat="server" DataIndex="UPDATE_DATE" Width="0" Align="Center" Hidden="true"/>  <%--Text="조회수"--%> 
                                                        <ext:Column ID="Column7" ItemID="UPDATE_ID" runat="server" DataIndex="UPDATE_ID" Width="0" Align="Left" Hidden="true"/>  <%--Text=""--%>   
                                                    </Columns>
                                                </ColumnModel>
                                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                                    <LoadMask ShowMask="true" />
                                                </Loader>
                                                <View>
                                                    <ext:GridView EnableTextSelection="true" ID="GridView1" runat="server"/>
                                                </View>
                                                <SelectionModel>
                                                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                                </SelectionModel>
                                              <%--  <DirectEvents>                         
                                                    <Select OnEvent="RowSelect">
                                                        <ExtraParams>
                                                            <ext:Parameter Name="Values" Value="this.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                        </ExtraParams>
                                                    </Select>
                                                </DirectEvents>--%>
                                            </ext:GridPanel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:Panel>                            
                            <ext:Panel ID="Panel2" Region="North" Cls="lrmargin10" Width="650" runat="server" StyleSpec="padding-top:2px !important">
                                <Content>
                                   <table id="table1" style="width:650px; height:30px;" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <ext:FieldContainer ID="FieldContainer5" runat="server" Width="650" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                                <Items>
                                                    <ext:Label ID="Label1" runat="server" Text="1 Line Answer : " />
                                                    <ext:Label ID="lbl01_USER_ID" runat="server" />
                                                    <ext:TextField ID="txt01_WRITE_TXT" Cls="inputText" Width="490" runat="server" />
                                                    <ext:Button ID="btn01_Upload" runat="server" TextAlign="Center" Text="Register"> <%--Text="해당권한을 아래로 추가"--%>
                                                        <Listeners>
                                                            <Click Fn="fn_Save_Reply" />
                                                        </Listeners>
                                                    </ext:Button>  
                                                </Items>
                                            </ext:FieldContainer>
                                        </tr>
                                    </table>
                                </Content>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

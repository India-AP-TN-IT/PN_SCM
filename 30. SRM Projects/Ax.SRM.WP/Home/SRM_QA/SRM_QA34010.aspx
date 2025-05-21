<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA34010.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA34010" %>
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

    <title>MS/ES 스펙 조회</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=20150529080000" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        // 열람 사유 입력 팝업 표시
        function fn_PopupHandler(rowIndex, FILEID, DOCNO) {

            App.CodeRow.setValue(rowIndex);

            App.FILEID.setValue(FILEID);
            App.DOCNO.setValue(DOCNO);
            App.btn01_POP_QA34010P1.fireEvent('click');
        }

    
        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;


            var FILEID = grid.getStore().getAt(rowIndex).data["FILEID"];
            var DOCNO = grid.getStore().getAt(rowIndex).data["DOCNO"];

            //열람사유 입력 팝업을 띄운다.
            fn_PopupHandler(rowIndex, FILEID, DOCNO);
        }

        //열람사유 입력시 
        var fn_PDF = function (url) {
            ShowPdf(url);
        };
    </script>
</head>
<body>
    <form id="SRM_QA34010" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_QA34010P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="CodeRow"             runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField   ID="FILEID"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 FILEID을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="DOCNO"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 DOCNO을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SRM_QA/SRM_QA34010P1.aspx"></ext:TextField> 
    <ext:TextField   ID="PopupWidth"          runat="server" Hidden="true" Text="530"></ext:TextField> 
    <ext:TextField   ID="PopupHeight"         runat="server" Hidden="true" Text="250"></ext:TextField> 

    <ext:Viewport ID="UIContainer" AutoScroll="true" runat="server" Layout="BorderLayout" Padding="10">
<%--        <CustomConfig>
            <ext:ConfigItem Name="autoScroll" Value="true"></ext:ConfigItem>
        </CustomConfig>
        <Defaults>
            <ext:Parameter Name="autoScroll" Value="true"></ext:Parameter>
        </Defaults>--%>
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA34010" runat="server" Cls="search_area_title_name" /><%--Text="MS/ES스펙 조회" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server">
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>                        
                        <tr>                            
                            <th>
                                <ext:Label ID="lbl01_SPEC_NO" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_SPEC_NO"  runat="server" Width="150" Cls="inputText" />
                            </td>  
                            <th>
                                <ext:Label ID="lbl01_LANG" runat="server" />
                            </th>
                            <td>
                               <ext:SelectBox ID="cbo01_LANG_DIV" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>                              
                            <th>
                                <ext:Label ID="lbl01_SUBJECT" runat="server" /><%--Text="제목" />--%>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer14" runat="server" Width="300" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>   
                                        <ext:TextField ID="txt01_SUBJECT"  runat="server" Width="150" Cls="inputText" style="margin-right: 5px" />
                                        <ext:Checkbox ID="chk01_LAST_2MONTH" runat="server" Width="150" Cls="inputText" />
                                    </Items>
                                </ext:FieldContainer>  
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>
                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server" PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField NAME="SPEC_NO" />
                                            <ext:ModelField NAME="EONO" />
								            <ext:ModelField NAME="RENEW_DATE" />
								            <ext:ModelField NAME="LANG_DIV" />
                                            <ext:ModelField NAME="DEGREE" />
                                            <ext:ModelField NAME="SUBJECT"       />   
								            <ext:ModelField NAME="FILE_SIZE" />                               
                                            <ext:ModelField NAME="FILENAME" />                               
                                            <ext:ModelField NAME="PATH" />
                                            <ext:ModelField NAME="FILEID" />     
                                            <ext:ModelField NAME="DOCNO" />                                                
                                            <ext:ModelField NAME="UPDATE_ID" />                                                
                                            <ext:ModelField NAME="INSERT_ID" />                                                
                                            <ext:ModelField NAME="LINENM" />    
                                            <ext:ModelField NAME="REG_DATE" />
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
                            <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                <ext:Column ID="SPEC_NO" ItemID="SPEC_NO" runat="server" DataIndex="SPEC_NO" Width="200" Align="Left" /> <%--Text="스펙명"--%>
                                <ext:Column ID="EONO" ItemID="EONO" runat="server" DataIndex="EONO" Width="110" Align="Left" /> <%--Text="EONO"--%>
                                <ext:DateColumn ID="RENEW_DATE" ItemID="RENEW_DATE" runat="server" DataIndex="RENEW_DATE" Width="120" Align="Center" /> <%--Text="갱신일"--%>
                                <ext:Column ID="LANG_DIV" ItemID="LANG" runat="server" DataIndex="LANG_DIV" Width="80" Align="Center" /> <%--Text="언어"--%>
                                <ext:Column ID="DEGREE" ItemID="DEGREE" runat="server" DataIndex="DEGREE" Width="60" Align="Center" /> <%--Text="차수"--%>
                                <ext:Column ID="SUBJECT" ItemID="SUBJECT" runat="server" DataIndex="SUBJECT" Width="100" Align="Left" Flex="1"/> <%--Text="제목"--%>
                                <ext:NumberColumn ID="FILE_SIZE" ItemID="FILE_SIZE2" runat="server" DataIndex="FILE_SIZE" Width="100" Align="Right" Format="#,##0" Sortable="true"/> <%--Text="파일사이즈"--%>
                                <ext:Column ID="REG_LINENM" ItemID="REG_LINENM" runat="server" DataIndex="LINENM" Width="90" Align="Left"/> <%--Text="등록부서"--%>
                                <ext:Column ID="FSTINPUTID" ItemID="FSTINPUTID" runat="server" DataIndex="INSERT_ID" Width="90" Align="Center"/> <%--Text="최초등록자"--%>
                                <ext:Column ID="FNLUPDATEID" ItemID="FNLUPDATEID" runat="server" DataIndex="UPDATE_ID" Width="90" Align="Center"/> <%--Text="최종수정자"--%>
                                <ext:Column ID="REG_DATE" ItemID="REG_DATE" runat="server" DataIndex="REG_DATE" Width="80" Align="Center"/> <%--Text="등록일자"--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" Mode="Single"/>
                        </SelectionModel>
                        <Listeners>
                                <CellDblClick Fn ="CellDbClick"></CellDblClick>
                        </Listeners>                                              
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>                      
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

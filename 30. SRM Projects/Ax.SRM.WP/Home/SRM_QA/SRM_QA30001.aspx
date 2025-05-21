<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA30001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA30001" %>
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

    <title>입고품 불량내용 조회</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
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

        function fn_PopupHandler(rowIndex, BIZCD, INSPECT_DIV, VENDCD, RCV_DATE, DEFNO){

            App.CodeRow.setValue(rowIndex);
            App.V_BIZCD.setValue(BIZCD);
            App.V_INSPECT_DIV.setValue(INSPECT_DIV);
            App.V_VENDCD.setValue(VENDCD);
            App.RCV_DATE02.setValue(RCV_DATE);
            App.DEFNO02.setValue(DEFNO);
            PopUpFire();
        }

        var PopUpFire = function () {

            App.btn01_POP_QA30001P1.fireEvent('click');
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

            var BIZCD = grid.getStore().getAt(rowIndex).data["BIZCD"];
            var INSPECT_DIV = grid.getStore().getAt(rowIndex).data["INSPECT_DIVCD"];
            var VENDCD = grid.getStore().getAt(rowIndex).data["VENDCD"];
            var RCV_DATE = grid.getStore().getAt(rowIndex).data["RCV_DATE"];
            var DEFNO = grid.getStore().getAt(rowIndex).data["DEFNO"];

            fn_PopupHandler(rowIndex, BIZCD, INSPECT_DIV, VENDCD, RCV_DATE, DEFNO);
        }
    
    </script>
</head>
<body>
    <form id="SRM_QA30001" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:ImageButton ID="btn01_POP_QA30001P1" runat="server" Hidden="true" ImageUrl="../../images/btn/btn_search_s.gif" Cls="btn" OnDirectClick="etc_Button_Click" />
    <ext:TextField   ID="CodeRow"             runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField   ID="RCV_DATE02"          runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 납품일자값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="DEFNO02"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 납품차수값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_BIZCD"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 V_BIZCD 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_INSPECT_DIV"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_INSPECT_DIV 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="V_VENDCD"             runat="server" Hidden="true" ></ext:TextField> <%--팝업호출시 그리드의 V_VENDCD 팝업에 넘기기 위해서 사용--%>
    <ext:TextField   ID="UserHelpURL"         runat="server" Hidden="true" Text="../SRM_QA/SRM_QA30001P1.aspx"></ext:TextField> 
    <ext:TextField   ID="PopupWidth"          runat="server" Hidden="true" Text="860"></ext:TextField> 
    <ext:TextField   ID="PopupHeight"         runat="server" Hidden="true" Text="630"></ext:TextField> 

    <ext:Viewport ID="UIContainer" AutoScroll="true" runat="server" Layout="BorderLayout" Padding="10">
<%--    <CustomConfig>
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
                    <ext:Label ID="lbl01_SRM_QA30001" runat="server" Cls="search_area_title_name" /><%--Text="입고품 불량내용 조회" />--%>
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
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>                            
                            <th >
                                <ext:Label ID="lbl01_SAUP" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_BIZCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="BIZNM" ValueField="BIZCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store5" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="BIZCD" />
                                                        <ext:ModelField Name="BIZCDTYPE" />
                                                        <ext:ModelField Name="BIZNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>  
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>                              
                            <th class="ess">
                                <ext:Label ID="lbl01_STD_YYMM" runat="server" /><%--Text="기준년월" />--%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_RCV_DATE" Width="115"  Cls="inputDate" Type="Month" runat="server" Editable="true"   />
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
                                            <ext:ModelField NAME="INSPECT_DIVCD" />
								            <ext:ModelField NAME="INSPECT_DIV" />
								            <ext:ModelField NAME="VEND_STATUS" />
                                            <ext:ModelField NAME="RCV_DATE"       />   
								            <ext:ModelField NAME="DEFNO" />                               
                                            <ext:ModelField NAME="VINCD" />                               
                                            <ext:ModelField NAME="DEF_PNO" />
                                            <ext:ModelField NAME="PARTNM" />     
                                            <ext:ModelField NAME="DEFNM" />                             
								            <ext:ModelField NAME="DEF_PLACECD" />  
								            <ext:ModelField NAME="NAME_KOR" />                                  
								            <ext:ModelField NAME="REPLY_DEM_DATE" />
								            <ext:ModelField NAME="RECEIPT_DATE"/>
								            <ext:ModelField NAME="PID" />                                               
                                            <ext:ModelField NAME="VENDCD" />                                               
                                            <ext:ModelField NAME="BIZCD" />                                               
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
                                <ext:Column ID="INSPECT_DIVCD" ItemID="INSPECT_DIVCD" runat="server" DataIndex="INSPECT_DIVCD" Width="0" Align="Center" Hidden="true" /> <%--Text="구분코드"--%>
                                <ext:Column ID="INSPECT_DIV" ItemID="DIVISION" runat="server" DataIndex="INSPECT_DIV" Width="60" Align="Center" /> <%--Text="구분"--%>
                                <ext:Column ID="VEND_STATUS" ItemID="STATE" runat="server" DataIndex="VEND_STATUS" Width="60" Align="Center" /> <%--Text="상태"--%>
                                <ext:DateColumn ID="RCV_DATE" ItemID="OCCUR_DATE" runat="server" DataIndex="RCV_DATE" Width="80" Align="Center" /> <%--Text="발생일자"--%>
                                <ext:Column ID="DEFNO" ItemID="SERNO" runat="server" DataIndex="DEFNO" Width="100" Align="Center" /> <%--Text="순번"--%>
                                <ext:Column ID="VINCD" ItemID="VIN" runat="server" DataIndex="VINCD" Width="60" Align="Center" /> <%--Text="차종"--%>
                                <ext:Column ID="DEF_PNO" ItemID="PARTNO" runat="server" DataIndex="DEF_PNO" Width="120" Align="Left" /> <%--Text="품번"--%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="200" Align="Left" Flex="1" /> <%--Text="품명"--%>
                                <ext:Column ID="DEFNM" ItemID="DEF_CNTT" runat="server" DataIndex="DEFNM" MinWidth="120" Align="Left" Flex="1" /> <%--Text="불량내용"--%>
                                <ext:Column ID="DEF_PLACECD" ItemID="DEF_PLACE" runat="server" DataIndex="DEF_PLACECD" Width="120" Align="Left" /> <%--Text="불량장소"--%>
                                <ext:Column ID="NAME_KOR" ItemID="WRITE_EMP" runat="server" DataIndex="NAME_KOR" Width="80" Align="Center" /> <%--Text="작성자"--%>
                                <ext:DateColumn ID="REPLY_DEM_DATE" ItemID="REPLY_DEM_DATE" runat="server" DataIndex="REPLY_DEM_DATE" Width="80" Align="Center" /> <%--Text="회신요구일"--%>
                                <ext:DateColumn ID="RECEIPT_DATE" ItemID="WKDATE" runat="server" DataIndex="RECEIPT_DATE" Width="80" Align="Center" /> <%--Text="수신일자"--%>
                                <ext:Column ID="PID" ItemID="PID" runat="server" DataIndex="PID" Width="80" Align="Center" Hidden="true" /><%--Text="화면ID"--%>
                                <ext:Column ID="VENDCD" ItemID="VEND" runat="server" DataIndex="VENDCD" Width="0" Align="Center" Hidden="true" /><%--Text=""--%>
                                <ext:Column ID="BIZCD" ItemID="SAUP" runat="server" DataIndex="BIZCD" Width="0" Align="Center" Hidden="true" /><%--Text=""--%>
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

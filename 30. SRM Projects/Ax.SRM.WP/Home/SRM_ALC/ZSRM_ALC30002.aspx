<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ZSRM_ALC30002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_ALC.ZSRM_ALC30002" %>
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

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        var interval;

        function UI_Shown() {
            this.UI_Resize();

           // setInterval("dataRefresh();", 60000);
            //dataRefresh();
        }

        function dataRefresh(){
            App.ButtonSearch.fireEvent('click');
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

        var fn_SetYmdDateChange = function () {
            App.direct.SetYmdDateChange();
        };

    </script>
</head>
<body>
    <form id="ZSRM_ALC30002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_INTERVAL" runat="server" Hidden="true" ></ext:TextField>  

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_ZSRM_ALC30002" runat="server" Cls="search_area_title_name" Text="ALC 수신현황 조회" />
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
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
                            <th class="ess">
                                <ext:Label ID="lbl01_DD" runat="server" /> <%--Text="일자" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_QUT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true">
                                </ext:DateField>
                            </td>
                            <td>
                                <%--//Refreshes every 60 seconds--%>
                            </td>
                            <td>
                            </td>
                            <td></td>
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
                                            <ext:ModelField Name="PARTNER"/>
                                            <ext:ModelField Name="YMD"/>
                                            <ext:ModelField Name="TIME"/>
                                            <ext:ModelField Name="VID"/>
                                            <ext:ModelField Name="ORDNO"/>
                                            <ext:ModelField Name="DRV"/>
                                            <ext:ModelField Name="MODEL"/>
                                            <ext:ModelField Name="DTFL"/>
                                            <ext:ModelField Name="DTFR"/>
                                            <ext:ModelField Name="DTRL"/>
                                            <ext:ModelField Name="DTRR"/>
                                            <ext:ModelField Name="CP"/>
                                            <ext:ModelField Name="CS"/>
                                            <ext:ModelField Name="BZ"/>
                                            <ext:ModelField Name="CU"/>
                                            <ext:ModelField Name="LOT_DTFL"/>
                                            <ext:ModelField Name="LOT_DTFR"/>
                                            <ext:ModelField Name="LOT_DTRL"/>
                                            <ext:ModelField Name="LOT_DTRR"/>
                                            <ext:ModelField Name="LOT_CP"/>
                                            <ext:ModelField Name="LOT_CS"/>
                                            <ext:ModelField Name="LOT_BZ"/>
                                            <ext:ModelField Name="LOT_CU"/>
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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Text="No"        Width="50" Align="Center"/>
                                <ext:Column ID="PARTNER" ItemID="PARTNER" runat="server" DataIndex="PARTNER" Width="70" Align="Center" Text="PARTNER" /> 
                                <ext:Column ID="YMD" ItemID="YMD" runat="server" DataIndex="YMD" Width="90" Align="Center" Text="YMD" /> 
                                <ext:Column ID="TIME" ItemID="TIME" runat="server" DataIndex="TIME" Width="70" Align="Center" Text="TIME" /> 
                                <ext:Column ID="VID" ItemID="VID" runat="server" DataIndex="VID" Width="90" Align="Center" Text="VID" /> 
                                <ext:Column ID="ORDNO" ItemID="ORDNO" runat="server" DataIndex="ORDNO" Width="60" Align="Center" Text="ORDNO" /> 
                                <ext:Column ID="DRV" ItemID="DRV" runat="server" DataIndex="DRV" Width="40" Align="Center" Text="DRV" /> 
                                <ext:Column ID="MODEL" ItemID="MODEL" runat="server" DataIndex="MODEL" Width="60" Align="Center" Text="MODEL" /> 
                                <ext:Column ID="DTFL" ItemID="DTFL" runat="server" DataIndex="DTFL" Width="50" Align="Center" Text="DTFL" /> 
                                <ext:Column ID="DTFR" ItemID="DTFR" runat="server" DataIndex="DTFR" Width="50" Align="Center" Text="DTFR" /> 
                                <ext:Column ID="DTRL" ItemID="DTRL" runat="server" DataIndex="DTRL" Width="50" Align="Center" Text="DTRL" /> 
                                <ext:Column ID="DTRR" ItemID="DTRR" runat="server" DataIndex="DTRR" Width="50" Align="Center" Text="DTRR" /> 
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
                                          
                        <BottomBar>
                            <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                            <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                        </BottomBar>
                    </ext:GridPanel>
                </Items>
            </ext:Panel>

            <%--그리드와 내용사이에 하단 버튼영역이 필요할경우 아래 패널 사용(Hidden = "false") --%>
            <ext:Panel ID="BottomButtonPanel" runat="server" Region="South" Height="23" Cls="bottom_area_btn" Hidden="true">
                <Items>
                    <%-- 하단 이미지버튼 샘플 및 사용자 버튼 정의 --%>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_addrow.gif" Cls="pr5" ID="btnRowAdd"></ext:ImageButton>
                    <ext:ImageButton runat="server" ImageUrl="../../images/btn/btn_deleterow.gif" ID="btnRowDelete"></ext:ImageButton>
                </Items>
            </ext:Panel>            
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

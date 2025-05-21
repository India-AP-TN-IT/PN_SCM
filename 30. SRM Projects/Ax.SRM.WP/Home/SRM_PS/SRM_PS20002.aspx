<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_PS20002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_PS.SRM_PS20002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico" />
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

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            App.direct.MakePopUp(grid.getStore().getAt(rowIndex).data["PARTNO"], "V");
        }
          
    </script>
</head>
<body>
    <form id="SRM_PS20002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_PS20002" runat="server" Cls="search_area_title_name" />
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" /
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_CUSTNM" runat="server" Text="법인명"/>
                            </th>
                            <td>
<%--                                <ext:ComboBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" 
                                    TriggerAction="All" Width="172" Editable="false">
                                    <Items>                                                         
                                        <ext:ListItem Value="%" Text="전체" />
                                        <ext:ListItem Value="20000" Text="강소서연이화" />
                                        <ext:ListItem Value="20001" Text="북경서연" />
                                        <ext:ListItem Value="20003" Text="요녕서연이화" />
                                        <ext:ListItem Value="20004" Text="서연이화인디아" />
                                        <ext:ListItem Value="20005" Text="서연이화첸나이" />
                                        <ext:ListItem Value="20006" Text="서연이화슬로박" />
                                        <ext:ListItem Value="20007" Text="서연이화알라바마" />
                                        <ext:ListItem Value="20008" Text="서연이화조지아" />
                                        <ext:ListItem Value="20009" Text="서연이화브라질" />
                                        <ext:ListItem Value="20010" Text="앗싼한일" />
                                        <ext:ListItem Value="20393" Text="서연이화폴란드" />
                                        <ext:ListItem Value="20412" Text="서연이화멕시코" />
                                        <ext:ListItem Value="20732" Text="북기한일(창주)" />
                                        <ext:ListItem Value="20733" Text="북기한일(중경)" />
                                    </Items>
                                </ext:ComboBox>--%>
                                <ext:SelectBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="172" >
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model5" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="ID" />
                                                        <ext:ModelField Name="NAME" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    </ext:SelectBox> 
                            </td>
                            <th>
                                <ext:Label ID="lbl01_VINNM" runat="server" Text="차종"/>
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VINCD" runat="server" HelperID="HELP_TYPECD" PopupMode="Search" PopupType="CodeWindow" ClassID="A3" />
                            </td>
                            <th >
                                <ext:Label ID="Label1" runat="server" Text="유형"/>
                            </th>
                            <td colspan="3">
                                <ext:ComboBox ID="cbo01_TYPE" runat="server"  Mode="Local" 
                                    TriggerAction="All" Width="172" Editable="false">
                                    <Items> 
                                        <ext:ListItem Value="%" Text="전체" />                                               
                                        <ext:ListItem Value="업체" Text="업체" />
                                        <ext:ListItem Value="포장장" Text="포장장" />
                                    </Items>
                                </ext:ComboBox>   
                            </td>
                        </tr> 
                        <tr>
                            <th>
                               <ext:Label ID="Label76" runat="server" Text="공급업체(포장업체)"/>
                            </th>
                            <td>                                 
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"  />
                            </td>
                            <th>         
                                <ext:Label ID="Label121" runat="server" Text="PART NO"/>
                            </th>
                            <td colspan="2">
                                <ext:TextField ID="txt01_PARTNO"  runat="server" Width="255" Cls="inputText" />
                            </td>
                            <td colspan="3" > 
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="175" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:Button StyleSpec="float:left; margin-left:5px; width:80px;" ID="btn01_NEW" runat="server" TextAlign="Center" Text ="신규">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" ></Click>
                                            </DirectEvents>
                                        </ext:Button>                                       
                                        <ext:Button ID="btn01_MODIFY" runat="server" TextAlign="Center" StyleSpec="float:left; margin-left:5px; width:80px;" Text="수정">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
                                        <ext:Button ID="btn01_DELETE" runat="server" TextAlign="Center" StyleSpec="float:left; margin-left:5px; width:80px;" Text="삭제">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >
                                                    <Confirmation ConfirmRequest="true" Title="Confirm" Message="삭제하시겠습니까?" />
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
                                        <ext:Button ID="btn01_PRINT" runat="server" TextAlign="Center" StyleSpec="float:left; margin-left:5px; width:80px;" Text="출력">
                                            <DirectEvents>
                                                <Click OnEvent="etc_Button_Click" >       
                                                    <Confirmation ConfirmRequest="true" Title="Confirm" Message="출력하시겠습니까?" />                                             
                                                    <ExtraParams>
                                                        <ext:Parameter Name="Values" Value="App.Grid01.getRowsValues({selectedOnly:true})" Mode="Raw" Encode="true" />
                                                    </ExtraParams>
                                                </Click>
                                            </DirectEvents>
                                        </ext:Button> 
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
                                            <ext:ModelField Name="R_NUMBER" />
                                            <ext:ModelField Name="CUSTCD" />                                            
                                            <ext:ModelField Name="CUSTNM" />  
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="VENDCD" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                                                                        
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
                                <ext:NumberColumn      ID="R_NUMBER"         ItemID="R_NUMBER"         runat="server" DataIndex="R_NUMBER"    Width="50"  Align="Center"  Format="#,##0" Text="No"/>
                                <ext:Column            ID="CUSTNM" ItemID="CUSTNM" runat="server" DataIndex="CUSTNM" Width="120"  Align="Left" Text="법인명"/>
                                <ext:Column            ID="VINNM" ItemID="VINNM" runat="server" DataIndex="VINNM" Width="70"  Align="Center" Text="차종"/>
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="120"  Align="Left" Text="업체명"/>
                                <ext:Column            ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left" Text="품번"/>
                                <ext:Column            ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" Width="250"  Align="Left"  Text="품명"/>
                                <%--<ext:Column            ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120"  Align="Left" Text="동일품번"/>--%>
                               <%-- <ext:Column ID="PART_INFO"          ItemID="PART_INFO"  runat="server" Text="부품 사이즈">
                                    <Columns>
                                        <ext:NumberColumn      ID="PART_SIZE_X"         ItemID="PART_SIZE_X"         runat="server" DataIndex="PART_SIZE_X"    Width="90"  Align="Right"  Format="#,##0.##" Text="가로(mm)"/>
                                        <ext:NumberColumn      ID="PART_SIZE_Y"         ItemID="PART_SIZE_Y"         runat="server" DataIndex="PART_SIZE_Y"    Width="90"  Align="Right"  Format="#,##0.##" Text="세로(mm)"/>
                                        <ext:NumberColumn      ID="PART_SIZE_Z"         ItemID="PART_SIZE_Z"         runat="server" DataIndex="PART_SIZE_Z"    Width="90"  Align="Right"  Format="#,##0.##" Text="높이(mm)"/>                                        
                                    </Columns>
                                </ext:Column>
                                <ext:NumberColumn      ID="PART_WEIGHT"         ItemID="PART_WEIGHT"         runat="server" DataIndex="PART_WEIGHT"    Width="90"  Align="Right"  Format="#,##0.#" Text="부품중량"/>
                                <ext:Column ID="MID_INFO"          ItemID="MID_INFO"  runat="server" Text="중포장 사이즈">
                                    <Columns>
                                        <ext:NumberColumn      ID="MID_PACK_X"         ItemID="MID_PACK_X"         runat="server" DataIndex="MID_PACK_X"    Width="90"  Align="Right"  Format="#,##0.##" Text="가로(mm)"/>
                                        <ext:NumberColumn      ID="MID_PACK_Y"         ItemID="MID_PACK_Y"         runat="server" DataIndex="MID_PACK_Y"    Width="90"  Align="Right"  Format="#,##0.##" Text="세로(mm)"/>
                                        <ext:NumberColumn      ID="MID_PACK_Z"         ItemID="MID_PACK_Z"         runat="server" DataIndex="MID_PACK_Z"    Width="90"  Align="Right"  Format="#,##0.##" Text="높이(mm)"/>
                                    </Columns>
                                </ext:Column>
                                <ext:NumberColumn      ID="MID_LOAD_QTY"       ItemID="MID_LOAD_QTY"         runat="server" DataIndex="MID_LOAD_QTY"    Width="90"  Align="Right"  Format="#,##0.##" Text="적입수량"/>--%>
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true"/>
                        </View>
                        <SelectionModel>
                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
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

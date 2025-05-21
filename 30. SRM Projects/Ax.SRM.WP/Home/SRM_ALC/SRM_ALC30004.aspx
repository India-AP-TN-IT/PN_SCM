<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_ALC30004.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_ALC.SRM_ALC30004" %>
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

        var fn_PlantComboChange = function () {
            App.direct.SetPlantComboChange();
        };
    </script>
</head>
<body>
    <form id="SRM_ALC30004" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="txt01_FIELD_NM1" runat="server" Hidden="true" ></ext:TextField> 
    <ext:TextField ID="txt01_FIELD_NM2" runat="server" Hidden="true" ></ext:TextField> 

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_ALC30004" runat="server" Cls="search_area_title_name" Text="서열투입현황" />
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
                                <ext:Label ID="lbl01_VEND" runat="server"/>

                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>    
                            <th class="ess">
                                <ext:Label ID="lbl01_DD" runat="server" /> <%--Text="일자" --%>
                            </th>
                            <td>
                                <ext:DateField ID="df01_QUT_DATE" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />                                
                            </td>
                        </tr> 
                        <tr>
                            <th >
                                <ext:Label ID="lbl01_PLANT" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PLANT_GB" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="PLANT_GBNM" ValueField="PLANT_GB" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store4" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model1" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="PLANT_GB" />
                                                        <ext:ModelField Name="PLANT_GBNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <Listeners>
                                    <%--4.X--%>
                                        <Select Fn="fn_PlantComboChange"></Select>
                                    </Listeners>
                                </ext:SelectBox>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_LINE_GB" runat="server" text="LINE"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_LINE_GB" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="LINE_GBNM" ValueField="LINE_GB" TriggerAction="All" Width="260">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="LINE_GB" />
                                                        <ext:ModelField Name="LINE_GBNM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
                            </td>

                            <th>
                                <ext:Label ID="lbl01_SEQ" runat="server"  /><%--Text="SEQ"--%>
                            </th>
                            <td>
                                <ext:TextField ID="txt01_SEQ" Cls="inputText" FieldCls="inputText" runat="server" Height ="22" MaskRe="/[0-9\,]/"/>
                            </td>
                            <td></td>
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
                                            <ext:ModelField Name="LSEQ"/>
                                            <ext:ModelField Name="VID"/>
                                            <ext:ModelField Name="ORDNO"/>
                                            <ext:ModelField Name="DRV"/>
                                            <ext:ModelField Name="LINE"/>
                                            <ext:ModelField Name="TSEQ"/>
                                            <ext:ModelField Name="FIELD_NM1"/>
                                            <ext:ModelField Name="FIELD_NM2"/>
                                            <ext:ModelField Name="YMD"/>
                                            <ext:ModelField Name="TIME"/>
                                            <ext:ModelField Name="MODEL"/>
                                            <ext:ModelField Name="COUNT"/>
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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" />
                                <ext:Column ID="LSEQ" ItemID="SEQ" runat="server" DataIndex="LSEQ" Width="50" Align="Center" />  <%--Text="SEQ"--%> 
                                <ext:Column ID="VID" ItemID="TRIM_NO" runat="server" DataIndex="VID" Width="130" Align="Center" />  <%--Text="TRIM-NO"--%> 
                                <ext:Column ID="ORDNO" ItemID="ORDNO02" runat="server" DataIndex="ORDNO" Width="130" Align="Center" />  <%--Text="ORDER-NO"--%> 
                                <ext:Column ID="DRV" ItemID="LR" runat="server" DataIndex="DRV" Width="30" Align="Center" Text=""  />  <%--Text="LR"--%> 
                                <ext:Column ID="LINE" ItemID="LN" runat="server" DataIndex="LINE" Width="30" Align="Center" />  <%--Text="LN"--%> 
                                <ext:Column ID="TSEQ" ItemID="TSEQ" runat="server" DataIndex="TSEQ" Width="0" Align="Center" />  <%--Text=""--%> 
                                <ext:Column ID="FIELD_NM1" ItemID="ITEM02" runat="server" DataIndex="FIELD_NM1" Width="50" Align="Center" />  <%--Text="ITEM"--%> 
                                <ext:Column ID="FIELD_NM2" ItemID="ITEM03" runat="server" DataIndex="FIELD_NM2" Width="50" Align="Center" />  <%--Text="ITEM"--%> 
                                <ext:Column ID="YMD" ItemID="DATE02" runat="server" DataIndex="YMD" Width="80" Align="Center" />  <%--Text="DATE"--%> 
                                <ext:Column ID="TIME" ItemID="TIME_NO" runat="server" DataIndex="TIME" Width="60" Align="Center" />  <%--Text="TIME"--%> 
                                <ext:Column ID="MODEL" ItemID="MODEL" runat="server" DataIndex="MODEL" Width="60" Align="Center" />  <%--Text="MODEL"--%> 
                                <ext:Column ID="COUNT" ItemID="COUNT02" runat="server" DataIndex="COUNT" Width="60" Align="Center" />  <%--Text="COUNT"--%> 
                                <ext:Column ID="Column1" ItemID="Column1" runat="server" DataIndex="Column1" MinWidth="1" Align="Left" Flex="1"/>  <%--Text=""--%> 
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

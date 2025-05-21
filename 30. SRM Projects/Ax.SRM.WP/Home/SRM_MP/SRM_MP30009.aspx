<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MP30009.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MP.SRM_MP30009" %>
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

    <title>일별 검수실적 현황</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <style type="text/css">
        
        .font-color-red 
        {
            color:#FF0000;
        }
        
    </style>
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

        function getRowClass(record, b, c, d) {
            var amt = record.data['RCV_AMT'];
            var rcv_qty = record.data['RCV_QTY'];

            if (amt < 0 || rcv_qty < 0) return 'font-color-red';            
        }
             
    </script>
</head>
<body>
    <form id="SRM_MP30009" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MP30009" runat="server" Cls="search_area_title_name" Text="주간 소요량" />
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
                            <col style="width: 100px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 200px;"/>
                            <col style="width: 100px;" />
                            <col style="width: 300px;"/>
                            <col style="width: 100px;" />
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
                                <ext:Label ID="lbl01_SAUP" runat="server"/>
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
                                <ext:Label ID="lbl01_RCV_DATE" runat="server"/>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_BEG_DATE" Width="110"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                        <ext:DisplayField ID="DisplayField1" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_END_DATE" Width="110"  Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                    </Items>
                                </ext:FieldContainer>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_MRO_PO_TYPE" runat="server"/>
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_MRO_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
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
                        </tr> 
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PONO_PER" runat="server" />                 
                            </th>
                            <td colspan="7">
                                <ext:TextField ID="txt01_PONO" Width="257" Cls="inputText" runat="server" />                              
                            </td>
                            <th style="display:none;">         
                                <ext:Label ID="lbl01_DELI_NOTE2" runat="server" />                 
                            </th>
                            <td style="display:none;">
                                <ext:TextField ID="txt01_DELI_NOTE" Width="120" Cls="inputText" runat="server" />                              
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
                                            <ext:ModelField Name="VENDCD"/><ext:ModelField Name="VENDNM"/><ext:ModelField Name="RCV_DATE"/>
                                            <ext:ModelField Name="RCVNO"/><ext:ModelField Name="MRO_PO_TYPE"/><ext:ModelField Name="MRO_PO_TYPENM" />
                                            <ext:ModelField Name="PARTNO"/><ext:ModelField Name="PARTNM"/><ext:ModelField Name="STANDARD"/>
                                            <ext:ModelField Name="UNIT"/><ext:ModelField Name="RCV_QTY"/><ext:ModelField Name="RCV_AMT"/>
                                            <ext:ModelField Name="RCV_DIV"/><ext:ModelField Name="PO_DATE"/><ext:ModelField Name="PONO"/>
                                            <ext:ModelField Name="PONO_SEQ"/><ext:ModelField Name="PO_UNIT"/><ext:ModelField Name="PO_QTY"/>
                                            <ext:ModelField Name="DELI_PLACE"/><ext:ModelField Name="GRN_PLACE"/><ext:ModelField Name="MGRT_NAME"/>
                                            <ext:ModelField Name="MGRT_TELNO"/><ext:ModelField Name="DELI_DATE"/><ext:ModelField Name="DELI_CNT"/>
                                            <ext:ModelField Name="DELI_QTY"/><ext:ModelField Name="DELI_NOTE"/><ext:ModelField Name="DELI_TYPE" />                                            
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
                                <ext:RowNumbererColumn ID="NO"            ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center"  />
                                <ext:Column ID="RCV_INFO" ItemID="RCV_INFO" runat="server" >
                                    <Columns>
                                    <ext:Column       ID="VENDCD"       ItemID="VEND"    runat="server" DataIndex="VENDCD" Width="70" Align="Center"  />  <%--Text="업체"--%> 
                                    <ext:Column       ID="VENDNM"       ItemID="VENDNM"    runat="server" DataIndex="VENDNM" Width="100" Align="Left"  />  <%--Text="업체명"--%> 
                                    <ext:Column       ID="RCV_DATE"     ItemID="RCV_DATE"    runat="server" DataIndex="RCV_DATE" Width="80" Align="Center"  />  <%--Text="입고일자"--%> 
                                    <ext:Column       ID="RCVNO"        ItemID="RCVNO"          runat="server" DataIndex="RCVNO" Width="100" Align="Center"  />  <%--Text="입고번호"--%> 
                                    <ext:Column       ID="MRO_PO_TYPE"  ItemID="MRO_PO_TYPE"     runat="server" DataIndex="MRO_PO_TYPENM" Width="100" Align="Left"  />  <%--Text="일반구매유형"--%> 
                                    <ext:Column       ID="PARTNM"       ItemID="PARTNM"   runat="server" DataIndex="PARTNM" MinWidth="300" Align="Left" Flex="1"/>  <%--Text="품명"--%> 
                                    <ext:Column       ID="UNIT"         ItemID="UNIT"          runat="server" DataIndex="UNIT" Width="60" Align="Center" />  <%--Text="단위"--%> 
                                    <ext:NumberColumn ID="RCV_QTY"      ItemID="RCV_QTY"      runat="server" DataIndex="RCV_QTY" Width="75" Align="Right" Format="#,##0"/>  <%--Text="입고수량"--%> 
                                    <ext:NumberColumn ID="RCV_AMT"      ItemID="RCV_AMT"           runat="server" DataIndex="RCV_AMT" Width="96" Align="Right" Format="#,##0"/>  <%--Text="입고금액"--%> 
                                    <ext:Column       ID="RCV_DIV"      ItemID="RCV_DIV"    runat="server" DataIndex="RCV_DIV" Width="70" Align="Left" Hidden="true" />  <%--Text="입고구분"--%> 
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="PO_INFO" ItemID="PO_INFO" runat="server" >
                                    <Columns>
                                    <ext:Column       ID="PO_DATE"      ItemID="PO_DATE"    runat="server" DataIndex="PO_DATE" Width="80" Align="Center" />  <%--Text="발주일자"--%> 
                                    <ext:Column       ID="PONO"         ItemID="PONO"          runat="server" DataIndex="PONO" Width="90" Align="Center" />  <%--Text="발주번호"--%> 
                                    <ext:Column       ID="PONO_SEQ"     ItemID="SEQ_NO"          runat="server" DataIndex="PONO_SEQ" Width="50" Align="Center" />  <%--Text="순번"--%> 
                                    <ext:Column       ID="PO_UNIT"      ItemID="UNIT"          runat="server" DataIndex="PO_UNIT" Width="60" Align="Center" />  <%--Text="단위"--%> 
                                    <ext:NumberColumn ID="PO_QTY"       ItemID="PO_QTY"      runat="server" DataIndex="PO_QTY" Width="70" Align="Right" Format="#,##0"/>  <%--Text="발주량"--%> 
                                    <ext:Column       ID="DELI_PLACE"   ItemID="DEL_STAGE" runat="server" DataIndex="DELI_PLACE" Width="100" Align="Left" />  <%--Text="납품장소"--%> 
                                    <ext:Column       ID="GRN_PLACE"    ItemID="INPT_PLACE" runat="server" DataIndex="GRN_PLACE" Width="100" Align="Left" />  <%--Text="입고장소"--%> 
                                    <ext:Column       ID="MGRT_NAME"    ItemID="MGRT_NAME02"   runat="server" DataIndex="MGRT_NAME" Width="80" Align="Left" />  <%--Text="담당자"--%> 
                                    <ext:Column       ID="MGRT_TELNO"   ItemID="TELNO"         runat="server" DataIndex="MGRT_TELNO" Width="100" Align="Left" />  <%--Text="전화번호"--%> 
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="DELI_INFO" ItemID="DELI_INFO" runat="server" Hidden="true" >
                                    <Columns>
                                    <ext:Column       ID="DELI_DATE" ItemID="DELI_DATE"    runat="server" DataIndex="DELI_DATE" Width="80" Align="Center" Hidden="true"/>  <%--Text="납품일자"--%> 
                                    <ext:Column       ID="DELI_CNT"  ItemID="DELI_CNT"    runat="server" DataIndex="DELI_CNT" Width="70" Align="Center" Hidden="true"/>  <%--Text="납품차수"--%> 
                                    <ext:NumberColumn ID="DELI_QTY"  ItemID="DELI_QTY"      runat="server" DataIndex="DELI_QTY" Width="70" Align="Right" Format="#,##0" Hidden="true"/>  <%--Text="납품수량"--%> 
                                    <ext:Column       ID="DELI_NOTE" ItemID="DELI_NOTE"     runat="server" DataIndex="DELI_NOTE" Width="130" Align="Center" Hidden="true"/>  <%--Text="납품서번호"--%> 
                                    <ext:Column       ID="DELI_TYPE" ItemID="DELI_TYPE"     runat="server" DataIndex="DELI_TYPE" Width="80" Align="Center" Hidden="true"/>  <%--Text="납품서유형"--%> 
                                    </Columns>
                                </ext:Column>                                
                            </Columns>
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true">
                                <GetRowClass Fn="getRowClass" />
                            </ext:GridView>
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

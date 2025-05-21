<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_MM31006.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_MM.SRM_MM31006" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" />
<meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
<meta content="/images/favicon/SCM.ico" itemprop="image"/>
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>EP Standard Sample Page</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    
    <style type="text/css">
        .search_area_table table th.combo
        {
            height:30px;
            color:#393c45;
            text-align:left;
            font-weight:normal;
            padding-left:7px;
            border-bottom:1px solid #b1b1b1;            
            padding-right:0px;
            background:#e7eef4 url(../../images/common/point_icon.png) right 10px no-repeat;
        }
        
        .font-color-red .x-grid-cell-PO_DELI_DATE
        {
            color:#FF0000;
        }
        .font-color-black .x-grid-cell-PO_DELI_DATE
        {
            color:#000000;
        }
        
        .font-color-red_all 
        {
            color:#FF0000;
        }        
    </style>
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
        
        // 납기일자<=SYSDATE 일 시, 빨간색
        function getRowClass(record, b, c, d) {
            
            var chk = record.data['CHK'];
            var po_qty = record.data['PO_QTY'];
            if (chk == 'Y') {
               
                return 'font-color-red';
            }
            else if (po_qty < 0) {

                return 'font-color-red_all';
            }
            else return 'font-color-black';
        }
        
        var linkRenderer = function (value, meta, record, index, cellIndex) {
            var param = "Ext.getStore('" + record.store.storeId + "')";
            var columnName = App.Grid01.columns[cellIndex].id;
            if (columnName == "PONO")
                return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, value);
            else
                return Ext.String.format("<a style='color:blue;text-decoration:underline;' href='#' onclick=\"linkClick({0},{1},{2});\">{3}</a>", param, index, cellIndex, numberWithCommas(value));
        };

        var linkClick = function (store, rowIndex, cellIndex) {
            var param1 = new Array(store.getAt(rowIndex).data["PURC_ORG"], store.getAt(rowIndex).data["PURC_PO_TYPE"], store.getAt(rowIndex).data["PURC_GRP"], store.getAt(rowIndex).data["PARTNO"], store.getAt(rowIndex).data["PARTNM"], store.getAt(rowIndex).data["PO_UNIT"], store.getAt(rowIndex).data["PONO"], store.getAt(rowIndex).data["VEND"]);

            var columnName = App.Grid01.columns[cellIndex].id; // App.Grid01.columnManager.secondHeaderCt.columnManager.columns[cellIndex].id;
            var type = '';

            //DELI_QTY:납품수량, GRN_QTY:입고수량
            switch (columnName) {
                case 'PONO': type = 'D'; break;
                //case 'DELI_QTY': type = 'D'; break;
                case 'GRN_QTY': type = 'I'; break;
            }

            App.direct.MakePopUp(param1, type);
        };

        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }          

    </script>
</head>
<body>
    <form id="SRM_MM31006" runat="server">
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
                    <ext:Label ID="lbl01_SRM_MM31006" runat="server" Cls="search_area_title_name" /><%--Text="OEM 자재발주" />--%>
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
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col style="width: 100px;" />
                            <col style="width: 200px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="60"/>
                            </td>   
                            <th class="ess">
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
                            <th>
                                <ext:Label ID="lbl01_MM31006_QUERY" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_QUERY_COND" runat="server"  Mode="Local" ForceSelection="true"
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
                                    <DirectEvents>
                                        <Change OnEvent="cbo01_QUERY_COND_change" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                            <th class="combo">
                                <%--<ext:Label ID="lbl01_PO_DATE" runat="server" />--%>
                                <ext:SelectBox ID="cbo01_DATE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="90">
                                    <Store>
                                        <ext:Store ID="Store3" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model3" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition_Date" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </th>
                            <td>
                                <ext:FieldContainer ID="FieldContainer2" runat="server" Width="250" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:DateField ID="df01_PO_DATE_BEG" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                        </ext:DateField>
                                        <ext:DisplayField ID="lbl01_PERIOD" Width="20"  Flex="1" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" ~ " />
                                        <ext:DateField ID="df01_PO_DATE_TO" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"  >
                                        </ext:DateField>
                                    </Items>
                                </ext:FieldContainer>      
                            </td>
                        </tr> 
                        <tr>
                            <th class="ess">
                                <ext:Label ID="lbl01_PURC_ORG" runat="server" />
                            </th>
                            <td>                                
                                <ext:SelectBox ID="cbo01_PURC_ORG" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store33" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model33" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="OBJECT_ID" />
                                                        <ext:ModelField Name="OBJECT_NM" />
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                    <DirectEvents>
                                        <Change OnEvent="changeCondition" />
                                    </DirectEvents>
                                </ext:SelectBox>
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PURC_PO_TYPE" runat="server" />                   
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_PURC_PO_TYPE" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="OBJECT_NM" ValueField="OBJECT_ID" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store6" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model6" runat="server">
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
                               <ext:Label ID="lbl01_STR_LOC" runat="server" />
                            </th>
                            <td>                                                                                                 
                                <epc:EPCodeBox ID="cdx01_STR_LOC" runat="server" HelperID="HELP_STR_LOC" PopupMode="Search" PopupType="HelpWindow" 
                                    OnBeforeDirectButtonClick="cdx01_STR_LOC_BeforeDirectButtonClick" WidthTYPECD="60"/>    
                            </td>
                            <th>
                               <ext:Label ID="lbl01_CUSTNM" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_CUSTCD" runat="server" HelperID="HELP_CUSTCD" PopupMode="Search" PopupType="HelpWindow"/>    
                            </td>
                        </tr>
                        <tr>
                            <th>         
                                <ext:Label ID="lbl01_PARTNO_PER" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_FPARTNO" Width="150" Cls="inputText" runat="server" />    
                            </td>
                            <th>         
                                <ext:Label ID="lbl01_PONO_PER" runat="server" />
                            </th>
                            <td colspan="5">
                                <ext:FieldContainer ID="FieldContainer1" runat="server" Width="150" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                    <Items>
                                        <ext:TextField ID="txt01_PONO" Width="100" Cls="inputText" runat="server" />    
                                        <ext:DisplayField ID="DisplayField2" Width="10" runat="server" FieldStyle="text-align:center;padding:3px;" Text=" - " />
                                        <ext:TextField ID="txt01_PONO_SEQ" Width="40" Cls="inputText" runat="server" />    
                                    </Items>
                                </ext:FieldContainer> 

                                
                            </td>
                        </tr>
                    </table>
                </Content>
            </ext:Panel>            
            <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                <Items>                    
                    <ext:GridPanel ID="Grid01" runat="server" Height="1000" TrailingBufferZone="20" LeadingBufferZone="15" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                        <Store>
                            <ext:Store ID="Store1" runat="server"  PageSize="50">
                                <Model>
                                    <ext:Model ID="GridModel1" runat="server">
                                        <Fields>
                                            <ext:ModelField Name="VEND" />
                                            <ext:ModelField Name="VENDNM" />
                                            <ext:ModelField Name="PO_DATE" />
                                            <ext:ModelField Name="PONO" />
                                            <ext:ModelField Name="PONO_SEQ" />
                                            <ext:ModelField Name="VINCD" />
                                            <ext:ModelField Name="VINNM" />
                                            <ext:ModelField Name="PARTNO" />
                                            <ext:ModelField Name="PARTNM" />                                            
                                            <ext:ModelField Name="PO_DELI_DATE" />
                                            <ext:ModelField Name="PO_QTY" />
                                            <ext:ModelField Name="PO_UNIT" />
                                            <ext:ModelField Name="UNIT_PACK_QTY" />
                                            <ext:ModelField Name="STR_LOCNM" />
                                            <ext:ModelField Name="PURC_PO_TYPENM" />
                                            <ext:ModelField Name="PURC_ORGNM" />
                                            <ext:ModelField Name="PURC_GRPNM" />
                                            <ext:ModelField Name="STR_LOC" />
                                            <ext:ModelField Name="PURC_PO_TYPE" />
                                            <ext:ModelField Name="PURC_ORG" />
                                            <ext:ModelField Name="PURC_GRP" />
                                            <ext:ModelField Name="NATIONCD" />
                                            <ext:ModelField Name="MAT_GRP" />
                                            <ext:ModelField Name="PSTYP" />
                                            <ext:ModelField Name="UMSON" />
                                            <ext:ModelField Name="AAC" />
                                            <ext:ModelField Name="SD_PONO" />
                                            <ext:ModelField Name="SD_DELI_DATE" />
                                            <ext:ModelField Name="CUSTCD" />
                                            <ext:ModelField Name="CUSTNM" />
                                            <ext:ModelField Name="CUST_PONO" />
                                            <ext:ModelField Name="FTA_CERTI" />
                                            <ext:ModelField Name="ZMMT0030_IFDATE_IFTIME" />
                                            <ext:ModelField Name="DELI_CMP_CHK" />
                                            <ext:ModelField Name="PMI" />
                                            <ext:ModelField Name="RETPO" />
                                            <ext:ModelField Name="DEL_YN" />
                                            <ext:ModelField Name="UPDATE_DATE" />
                                            <ext:ModelField Name="DELI_QTY" />
                                            <ext:ModelField Name="DEF_QTY" />
                                            <ext:ModelField Name="GRN_QTY" />
                                            <ext:ModelField Name="ARRIV_QTY" />
                                            <ext:ModelField Name="REMAINQTY" />
                                            <ext:ModelField Name="UPDATE_DATE" />
                                            <ext:ModelField Name="CHK" />
                                            <ext:ModelField Name="PO_UCOST" />
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
                            <%--<ext:BufferedRenderer ID="BufferedRenderer1"   runat="server"/>--%>
                        </Plugins>  
                        <ColumnModel ID="ColumnModel1" runat="server">
                            <Columns>
                                <ext:RowNumbererColumn ID="NO"      ItemID="NO"        runat="server" Text="No"        Width="40" Align="Center" />
                                <ext:Column            ID="VEND" ItemID="VEND" runat="server" DataIndex="VEND" Width="70"  Align="center"  />
                                <ext:Column            ID="VENDNM" ItemID="VENDNM" runat="server" DataIndex="VENDNM" Width="100"  Align="Left"  />
                                <ext:Column ID="PO_DATE" ItemID="PO_DATE" runat="server" DataIndex="PO_DATE" Width="80" Align="Center" /><%--Text="발주일자"--%>
                                <ext:Column ID="PONO" ItemID="PONO" runat="server" DataIndex="PONO" Width="100" Align="Left" ><%--Text="발주번호"--%>
                                     <Renderer Fn="linkRenderer"/>
                                </ext:Column>
                                <ext:Column ID="PO_DELI_DATE" ItemID="PO_DELI_DATE" runat="server" DataIndex="PO_DELI_DATE" Width="80" Align="Center"/><%--Text="납기일자"--%>
                                <ext:Column ID="PURC_PO_TYPE" ItemID="PURC_PO_TYPE"  runat="server" DataIndex="PURC_PO_TYPENM" Width="90" Align="Left"/><%--Text="구매오더유형(발주구분)"--%>                                
                                <ext:Column ID="VINNM" ItemID="VIN" runat="server" DataIndex="VINNM" Width="70" Align="Center" /><%--Text="차종"--%>
                                <ext:Column ID="PARTNO" ItemID="PARTNO" runat="server" DataIndex="PARTNO" Width="120" Align="Left" /><%--Text="PART NO"--%>
                                <ext:Column ID="PARTNM" ItemID="PARTNM" runat="server" DataIndex="PARTNM" MinWidth="170" Align="Left" /><%--Text="PART NAME"--%>
                                <ext:Column ID="STR_LOC" ItemID="STR_LOC"  runat="server" DataIndex="STR_LOCNM" Width="80" Align="Left"/><%--Text="저장위치"--%>
                                <ext:Column ID="PO_UNIT" ItemID="PO_UNIT"  runat="server" DataIndex="PO_UNIT" Width="60" Align="Center"/><%--Text="발주단위"--%>
                                <ext:NumberColumn      ID="UNIT_PACK_QTY"         ItemID="UNIT_PACK_QTY"         runat="server" DataIndex="UNIT_PACK_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="용기적입수량"--%>
                                <ext:NumberColumn      ID="PO_QTY"         ItemID="PO_QTY"         runat="server" DataIndex="PO_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="발주수량"--%>
                                <ext:NumberColumn      ID="DELI_QTY"         ItemID="DELI_QTY"         runat="server" DataIndex="DELI_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="납품수량"--%>                                    
                                <ext:NumberColumn      ID="DEF_QTY"         ItemID="DEF_QTY"         runat="server" DataIndex="DEF_QTY"    Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="불량수량"--%>
                                <ext:NumberColumn      ID="ARRIV_QTY"       ItemID="ARRIV_OK_QTY"       runat="server" DataIndex="ARRIV_QTY"  Width="110"  Align="Right"  Format="#,##0.###" /><%--Text="입하수량"--%>                                
                                <ext:NumberColumn      ID="REMAINQTY"       ItemID="ARRIV_REMAIN"       runat="server" DataIndex="REMAINQTY"  Width="80"  Align="Right"  Format="#,##0.###" /><%--Text="입하잔량"--%>
                                <ext:NumberColumn      ID="GRN_QTY"         ItemID="GRN_QTY"         runat="server" DataIndex="GRN_QTY"    Width="80"  Align="Right"  Format="#,##0.###" ><%--Text="입고수량"--%>
                                    <Renderer Fn="linkRenderer"/>
                                </ext:NumberColumn>
                                <%--<ext:Column ID="DEL_YN" ItemID="DEL_YN"  runat="server" DataIndex="DEL_YN" Width="80" Align="Left"/>--%><%--Text="삭제구분"--%>
                                <ext:Column ID="DELI_CMP_CHK" ItemID="DELI_CMP_CHK" runat="server" DataIndex="DELI_CMP_CHK" Width="80" Align="Center"/><%--Text="납품완료"--%>
                                <ext:NumberColumn ID="PO_UCOST"     ItemID="PO_UCOST"     runat="server" DataIndex="PO_UCOST"     Width="80" Align="Right" Text="Unit Cost" Format="#,##0.###" /><%--Text="단가"--%>                                

                                <ext:Column ID="PURC_ORG" ItemID="PURC_ORG"  runat="server" DataIndex="PURC_ORGNM" Width="70" Align="Center"/><%--Text="구매조직(내수/수출)"--%>
                                
                                <ext:Column ID="PURC_GRP" ItemID="PURC_GRP"  runat="server" DataIndex="PURC_GRPNM" Width="70" Align="Left"/><%--Text="구매그룹(업무유형)"--%>
                                <ext:Column ID="CUST_ORDER_INFO" ItemID="CUST_ORDER_INFO" runat="server" >
                                    <Columns>
                                        <ext:Column ID="CUSTNM" ItemID="CUSTNM"  runat="server" DataIndex="CUSTNM" Width="80" Align="Left"/><%--Text="고객코드"--%>
                                        <ext:Column ID="CUST_PONO" ItemID="CUST_PONO"  runat="server" DataIndex="CUST_PONO" Width="120" Align="Left"/><%--Text="고객사 발주번호"--%>
                                        <ext:Column ID="PMI" ItemID="PMI"  runat="server" DataIndex="PMI" Width="70" Align="Left" Hidden="true"/><%--Text="PMI"--%>
                                        <ext:Column ID="SD_PONO" ItemID="SD_PONO"  runat="server" DataIndex="SD_PONO" Width="120" Align="Left"/><%--Text="영업오더번호"--%>
                                        <ext:Column ID="SD_DELI_DATE" ItemID="SD_DELI_DATE"  runat="server" DataIndex="SD_DELI_DATE" Width="80" Align="Center"/><%--Text="영업오더납품일자"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="FTA_CERTI" ItemID="FTA_CERTI" runat="server" DataIndex="FTA_CERTI" Width="90" Align="Center" /><%--Text="원산지확인서"--%>
                                <ext:Column ID="UMSON" ItemID="UMSON"  runat="server" DataIndex="UMSON" Width="80" Align="Center"/><%--Text="유/무상 구분(X:무상)"--%>
                                <ext:Column ID="MAT_GRP" ItemID="MAT_GRP"  runat="server" DataIndex="MAT_GRP" Width="100" Align="Left"/><%--Text="자재그룹(자재품목)"--%>

                                <ext:Column ID="PURC_PO_ETC" ItemID="PURC_PO_ETC" runat="server" >
                                    <Columns>
                                        <ext:Column ID="NATIONCD" ItemID="NATIONCD"  runat="server" DataIndex="NATIONCD" Width="60" Align="Left" Visible="false"/><%--Text="국가코드"--%>
                                        <ext:Column ID="RETPO" ItemID="RETPO"  runat="server" DataIndex="RETPO" Width="80" Align="Left"/><%--Text="반품구분"--%>                                        
                                        <ext:Column ID="PSTYP" ItemID="PSTYP"  runat="server" DataIndex="PSTYP" Width="70" Align="Left"/><%--Text="품목범주(L:외주임가공/무상사급)"--%>                                
                                        <ext:Column ID="AAC" ItemID="AAC"  runat="server" DataIndex="AAC" Width="100" Align="Left"/><%--Text="계정지정범주"--%>
                                    </Columns>
                                </ext:Column>
                                <ext:Column ID="UPDATE_DATE" ItemID="UPDATE_DATE"  runat="server" DataIndex="UPDATE_DATE" Width="120" Align="Left"/><%--Text="최종변경일시"--%>
                                
                                <%--<ext:Column ID="ZMMT0030_IFDATE_IFTIME" ItemID="ZMMT0030_IFDATE_IFTIME"  runat="server" DataIndex="ZMMT0030_IFDATE_IFTIME" Width="100" Align="Center"/>--%>
                                <%--Text="SAP I/F 일시"--%>
                                <%--<ext:Column ID="PONO_SEQ" ItemID="PONO_SEQ" runat="server" DataIndex="PONO_SEQ" Width="80" Align="Center" Locked="true"/>--%>
                                <%--Text="발주행번호"--%>
                                
                            </Columns>                            
                        </ColumnModel>
                        <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                            <LoadMask ShowMask="true" />
                        </Loader>
                        <View>
                            <ext:GridView ID="GridView1" runat="server"  EnableTextSelection="true">
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
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

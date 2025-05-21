<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SRM_TV50002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_TVMonitoring.SRM_TV50002" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>KMI JIS Monitoring</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <%--아래의 CSS는 에디트 가능한 컬럼만 아이디값으로 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <style type="text/css">
	    /*.edit-row*/ .x-grid-cell-UNIT DIV,
	    /*.edit-row*/ .x-grid-cell-CLS_QTY DIV
	    {
	        border-width:1px;
		    border-style:solid;
		    border-color:silver; /* darkgray; */
	    }
        .pnlTableLayout {
            height:100%;
            width:100%;
        }
        .pnlTableLayout thead th {
            width:33%;
            padding-top:2%;
            padding-bottom:2%;
        }
        .pnlTableLayout tbody td {
            width:33%;
            vertical-align:middle;
        }
        .pnlTable {
            height:100%;
            width:100%;
        }
        .pnlTable thead th {
            width:12%;
            padding-top:1%;
            padding-bottom:1%;
        }
        .pnlTable tbody td {
            vertical-align:middle;
        }

       
        #container{
            position:absolute;
            height:100%;
            width:100%;
        }
        .section{
            position:relative;
            height:40%;
            width:100%;
            text-align:center;
            padding:0;
        }
        .segment{
            height:100%;
            width:35%;
            float:left;
            padding:0;
        }
        .title_Panel {
            font-size:36px;
            color:#fff;
            font-weight:600;
            background-color:#000;
        }
        .data_Panel {
            font-size:36px;
            color:#fff;
            font-weight:600;
            background-color:#0050EF;
        } 
        .font-xl {
            font-size:60px !important;
        }
        .highlight{
            background-color:#003FBC;
        }
        .alert{
            background-color:red !important;
        }
        #KMI_JIS {
            overflow:auto;
        }
        #pnlLayout {
            position:absolute !important;
            min-height:650px !important;
            min-width:650px !important;
            height:760px !important;
            width:1600px !important;
        }
        #pnlLayout-body {
            position:absolute !important;
            height:94% !important;
            width:100% !important;
        }
        #Dashboard{
            position:absolute;
            height:100%;
            width:100%;
        }


        /*@media only screen and (max-width: 760px), (min-device-width: 768px) and (max-device-width: 1024px) {
            #pnlLayout-body {
                position:absolute;
                height:900px;
                width:900px;
                overflow:auto;
            }
            #container, #Dashboard{
                position:absolute;
                height:100%;
                width:100%;
            }*/
        }
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.GridPanel.getHeight());

            if (App.heb02_CONTENTS) {
                // 내용창의 리사이징을 위해 기본값인 22로 복구했다가 다시 리사이징 처리
                App.heb02_CONTENTS.setHeight(22);
                App.heb02_CONTENTS.setHeight(App.ContentPanel.getHeight() - document.getElementById("tableContent").clientHeight + 22 - 3);
            }
        }
        var stop_Alert = function () {
            var store = Ext.getStore("Store1");
            var data_obj = store.getAt(0).data;
            for (i = 0; i < Object.keys(data_obj).length; i++) {
                var data_key = Object.keys(data_obj)[i];
                switch (data_key) {
                    case "ALC_COLOR":
                        if (data_obj[data_key] > 0) {
                            if (!document.getElementById(data_key).classList.contains("alert"))
                                document.getElementById(data_key).classList.add("alert");
                        }
                        else {
                            if (document.getElementById(data_key).classList.contains("alert"))
                                document.getElementById(data_key).classList.remove("alert");
                        }
                        break;
                    case "DT_FLH_STOP":
                    case "DT_FRH_STOP":
                    case "DT_RLH_STOP":
                    case "DT_RRH_STOP":
                    case "BP_FRT_STOP":
                    case "BR_RR_STOP":
                    case "TG_RR_STOP":
                    case "DG_FLH_STOP":
                    case "DG_FRH_STOP":
                    case "DG_RLH_STOP":
                    case "DG_RRH_STOP":
                        if (data_obj[data_key] == 1) {
                            if (!document.getElementById(data_key).classList.contains("alert"))
                                document.getElementById(data_key).classList.add("alert");
                        }
                        else {
                            if (document.getElementById(data_key).classList.contains("alert"))
                                document.getElementById(data_key).classList.remove("alert");
                        }
                        break;
                    default: break;
                }
            }
        }

    </script>

</head>
<body id="doc_Panel">
    <form id="KMI_JIS" runat="server">
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
                            <ext:Label ID="lbl01_TBR50001" runat="server" Cls="search_area_title_name" Text="KMI JIS MONITORING" />
                            <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                                <Items>
                                     <%--상단 이미지버튼--%> 
                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>

                    <ext:Panel runat="server" ID="PanelPanel" Title="" Layout="FitLayout" Border="false" Height="100" Width="100" Region="center"/>

                    <ext:Panel runat="server" ID="pnlLayout" Title="KMI JIS MONITORING" Split="false" Border="false" Height="60" Width="100" Region="center" BodyPadding="0" MinHeight="60" Collapsible="false">
                        <Items>
                            <ext:DataView ID="Dashboard" runat="server" ItemSelector="div.group-header" EmptyText="No items to display">
                                <Store>
                                    <ext:Store ID="Store1" runat="server">
                                        <Model>
                                            <ext:Model runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="ALC" />
                                                    <ext:ModelField Name="M1" />
                                                    <ext:ModelField Name="MD1"/>
                                                    <ext:ModelField Name="M2"/>
                                                    <ext:ModelField Name="MD2"/>
                                                    <ext:ModelField Name="M3"/>
                                                    <ext:ModelField Name="MD3"/>
                                                    <ext:ModelField Name="ST"/>
                                                    <ext:ModelField Name="FT"/>
                                                    <ext:ModelField Name="STOP_MIN"/>
                                                    <ext:ModelField Name="ALC_COLOR"/>
                                                    <ext:ModelField Name="D_DT_FLH" />
                                                    <ext:ModelField Name="D_DT_FRH" />
                                                    <ext:ModelField Name="D_DT_RLH"/>
                                                    <ext:ModelField Name="D_DT_RRH"/>
                                                    <ext:ModelField Name="D_BP_F"/>
                                                    <ext:ModelField Name="D_BP_R"/>
                                                    <ext:ModelField Name="D_TG"/>
                                                    <ext:ModelField Name="D_DG_FLH"/>
                                                    <ext:ModelField Name="D_DG_FRH"/>
                                                    <ext:ModelField Name="D_DG_RLH"/>
                                                    <ext:ModelField Name="D_DG_RRH"/>
                                                    <ext:ModelField Name="R_DT_FLH" />
                                                    <ext:ModelField Name="R_DT_FRH" />
                                                    <ext:ModelField Name="R_DT_RLH"/>
                                                    <ext:ModelField Name="R_DT_RRH"/>
                                                    <ext:ModelField Name="R_BP_F"/>
                                                    <ext:ModelField Name="R_BP_R"/>
                                                    <ext:ModelField Name="R_TG"/>
                                                    <ext:ModelField Name="R_DG_FLH"/>
                                                    <ext:ModelField Name="R_DG_FRH"/>
                                                    <ext:ModelField Name="R_DG_RLH"/>
                                                    <ext:ModelField Name="R_DG_RRH"/>
                                                    <ext:ModelField Name="DT_FLH_STOP" />
                                                    <ext:ModelField Name="DT_FRH_STOP" />
                                                    <ext:ModelField Name="DT_RLH_STOP"/>
                                                    <ext:ModelField Name="DT_RRH_STOP"/>
                                                    <ext:ModelField Name="BP_FRT_STOP"/>
                                                    <ext:ModelField Name="BR_RR_STOP"/>
                                                    <ext:ModelField Name="TG_RR_STOP"/>
                                                    <ext:ModelField Name="DG_FLH_STOP"/>
                                                    <ext:ModelField Name="DG_FRH_STOP"/>
                                                    <ext:ModelField Name="DG_RLH_STOP"/>
                                                    <ext:ModelField Name="DG_RRH_STOP"/>
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                    </ext:Store>
                                </Store>
                                <Tpl runat="server">
                                    <Html>
                                        <tpl for=".">
                                            <div id="container">
                                                <div class="section" style="height:20%">
                                                    <div class="segment">
                                                        <table class="pnlTableLayout"  id="table_st_1">
                                                            <tr>
                                                                <td class="title_Panel font-xl" id="ALC_COLOR">ALC</td>
                                                                <td class="data_Panel font-xl">{ALC}</td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div class="segment">
                                                        <table class="pnlTableLayout" id="table_st_2">
                                                            <thead>
                                                                <th class="title_Panel">{M1}</th>
                                                                <th class="title_Panel">{M2}</th>
                                                                <th class="title_Panel">{M3}</th>
                                                            </thead>
                                                            <tbody>
                                                                <td class="data_Panel">{MD1}</td>
                                                                <td class="data_Panel">{MD2}</td>
                                                                <td class="data_Panel">{MD3}</td>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="segment" style="width:30%">
                                                        <table class="pnlTableLayout" id="table_st_3">
                                                            <tr>
                                                                <td class="title_Panel">START</td>
                                                                <td class="data_Panel">{ST}</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="title_Panel">FINAL</td>
                                                                <td class="data_Panel highlight">{FT}</td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="section">
                                                    <table class="pnlTable" id="table_md">
                                                        <thead>
                                                            <tr>
                                                                <th class="title_Panel" rowspan="2" colspan="2" style="width:28%">ITEM</th>
                                                                <th class="title_Panel" colspan="4">DOOR TRIM</th>
                                                                <th class="title_Panel" colspan="2">BUMPER</th>
                                                            </tr>
                                                            <tr>
                                                                <th class="title_Panel">F/LH</th>
                                                                <th class="title_Panel">F/RH</th>
                                                                <th class="title_Panel">R/LH</th>
                                                                <th class="title_Panel">R/RH</th>
                                                                <th class="title_Panel">FRT</th>
                                                                <th class="title_Panel">RR</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td class="title_Panel" rowspan="2">SCAN</td>
                                                                <td class="title_Panel">DONE</td>
                                                                <td class="data_Panel">{D_DT_FLH}</td>
                                                                <td class="data_Panel">{D_DT_FRH}</td>
                                                                <td class="data_Panel">{D_DT_RLH}</td>
                                                                <td class="data_Panel">{D_DT_RRH}</td>
                                                                <td class="data_Panel">{D_BP_F}</td>
                                                                <td class="data_Panel">{D_BP_R}</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="title_Panel">REMAIN</td>
                                                                <td class="data_Panel highlight" id="DT_FLH_STOP">{R_DT_FLH}</td>
                                                                <td class="data_Panel highlight" id="DT_FRH_STOP">{R_DT_FRH}</td>
                                                                <td class="data_Panel highlight" id="DT_RLH_STOP">{R_DT_RLH}</td>
                                                                <td class="data_Panel highlight" id="DT_RRH_STOP">{R_DT_RRH}</td>
                                                                <td class="data_Panel highlight" id="BP_FRT_STOP">{R_BP_F}</td>
                                                                <td class="data_Panel highlight" id="BR_RR_STOP">{R_BP_R}</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div class="section">
                                                    <table class="pnlTable" id="table_fn">
                                                        <thead>
                                                            <tr>
                                                                <th class="title_Panel" rowspan="2" colspan="2" style="width:28%">ITEM</th>
                                                                <th class="title_Panel" colspan="4">DOOR GARNISH</th>
                                                                <th class="title_Panel" rowspan="2" style ="line-height:20px;">TAIL<br /><br /> GATE</th>
                                                                <th class="title_Panel" rowspan="2"></th>
                                                            </tr>
                                                            <tr>
                                                                <th class="title_Panel">F/LH</th>
                                                                <th class="title_Panel">F/RH</th>
                                                                <th class="title_Panel">R/LH</th>
                                                                <th class="title_Panel">R/RH</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td class="title_Panel" rowspan="2">SCAN</td>
                                                                <td class="title_Panel">DONE</td>
                                                                <td class="data_Panel">{D_DG_FLH}</td>
                                                                <td class="data_Panel">{D_DG_FRH}</td>
                                                                <td class="data_Panel">{D_DG_RLH}</td>
                                                                <td class="data_Panel">{D_DG_RRH}</td>
                                                                <td class="data_Panel">{D_TG}</td>
                                                                <td class="data_Panel"></td>
                                                            </tr>
                                                            <tr>
                                                                <td class="title_Panel">REMAIN</td>
                                                                <td class="data_Panel highlight" id="DG_FLH_STOP">{R_DG_FLH}</td>
                                                                <td class="data_Panel highlight" id="DG_FRH_STOP">{R_DG_FRH}</td>
                                                                <td class="data_Panel highlight" id="DG_RLH_STOP">{R_DG_RLH}</td>
                                                                <td class="data_Panel highlight" id="DG_RRH_STOP">{R_DG_RRH}</td>
                                                                <td class="data_Panel highlight" id="TG_RR_STOP">{R_TG}</td>
                                                                <td class="data_Panel highlight"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </tpl>
                                        <div class="x-clear"></div>
                                    </Html>  
                                </Tpl>
                            </ext:DataView>
                        </Items>
                    </ext:Panel>
                </Items>
        </ext:Viewport>
        <ext:TaskManager ID="TaskManager1" runat="server">
            <Tasks>
                <ext:Task TaskID="timer_refresh" Interval="10000">
                    <DirectEvents>
                        <Update OnEvent="refresh_Time">
                            <EventMask 
                                ShowMask="true" 
                                Target="CustomTarget" 
                                CustomTarget="={Ext.getCmp('#{pnlLayout}')}" 
                                MinDelay="350"
                                />
                        </Update>
                    </DirectEvents>                    
                </ext:Task>
            </Tasks>
        </ext:TaskManager>
    </form>
</body>
</html>

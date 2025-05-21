<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_TV50001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_TVMonitoring.SRM_TV50001" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible"/>
    <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
    <meta content="/images/favicon/SCM.ico" itemprop="image"/>
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>LINE SHIFT UPH</title>

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
        .grid_area table td:nth-child(8), td:nth-child(6){
            background-color:#70a1ff;
            color:white;
            font-weight:600;
        }
        .grid_area table td:nth-child(3), td:nth-child(2){
            background-color:#dfe4ea;
            color:#000;
            font-weight:600;
            text-align:center;
        }
	    
    </style>

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>

    <script type="text/javascript">

        var _datTime;
        function UI_Shown() {
            App.direct.getSVRTime({
                async: false,
                success: function (result) {
                    _datTime = new Date(Date.parse(result));
                }
            });
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

        var Test_FN = function (value, metaData, record, rowIndex, colIndex, store, view) {
            if (!(value === null)) {
                var UPHCD = "RSLT";
                var iCurHour = parseInt(_datTime.toString().substring(16, 18));
                var wk_dt = document.getElementById("df02_WORK_DATE-inputEl").value;
                var selDate = new Date(wk_dt.substring(6) + "-" + wk_dt.substring(3, 5) + "-" + wk_dt.substring(0, 2)).toISOString().slice(0, 10);
                var curDate = new Date(_datTime).toISOString().slice(0, 10);
                if (selDate != curDate) iCurHour = 7;

                var dataIndex, c = 0;

                //To find Data Index value of the record
                for (x in record.data) {
                    if (c == colIndex - 1) {
                        dataIndex = x;
                        break;
                    }
                    c++;
                }

                //Logic
                if (dataIndex == "SAP_RSLT_QTY") {
                    if (selDate != curDate) {
                        if (record.data.SAP_PLAN_QTY > record.data.SAP_RSLT_QTY) {
                            UPHCD = "UPH000";
                        }
                        else {
                            UPHCD = "UPH100";
                        }
                    }
                }
                else {
                    var uph_50 = 0;
                    uph_50 = parseInt(record.data.UPH / 2);
                    if (parseInt(dataIndex.substring(4)) == iCurHour) {
                        if (value >= 0 && value < uph_50) {
                            UPHCD = "CUPH000";
                        }
                        else if (value >= uph_50 && value < record.data.UPH) {
                            UPHCD = "CUPH050";
                        }
                        else if (value >= record.data.UPH) {
                            UPHCD = "CUPH100";
                        }
                    }
                    else {
                        if (value >= 0 && value < uph_50) {
                            UPHCD = "UPH000";
                        }
                        else if (value >= uph_50 && value < record.data.UPH) {
                            UPHCD = "UPH050";
                        }
                        else if (value >= record.data.UPH) {
                            UPHCD = "UPH100";
                        }
                    }
                }

                switch (UPHCD) {
                    case "UPH000": metaData.style = "background-color:#DB5A6B"; break;
                    case "UPH050": metaData.style = "background-color:#FFB94E"; break;
                    case "UPH100": metaData.style = "background-color:#2ABB9B"; break;
                    case "CUPH000": metaData.style = "background-color:red;"; break;
                    case "CUPH050": metaData.style = "background-color:yellow;"; break;
                    case "CUPH100": metaData.style = "background-color:green;"; break;
                    case "RSLT": metaData.style = ""; break;
                    default: metaData.style = "background-color:#DB5A6B"; break;
                }
            }

            return value;
        };

    </script>

</head>
<body>
    <form id="Line_Shift_UPH" runat="server">

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
                        <ext:Label ID="lbl01_TBR50001" runat="server" Cls="search_area_title_name" Text="LINE SHIFT UPH" />
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
                                <col style="width: 100px;" />
                                <col />
                            </colgroup>
                            <tr>
                                <th>
                                    <ext:Label ID="lbl01_DATE" runat="server" Text="Date" />
                                </th>
                                <td>
                                    <ext:DateField ID="df02_WORK_DATE" Width="220" Cls="inputDate" Type="Date" runat="server" Editable="true"   />
                                </td>
                                <td>
                                    <ext:TextField ID="txt01_timer" Width="50" Cls="inputText" runat="server" ReadOnly="true" StyleSpec="float:right;"/>
                                </td>
                            </tr>
                        </table>
                    </Content>
                </ext:Panel>

                <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area">
                    <Items>
                        <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." >
                            <Store>
                                <ext:Store ID="Store1" runat="server">
                                    <Model>
                                        <ext:Model ID="Model1" runat="server" IDProperty="Name">
                                            <Fields>
                                                <ext:ModelField Name="DELI_TYPE" />
                                                <ext:ModelField Name="LINE" />
                                                <ext:ModelField Name="KMI_PLAN_QTY" />
                                                <ext:ModelField Name="KMI_RSLT_QTY" />
                                                <ext:ModelField Name="SAP_PLAN_QTY" />
                                                <ext:ModelField Name="SAP_RSLT_QTY" />
                                                <ext:ModelField Name="UPH" />
                                                <ext:ModelField Name="GAVG" />
                                                <ext:ModelField Name="AVG1" />
                                                <ext:ModelField Name="AVG2" />
                                                <ext:ModelField Name="AVG3" />
                                                <ext:ModelField Name="TOT_08" />
                                                <ext:ModelField Name="TOT_09" />
                                                <ext:ModelField Name="TOT_10" />
                                                <ext:ModelField Name="TOT_11" />
                                                <ext:ModelField Name="TOT_12" />
                                                <ext:ModelField Name="TOT_13" />
                                                <ext:ModelField Name="TOT_14" />
                                                <ext:ModelField Name="TOT_15" />
                                                <ext:ModelField Name="TOT_16" />
                                                <ext:ModelField Name="TOT_17" />
                                                <ext:ModelField Name="TOT_18" />
                                                <ext:ModelField Name="TOT_19" />
                                                <ext:ModelField Name="TOT_20" />
                                                <ext:ModelField Name="TOT_21" />
                                                <ext:ModelField Name="TOT_22" />
                                                <ext:ModelField Name="TOT_23" />
                                                <ext:ModelField Name="TOT_24" />
                                                <ext:ModelField Name="TOT_01" />
                                                <ext:ModelField Name="TOT_02" />
                                                <ext:ModelField Name="TOT_03" />
                                                <ext:ModelField Name="TOT_04" />
                                                <ext:ModelField Name="TOT_05" />
                                                <ext:ModelField Name="TOT_06" />
                                                <ext:ModelField Name="TOT_07" />
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
                                    <ext:RowNumbererColumn ID="NO_1"      ItemID="1"        runat="server" Text="No"        Width="40" Align="Center"  />
                                    <ext:Column ID="DELI_TYPE" runat="server" ItemID="2" Text="-" Width="50" DataIndex="DELI_TYPE" Align="Center" cls='grid-row-span'>
                                    </ext:Column>
                                    <ext:Column ID="LINE" runat="server" ItemID="3" Text="LINE" Width="158" DataIndex="LINE" Align="Left"/>
                                    <ext:Column ID="KMI_DATA" runat="server" Text="KMI" ItemID="KMI_DATA">
                                        <Columns>
                                            <ext:NumberColumn ID="KMI_PLAN_QTY" runat="server" ItemID="4" Text="PLAN" Width="50" DataIndex="KMI_PLAN_QTY" Align="Center" Format="#,##0.###"/>
                                            <ext:NumberColumn ID="KMI_RSLT_QTY" runat="server" ItemID="5" Text="UPH" Width="50" DataIndex="KMI_RSLT_QTY" Align="Center" Format="#,##0.###"/>
                                        </Columns>
                                    </ext:Column>
                                    <ext:Column ID="SAP_DATA" runat="server" Text="SSAP" ItemID="SAP_DATA">
                                        <Columns>
                                            <ext:NumberColumn ID="SAP_PLAN_QTY" runat="server" ItemID="6" Text="PLAN" Width="50" DataIndex="SAP_PLAN_QTY" Align="Center" Format="#,##0.###" />
                                            <ext:NumberColumn ID="SAP_RSLT_QTY" runat="server" ItemID="7" Text="RSLT" Width="50" DataIndex="SAP_RSLT_QTY" Align="Center" Format="#,##0.###" >
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                        </Columns>
                                    </ext:Column>
                                    <ext:Column ID="UPH_DATA" runat="server" Text="UPH" ItemID="UPH_DATA">
                                        <Columns>
                                            <ext:NumberColumn ID="STD_UPH" runat="server" ItemID="8" Text="STD" Width="50" DataIndex="UPH" Align="Center" Format="#,##0.###"/>
                                            <ext:NumberColumn ID="GAVG_UPH" runat="server" ItemID="9" Text="AVG" Width="50" DataIndex="GAVG" Align="Center" Format="#,##0.###" />
                                            <ext:NumberColumn ID="AVG1_UPH" runat="server" ItemID="10" Text="SH1" Width="50" DataIndex="AVG1" Align="Center" Format="#,##0.###" />
                                            <ext:NumberColumn ID="AVG2_UPH" runat="server" ItemID="11" Text="SH2" Width="50" DataIndex="AVG2" Align="Center" Format="#,##0.###" />
                                            <ext:NumberColumn ID="AVG3_UPH" runat="server" ItemID="12" Text="SH3" Width="50" DataIndex="AVG3" Align="Center" Format="#,##0.###" />
                                         </Columns>
                                    </ext:Column>
                                    <ext:Column ID="SHIFT_01" runat="server" Text="1 SHIFT" ItemID="SHIFT_01">
                                        <Columns>
                                            <ext:NumberColumn ID="TOT_08" runat="server" itemID="TOT_08" Text="08" Width="50" DataIndex="TOT_08" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_09" runat="server" ItemID="TOT_09" Text="09" Width="50" DataIndex="TOT_09" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_10" runat="server" itemID="TOT_10" Text="10" Width="50" DataIndex="TOT_10" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_11" runat="server" itemID="TOT_11" Text="11" Width="50" DataIndex="TOT_11" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_12" runat="server" itemID="TOT_12" Text="12" Width="50" DataIndex="TOT_12" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_13" runat="server" itemID="TOT_13" Text="13" Width="50" DataIndex="TOT_13" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_14" runat="server" itemID="TOT_14" Text="14" Width="50" DataIndex="TOT_14" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_15" runat="server" itemID="TOT_15" Text="15" Width="50" DataIndex="TOT_15" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_16" runat="server" itemID="TOT_16" Text="16" Width="50" DataIndex="TOT_16" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                        </Columns>
                                    </ext:Column>
                                   <ext:Column ID="SHIFT_02" runat="server" Text="2 SHIFT" ItemID="SHIFT_02">
                                        <Columns>
                                            <ext:NumberColumn ID="TOT_17" runat="server" ItemID="TOT_17" Text="17" Width="50" DataIndex="TOT_17" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_18" runat="server" itemID="TOT_18" Text="18" Width="50" DataIndex="TOT_18" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_19" runat="server" itemID="TOT_19" Text="19" Width="50" DataIndex="TOT_19" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_20" runat="server" itemID="TOT_20" Text="20" Width="50" DataIndex="TOT_20" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_21" runat="server" itemID="TOT_21" Text="21" Width="50" DataIndex="TOT_21" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_22" runat="server" itemID="TOT_22" Text="22" Width="50" DataIndex="TOT_22" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_23" runat="server" itemID="TOT_23" Text="23" Width="50" DataIndex="TOT_23" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_24" runat="server" itemID="TOT_24" Text="24" Width="50" DataIndex="TOT_24" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_01" runat="server" itemID="TOT_01" Text="01" Width="50" DataIndex="TOT_01" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                        </Columns>
                                    </ext:Column>
                                    <ext:Column ID="SHIFT_03" runat="server" Text="3 SHIFT" ItemID="SHIFT_03">
                                        <Columns>
                                            <ext:NumberColumn ID="TOT_02" runat="server" ItemID="TOT_02" Text="02" Width="50" DataIndex="TOT_02" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_03" runat="server" itemID="TOT_03" Text="03" Width="50" DataIndex="TOT_03" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_04" runat="server" itemID="TOT_04" Text="04" Width="50" DataIndex="TOT_04" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_05" runat="server" itemID="TOT_05" Text="05" Width="50" DataIndex="TOT_05" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_06" runat="server" itemID="TOT_06" Text="06" Width="50" DataIndex="TOT_06" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                            <ext:NumberColumn ID="TOT_07" runat="server" itemID="TOT_07" Text="07" Width="50" DataIndex="TOT_07" Align="Center" Format="#,##0.###">
                                                <Renderer Fn="Test_FN" />
                                            </ext:NumberColumn>
                                        </Columns>
                                    </ext:Column>
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
                            <BottomBar>
                                <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."/>
                            </BottomBar>
                        </ext:GridPanel>
                    </Items>
                </ext:Panel>
            </Items>
        </ext:Viewport>
        <ext:TaskManager ID="TaskManager1" runat="server">
            <Tasks>
                <ext:Task
                    TaskID="timer_refresh"
                    Interval="1000">
                    <DirectEvents>
                        <Update OnEvent="refresh_Time">
                            <EventMask 
                                ShowMask="true" 
                                Target="CustomTarget" 
                                CustomTarget="={Ext.getCmp('#{txt01_timer}')}" 
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

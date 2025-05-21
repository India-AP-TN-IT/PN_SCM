<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA22001P2.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_QA.SRM_QA22001P2" %>
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

    <title>측정 데이터 등록/조회 상세 Popup</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <%--아래의 CSS는 D_TITLE컬럼의 스타일 설정한다. 참고: ITEMID가 있으면 ITEMID가 우선된다.--%>
    <%-- 첫번째 컬럼을 헤더처럼 표시되게 하기 위함... 디자인 정해지면..다시 작업해야함.--%>
    <style type="text/css">	    
	    .x-grid-cell-D_TITLE DIV
	    {	
	        font: normal 12px Tahoma, Arial, "굴림", Gulim, Helvetica, AppleGothic, Sans-serif;
            border-right: 0px solid #d0d0d0;
            border-bottom: 1px solid #d0d0d0;
            color: #4f4f71;
            font-weight: bold;
		    background: #ececee url(../../images/common/grid_bg.gif) repeat-x;  
	    } 
	
        
	    .search_area_table table td 
	    {
	        text-align: left;
            border-bottom: 1px solid #b1b1b1;
            color: #000;
            vertical-align: middle;
            vertical-align: top;
            padding: 3px 0 0 10px;
	    }    
    </style>
    

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {            
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.Grid01.setHeight(App.TopGridPanel.getHeight());
            App.Grid02.setHeight(App.BottomGridPanel.getHeight());
        }


        
        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            //더블클릭한 컬럼의 날짜에 해당하는 측정값을 하단에 위치한 입력 컨트롤에 표시한다.
            var grid = grid.ownerCt;


            var col = grid.columns[cellIndex].dataIndex;
            
            var mm_dd = grid.getStore().getAt(0).data[col];
            if (mm_dd != "" && mm_dd != "Date") {
                App.direct.Cell_DoubleClick(mm_dd);
            }
        }

    </script>
</head>
<body>
    <form id="SRM_QA22001P2" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>

    <ext:TextField ID="hiddenLANG_SET" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenBIZCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenVENDCD" runat="server" Hidden="true"></ext:TextField>
    <ext:DateField ID="hiddenYM" runat="server" Hidden="true"></ext:DateField>
    <ext:TextField ID="hiddenCARTYPE" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenITEMCODE" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenMEASCD" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenSEARCHGB" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenSERIAL" runat="server" Hidden="true"></ext:TextField>
    <ext:TextField ID="hiddenMEAS_UNIT" runat="server" Hidden="true"></ext:TextField>
    

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10"  Cls="pdb10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30"  >
                <Items>
                    <ext:Label ID="lbl01_SRM_QA22001P2" runat="server" Cls="search_area_title_name" /><%--Text="측정 데이터 등록/조회 상세 Popup" />--%>
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
                            <col />                            
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_WRITE_MONTH" runat="server" /><%-- Text="작성월" />--%>
                            </th>
                            <td>
                                <ext:Label ID="txt01_WRITE_MONTH" Width="130" Cls="inputText" runat="server" />
                            </td>
                        </tr>
                    </table>
                    <%-- 숨겨 사용하기 ^^;;; --%>
                    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
                </Content>
            </ext:Panel>

            <ext:Panel ID="ContentPanel" runat="server" Region="Center" Layout="BorderLayout">
                <Items>
                    
                    <ext:Panel ID="TopGridPanel"  Region="North" Border="True" runat="server" Height="68px" Cls="grid_area">
                        <Items>                           
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="SERIAL" />
                                                    <ext:ModelField Name="VINCD" />
                                                    <ext:ModelField Name="VINNM" />
                                                    <ext:ModelField Name="ITEMCD" />
                                                    <ext:ModelField Name="ITEMNM" />
                                                    <ext:ModelField Name="MEAS_ITEMCD" />
                                                    <ext:ModelField Name="MEAS_ITEMNM" />
                                                    <ext:ModelField Name="STD_PHOTO" />       
                                                    <ext:ModelField Name="MGRT_ITEMNM" />
                                                    <ext:ModelField Name="MEAS_INST" />
                                                    <ext:ModelField Name="STANDARD" />
                                                    <ext:ModelField Name="STD_MIN_MEAS" />
                                                    <ext:ModelField Name="STD_MAX_MEAS" />
                                                    <ext:ModelField Name="MEAS_UNIT" />
                                                    <ext:ModelField Name="MEAS_UNITNM" />
                                                    <ext:ModelField Name="VENDCD" />
                                                    <ext:ModelField Name="VENDNM" />
                                                    <ext:ModelField Name="VENDCD2" />
                                                    <ext:ModelField Name="VENDNM2" />
                                                    <ext:ModelField Name="MEAS_POINT" />
                                                    <ext:ModelField Name="GATE_RNR" />
                                                    <ext:ModelField Name="CPK" />
                                                    <ext:ModelField Name="DECISION" />
                                                    <ext:ModelField Name="SAMPLE_CNT" />
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                        <Listeners>
                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                          <%--  <Load Delay="1" Handler="GridStoreReady(App.GridStatus1, this.getTotalCount());  "></Load>--%>
                                        </Listeners>
                                    </ext:Store>
                                </Store>
                                <Plugins>
                                    <ext:BufferedRenderer ID="BufferedRenderer1"  runat="server"/>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel1" runat="server">
                                    <Columns>
                                        <ext:RowNumbererColumn ID="NO"      ItemID="NO"           runat="server" Text="No"                Width="25"  Align="Center" />
                                        <ext:Column ID="VINNM"              ItemID="VIN"          runat="server" DataIndex="VINNM"        Width="40"  Align="Center"/>                  <%--Text="차종"--%>       
                                        <ext:Column ID="ITEMNM"             ItemID="ITEM"         runat="server" DataIndex="ITEMNM"       Width="60"  Align="Left"/>                    <%--Text="품목"--%>       
                                        <ext:Column ID="MEAS_ITEMNM"        ItemID="ITEMNM4"      runat="server" DataIndex="MEAS_ITEMNM"  MinWidth="100" Align="Left" Flex="1"/>        <%--Text="품명"--%>       
                                        <ext:Column ID="MGRT_ITEMNM"        ItemID="MGRT_ITEMNM"  runat="server" DataIndex="MGRT_ITEMNM"  Width="100" Align="Left" />                   <%--Text="관리항목"--%>                
                                        <ext:Column ID="MEAS_INST"          ItemID="MEAS_INST"    runat="server" DataIndex="MEAS_INST"    Width="50"  Align="Center"/>                  <%--Text="측정기"--%>     
                                        <ext:NumberColumn ID="STANDARD"     ItemID="STANDARD"     runat="server" DataIndex="STANDARD"     Width="50"  Align="Right" Format="#,##0.00"/> <%--Text="규격"--%>       
                                        <ext:NumberColumn ID="STD_MIN_MEAS" ItemID="STD_MIN_MEAS" runat="server" DataIndex="STD_MIN_MEAS" Width="60"  Align="Right" Format="#,##0.00"/> <%--Text="하한치"--%>     
                                        <ext:NumberColumn ID="STD_MAX_MEAS" ItemID="STD_MAX_MEAS" runat="server" DataIndex="STD_MAX_MEAS" Width="60"  Align="Right" Format="#,##0.00"/> <%--Text="상한치"--%>     
                                        <ext:Column ID="MEAS_UNITNM"        ItemID="MEAS_UNITNM"  runat="server" DataIndex="MEAS_UNITNM"  Width="60"  Align="Center"/>                  <%--Text="측정단위"--%>   
                                        <ext:Column ID="VENDNM"             ItemID="VENDNM"       runat="server" DataIndex="VENDNM"       MinWidth="100" Align="Left" Flex="1"/>        <%--Text="업체명"--%>     
                                        <ext:Column ID="VENDNM2"            ItemID="VENDNM2"      runat="server" DataIndex="VENDNM2"      MinWidth="100" Align="Left" Flex="1"/>        <%--Text="측정업체명"--%> 
                                        <ext:Column ID="MEAS_POINT"         ItemID="MEAS_POINT"   runat="server" DataIndex="MEAS_POINT"   MinWidth="100" Align="Left" Flex="1"/>        <%--Text="측정자"--%>     
                                        <ext:Column ID="GATE_RNR"           ItemID="GATE_RNR"     runat="server" DataIndex="GATE_RNR"     Width="50"  Align="Center"/>                  <%--Text="Gauge" --%>     
                                        <ext:NumberColumn ID="CPK"          ItemID="CPK"          runat="server" DataIndex="CPK"          Width="55"  Align="Right" Format="#,##0.000"/><%--Text="cpk"--%>        
                                        <ext:Column ID="DECISION"           ItemID="DECISION"     runat="server" DataIndex="DECISION"     Width="50"  Align="Center"/>                  <%--Text="판정"--%>       
                                        <%--<ext:Column ID="BARCODE"             runat="server" Text="BARCODE"  DataIndex="BARCODE"          Width="150" Align="Center"/>--%>
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
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="GridMarginPanel" runat="server" Region="North" Height="10">
                        <Items>
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="BottomGridPanel" runat="server" Border="True" Region="Center" Cls="grid_area">
                        <Items>
                            <ext:GridPanel ID="Grid02" runat="server"  TrailingBufferZone="20" LeadingBufferZone="15" Height="1000" ColumnLines="true" StripeRows="true" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display..." SortableColumns="false" >
                                <Store>
                                    <ext:Store ID="Store2" runat="server" PageSize="50" >
                                        <Model>
                                            <ext:Model ID="Model2" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="D_01" />
                                                    <ext:ModelField Name="D_02" />
                                                    <ext:ModelField Name="D_03" />
                                                    <ext:ModelField Name="D_04" />
                                                    <ext:ModelField Name="D_05" />
                                                    <ext:ModelField Name="D_06" />
                                                    <ext:ModelField Name="D_07" />
                                                    <ext:ModelField Name="D_08" />
                                                    <ext:ModelField Name="D_09" />
                                                    <ext:ModelField Name="D_10" />
                                                    <ext:ModelField Name="D_11" />
                                                    <ext:ModelField Name="D_12" />
                                                    <ext:ModelField Name="D_13" />
                                                    <ext:ModelField Name="D_14" />
                                                    <ext:ModelField Name="D_15" />
                                                    <ext:ModelField Name="D_16" />
                                                    <ext:ModelField Name="D_17" />
                                                    <ext:ModelField Name="D_18" />
                                                    <ext:ModelField Name="D_19" />
                                                    <ext:ModelField Name="D_20" />
                                                    <ext:ModelField Name="D_21" />
                                                    <ext:ModelField Name="D_22" />
                                                    <ext:ModelField Name="D_23" />
                                                    <ext:ModelField Name="D_24" />
                                                    <ext:ModelField Name="D_25" />
                                                    <ext:ModelField Name="D_26" />
                                                    <ext:ModelField Name="D_27" />
                                                    <ext:ModelField Name="D_28" />
                                                    <ext:ModelField Name="D_29" />                                                    
                                                    <ext:ModelField Name="D_30" />
                                                    <ext:ModelField Name="D_31" />
                                                    <ext:ModelField Name="D_TITLE" />
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                        <Listeners>
                                            <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                           <%-- <Load Delay="1" Handler="GridStoreReady(App.GridStatus2, this.getTotalCount());  "></Load>--%>
                                        </Listeners>
                                    </ext:Store>
                                </Store>
                                <Plugins>
                                    <%--<ext:BufferedRenderer ID="BufferedRenderer2" runat="server"/>--%>
                                </Plugins>  
                                <ColumnModel ID="ColumnModel2" runat="server">
                                    <Columns>                                        
                                        <ext:Column ID="D_TITLE"  runat="server" ItemID="D_TITLE" DataIndex="D_TITLE"   Width="70" Align="Center" MenuDisabled="true" Locked="true" /><%--Text="시료군" --%>
                                        <ext:Column ID="D01"  runat="server" ItemID="D_SEQ_01" DataIndex="D_01"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="1"--%> 
                                        <ext:Column ID="D02"  runat="server" ItemID="D_SEQ_02" DataIndex="D_02"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="2"--%> 
                                        <ext:Column ID="D03"  runat="server" ItemID="D_SEQ_03" DataIndex="D_03"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="3"--%> 
                                        <ext:Column ID="D04"  runat="server" ItemID="D_SEQ_04" DataIndex="D_04"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="4"--%> 
                                        <ext:Column ID="D05"  runat="server" ItemID="D_SEQ_05" DataIndex="D_05"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="5"--%> 
                                        <ext:Column ID="D06"  runat="server" ItemID="D_SEQ_06" DataIndex="D_06"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="6"--%> 
                                        <ext:Column ID="D07"  runat="server" ItemID="D_SEQ_07" DataIndex="D_07"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="7"--%> 
                                        <ext:Column ID="D08"  runat="server" ItemID="D_SEQ_08" DataIndex="D_08"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="8"--%> 
                                        <ext:Column ID="D09"  runat="server" ItemID="D_SEQ_09" DataIndex="D_09"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="9"--%> 
                                        <ext:Column ID="D10"  runat="server" ItemID="D_SEQ_10" DataIndex="D_10"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="10"--%>
                                        <ext:Column ID="D11"  runat="server" ItemID="D_SEQ_11" DataIndex="D_11"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="11"--%>
                                        <ext:Column ID="D12"  runat="server" ItemID="D_SEQ_12" DataIndex="D_12"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="12"--%>
                                        <ext:Column ID="D13"  runat="server" ItemID="D_SEQ_13" DataIndex="D_13"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="13"--%>
                                        <ext:Column ID="D14"  runat="server" ItemID="D_SEQ_14" DataIndex="D_14"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="14"--%>
                                        <ext:Column ID="D15"  runat="server" ItemID="D_SEQ_15" DataIndex="D_15"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="15"--%>
                                        <ext:Column ID="D16"  runat="server" ItemID="D_SEQ_16" DataIndex="D_16"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="16"--%>
                                        <ext:Column ID="D17"  runat="server" ItemID="D_SEQ_17" DataIndex="D_17"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="17"--%>
                                        <ext:Column ID="D18"  runat="server" ItemID="D_SEQ_18" DataIndex="D_18"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="18"--%>
                                        <ext:Column ID="D19"  runat="server" ItemID="D_SEQ_19" DataIndex="D_19"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="19"--%>
                                        <ext:Column ID="D20"  runat="server" ItemID="D_SEQ_20" DataIndex="D_20"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="20"--%>
                                        <ext:Column ID="D21"  runat="server" ItemID="D_SEQ_21" DataIndex="D_21"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="21"--%>
                                        <ext:Column ID="D22"  runat="server" ItemID="D_SEQ_22" DataIndex="D_22"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="22"--%>
                                        <ext:Column ID="D23"  runat="server" ItemID="D_SEQ_23" DataIndex="D_23"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="23"--%>
                                        <ext:Column ID="D24"  runat="server" ItemID="D_SEQ_24" DataIndex="D_24"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="24"--%>
                                        <ext:Column ID="D25"  runat="server" ItemID="D_SEQ_25" DataIndex="D_25"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="25"--%>
                                        <ext:Column ID="D26"  runat="server" ItemID="D_SEQ_26" DataIndex="D_26"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="26"--%>
                                        <ext:Column ID="D27"  runat="server" ItemID="D_SEQ_27" DataIndex="D_27"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="27"--%>
                                        <ext:Column ID="D28"  runat="server" ItemID="D_SEQ_28" DataIndex="D_28"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="28"--%>
                                        <ext:Column ID="D29"  runat="server" ItemID="D_SEQ_29" DataIndex="D_29"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="29"--%>
                                        <ext:Column ID="D30"  runat="server" ItemID="D_SEQ_30" DataIndex="D_30"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="30"--%>
                                        <ext:Column ID="D31"  runat="server" ItemID="D_SEQ_31" DataIndex="D_31"   Width="60" Align="Center" MenuDisabled="true" /><%--Text="31"--%>
                                    </Columns>
                                </ColumnModel>
                                <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true"/>
                                    </View>
                                <SelectionModel>
                                    <ext:CellSelectionModel ID="CellSelectionModel" Mode="Simple" runat="server" />
                                    <%--<ext:RowSelectionModel ID="RowSelectionModel2" Mode="Single" runat="server" />--%>
                                </SelectionModel>   
                                <Listeners>
                                    <CellDblClick Fn ="CellDbClick"></CellDblClick>
                                </Listeners>                                             
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <%--<ext:StatusBar ID="GridStatus2" runat="server" Height="24" DefaultText="0 Records To Display..." />--%>
                                </BottomBar>
                            </ext:GridPanel>
                        </Items>
                    </ext:Panel>    
                    <ext:Label ID="lbl01_MSG_SRM_01" runat="server" Cls="grid_area_coment" Region="South" Height="25px" /><%--Text="상단의 그리드를 더블클릭하면 데이터를 가져옵니다."--%>
                    <ext:Panel ID="BottomPanel" runat="server" Region="South" Height="198px">
                        <Items>
                            <ext:FieldContainer ID="CompositeField3" runat="server" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                <Items>
                                    <ext:Panel ID="Panel1" runat="server" Region="West" Height="198px" Width="222px" >
                                        <Items>
                                            <ext:Label ID="lbl01_PHOTO_INFO" runat="server" Region="North" Width="222px" Cls="pop_t_03" /><%--Text="사진정보" --%>
                                            <ext:Panel ID="ImagePanel" runat="server"  Region="West" Width="222px" Border="True" BodyStyle="overflow-y:auto;" Height="172px">
                                                <Items>                                    
                                                    <ext:Image ID="img01_PARTNO" Region="North" Width="220px" runat="server"><Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners></ext:Image>                                                                                                             
                                                </Items>
                                            </ext:Panel>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="MarginPanel" runat="server" Region="West" Width="10">
                                        <Items>
                                        </Items>
                                    </ext:Panel>
                                    <ext:Panel ID="InputPanel" runat="server" Region="Center" Height="198px">
                                        <Items>
                                            <ext:Label ID="lbl01_INPUT_TITLE" runat="server" Region="North" Width="222px" Cls="pop_t_03" /><%--Text="측정 데이터 등록" --%>
                                            <ext:Panel ID="Panel2" Region="North" Cls="search_area_table" runat="server" Height="174px" >
                                                <Content>
                                                    <table style="height:0;">
                                                        <colgroup>
                                                            <col style="width: 100px;" />
                                                            <col style="width: 800px;"/>                            
                                                        </colgroup>                                                  
                                                        <tr>
                                                            <th>
                                                                <ext:Label ID="lbl01_DD" runat="server" /><%--Text="일자" />--%>
                                                            </th>
                                                            <td>
                                                                <ext:DateField ID="df01_WRITE_MONTH" Width="115"  Cls="inputDate" Type="Date" runat="server" Editable="true"   /> 
                                                            </td>                               
                                                        </tr>
                                                        <tr>
                                                            <th>
                                                                <ext:Label ID="lbl01_DATA" runat="server" /><%--Text="데이터" />--%>
                                                            </th>
                                                            <td>
                                                                <table style="height:135px;">
                                                                <colgroup>
                                                                    <col style="width: 30px;" />
                                                                    <col style="width: 145px;"/>                            
                                                                    <col style="width: 30px;"/>         
                                                                    <col style="width: 145px;"/>         
                                                                    <col style="width: 30px;"/>         
                                                                    <col style="width: 145px;"/>         
                                                                    <col style="width: 30px;"/>         
                                                                    <col style="width: 145px;"/>         
                                                                </colgroup> 
                                                                    <tr>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X1" runat="server" Text="X1" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA1" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA1" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X6" runat="server" Text="X6" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA6" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA6" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X11" runat="server" Text="X11" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA11" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA11" runat="server" Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>  
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X16" runat="server" Text="X16" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA16" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA16" runat="server" Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>  
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X2" runat="server" Text="X2" />   
                                                                        </td>         
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA2" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA2" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>  
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X7" runat="server" Text="X7" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA7" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA7" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>   
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X12" runat="server" Text="X12" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA12" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA12" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                                                            
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X17" runat="server" Text="X17" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA17" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA17" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>  
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X3" runat="server" Text="X3" />   
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA3" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA3" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>   
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X8" runat="server" Text="X8" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA8" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA8" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>  
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X13" runat="server" Text="X13" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA13" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA13" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td> 
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X18" runat="server" Text="X18" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA18" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA18" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                                                                    
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X4" runat="server" Text="X4" />
                                                                        </td> 
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA4" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA4" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                      
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X9" runat="server" Text="X9" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA9" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA9" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                    
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X14" runat="server" Text="X14" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA14" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA14" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>       
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X19" runat="server" Text="X19" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA19" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA19" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                          
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X5" runat="server" Text="X5" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA5" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA5" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>     
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X10" runat="server" Text="X10" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA10" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA10" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                  
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X15" runat="server" Text="X15" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA15" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA15" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items>
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>      
                                                                        <td>
                                                                            <ext:Label ID="lbl01_X20" runat="server" Text="X20" />
                                                                        </td>  
                                                                        <td>
                                                                            <ext:TextField ID="txt01_DATA20" Width="100" Cls="inputText" runat="server" MaskRe="/[0-9\.]/"/>
                                                                            <ext:SelectBox ID="cbo01_DATA20" runat="server"  Mode="Local" ForceSelection="true" TriggerAction="All" Width="100">
                                                                                <Items> 
                                                                                    <ext:ListItem Text="" Value="" />
                                                                                    <ext:ListItem Text="OK" Value="1" />
                                                                                    <ext:ListItem Text="NG" Value="0" />
                                                                                </Items>
                                                                            </ext:SelectBox>
                                                                        </td>                                             
                                                                    </tr>
                                                                </table>
                                                            </td>                               
                                                        </tr>
                                                    </table>
                                                </Content>
                                            </ext:Panel>
                                        </Items>
                                    </ext:Panel>
                                </Items>
                            </ext:FieldContainer>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>            

        </Items>
    </ext:Viewport>

    </form>
</body>
</html>

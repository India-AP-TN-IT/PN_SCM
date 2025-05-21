<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA30002.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_QA.SRM_QA30002" %>
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
    <style type="text/css">
     <%--차트와 차트사이 여백이 1px 높이정도 생기는데 배경색이 퍼런색임.. ㅡ.ㅡ; 의도적으로 흰색으로 변경함.--%>
     div.x-border-layout-ct
     {
         background-color:#ffffff; 
     }
     
     
    <%--Grid02의 Title_Column 컬럼 헤더만 폰트 키우고 text-align : left 로 주기위해 --%>
     #TITLE_COLUMN-titleEl 
     {
         text-align : left!important;
         font-weight : bold!important;
         font-size : 15px!important;
     }
       
       
        
    </style>

    <script type="text/javascript">
        // 
        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            var LineChartHeight = App.ChartPanel.getHeight() / 2;
            LineChartHeight = App.ChartPanel.getHeight() - LineChartHeight;
            App.ColumnChartPanel.setHeight(LineChartHeight);

        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }


        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
            var grid = grid.ownerCt;

        }

        //라인 차트(ppm차트)의 마커(포인트) 부분 스타일
        function RendererMarker(sprite, config, rendererData, index) {
                        
            var store = rendererData.store,
                storeItems = store.getData().items,
                record = storeItems[index],
                result_ppm = record && record.data['RESULT_PPM'],
                target_ppm = record && record.data['TARGET_PPM'],                
                isUp = result_ppm > target_ppm,                
                changes = {};
            if (!record) {
                return;
            }
            //라인시리즈 포인트 부분 : ppm보다 큰값이면 red, ppm보다 아래면 초록색
            switch (config.type) {
                case 'marker':
                    changes.strokeStyle = (isUp ? 'red' : '#278f65');
                    changes.fillStyle = (isUp ? 'red' : '#278f65');
                    break;
            }
            return changes;
        }

        //라인 차트(ppm차트)의 레이블 부분 스타일
        //결과값이 목표치보다 이상이면 - 색깔 빨강색(진한), 이하이면 초록색으로 
        function RendererLineChartLabel(text, sprite, config, rendererData, rowIdx) {
            
            var store = rendererData.store,
                storeItems = store.getData().items,
                record = storeItems[rowIdx],
                result_ppm = record && record.data['RESULT_PPM'],
                target_ppm = record && record.data['TARGET_PPM'],
                isUp = result_ppm > target_ppm,
                changes = {};

            changes.fillStyle = (isUp ? 'red' : '#278f65');
            changes.fontWeight = (isUp ? 'bold' : 'normal');
            changes.text = Ext.util.Format.number(text, '#,###.#');
            return changes;
        }

        

        
        //바차트(건수차트) 레이블 스타일 설정.
        //결과값이 목표치보다 이상이면 - 색깔 빨강색, 이하이면 초록색으로 
        function RendererBarChartLabel(text, sprite, config, rendererData, rowIdx) {
        

            var store = rendererData.store,
                storeItems = store.getData().items,
                record = storeItems[rowIdx],
                result_count = record && record.data['RESULT_COUNT'],
                target_count = record && record.data['TARGET_COUNT'],
                isUp = result_count > target_count,
                changes = {};


            if (text == target_count) {
                //현재 차트에 표현되는 값이 목표치와 같으면 label폰트색은 목표값 차트의 색과 동일하도록(blue)
                changes.fillStyle = '#0000ff';
                changes.fontWeight = 'normal';
            }
            else {
                //현재 차트에 표현되는 값이 목표치와 크면 label폰트색은 red, 목표치보다 낮으면 green
                changes.fillStyle = (isUp ? 'red' : 'green');
                changes.fontWeight = (isUp ? 'bold' : 'normal');
            }
            if (text == 0) {
                changes.display = 'none';//값이 0이면 레이블 표시하지 않도록 한다.
            }
            else {
                changes.display = 'Outside';
                changes.text = Ext.util.Format.number(text, '#,###');
            }

            return changes;
        }





        //그리드 스타일 - 표시중인 월 컬럼 배경색 설정하기 위함.
        var RenderGridColumnColor = function (value, meta, record, rowIndex, colIndex, store) {

            var columnName = App.Grid01.columns[colIndex].id;
            var MM = record.data['MM'];
            if (columnName == ("M" + MM)) {
                meta.style = 'background: #c8cede;';
            }

            return Ext.util.Format.number(value, '#,###.#');
            //return value;

        }

        //라인차트 결과PPM 포인트 클릭시 하단 그리드 (월별 세부 불량현황) 재조회
        var fn_ItemClick = function (a, markers, c, d) {
            if (markers.category == "markers") {
                var mm = (markers.index + 1).toString();

                if (mm.length == 1) mm = "0" + mm;
                Ext.net.Mask.show({ msg: 'Loading data...' });
                App.direct.DisplayGrid(mm);
            }
        }
        var xxxxx;

    </script>
</head>
<body>
    <form id="SRM_QA30002" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
        
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
                    <ext:Label ID="lbl01_SRM_QA30002" runat="server" Cls="search_area_title_name" /><%--Text="입고품 불량내용 조회" />--%>
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
                            <col style="width: 300px;"/>
                            <col style="width: 150px;" />
                            <col />
                        </colgroup>
                        <%--현재 페이지에서 검색조건에 날짜는 사용안함--%>
                        <tr>       
                            <th class="ess">
                                <ext:Label ID="lbl01_COR" runat="server" />
                            </th>
                            <td>
                                <ext:SelectBox ID="cbo01_CORCD" runat="server"  Mode="Local" ForceSelection="true"
                                    DisplayField="CORNM" ValueField="CORCD" TriggerAction="All" Width="150">
                                    <Store>
                                        <ext:Store ID="Store2" runat="server" >
                                            <Model>
                                                <ext:Model ID="Model2" runat="server">
                                                    <Fields>
                                                        <ext:ModelField Name="CORCD" />
                                                        <ext:ModelField Name="CORNM" />                                                        
                                                    </Fields>
                                                </ext:Model>
                                            </Model>
                                        </ext:Store>
                                    </Store>
                                </ext:SelectBox>
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
                                                   
                            <th class="ess">
                                <ext:Label ID="lbl01_STD_DATE" runat="server" /><%--Text="기준일자" />--%>
                            </th>
                            <td>
                                <ext:NumberField ID="txt01_STD_YEAR" Width="150" Cls="inputText_Code" FieldCls="inputText_Code" AllowDecimals="true" Step="1" MinValue="1900" MaxValue="9999" runat="server" />                                    
                            </td>

                            <th >
                                <ext:Label ID="lbl01_VEND" runat="server" />
                            </th>
                            <td>
                                <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow"/>
                            </td>       
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>

            <ext:Panel ID="ContentsPanel" runat="server" Region="Center" Layout="BorderLayout" >
                <Items>
                    <ext:Panel ID="ChartPanel" runat="server" Region="Center" Layout="BorderLayout" StyleSpec="background-color:#ffffff;" >
                        <Items>
                        
                        
                            <ext:Panel ID="LineChartPanel" runat="server" Layout="FitLayout" Region="Center">
                                <Items>
                                    <ext:CartesianChart ID="Chart1" runat="server" InsetPadding="20" InnerPadding="0 0 0 70">
                                        <Store>
                                            <ext:Store ID="Store_LineChart" runat="server" AutoDataBind="true">
                                                <Model>
                                                    <ext:Model ID="Model3" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="MM" />
                                                            <ext:ModelField Name="MON" />
                                                            <ext:ModelField Name="TARGET_PPM" />                                            
                                                            <ext:ModelField Name="RESULT_PPM" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>


                                        <Axes>
                                            <%--y축 좌표 설정--%>
                                            <ext:NumericAxis Title="PPM" Position="Left" Fields="RESULT_PPM,TARGET_PPM" Grid="true" Minimum="0" TitleMargin="10">
                                                <Renderer Handler="return Ext.util.Format.number(label, '#,##0.#');" />
                                                <Label TextAlign="Right" CalloutLine="true"/>                                
                                            </ext:NumericAxis>
                                            <%--x축 좌표 설정--%>
                                            <ext:CategoryAxis Position="Bottom" Fields="MON" Grid="true" >
                                                <Label RotationDegrees="0" Hidden="false" />
                                            </ext:CategoryAxis>
                                        </Axes>
                                        <Series>
                                            <%--목표ppm 시리즈--%>
                                            <ext:LineSeries XField="MON" YField="TARGET_PPM" UseSmooth="true">
                                                <StyleSpec>
                                                    <ext:Sprite StrokeStyle="#051783" LineWidth="3" />
                                                </StyleSpec>

                            
                                                <Marker>
                                                    <ext:Sprite Radius="4" LineWidth="0" FillStyle="#051783" StrokeStyle="#051783" />
                                                </Marker>

                                                <Label Field="TARGET_PPM" Display="Over" Color="#051783" 
                                                    Orientation="Horizontal"                                    
                                                    TextAlign="Center"
                                                    RotationDegrees="45"/>        
                                                <Tooltip TrackMouse="true" ShowDelay="0" DismissDelay="0" HideDelay="0">
                                                    <Renderer Handler="toolTip.setHtml(Ext.util.Format.number(record.get('TARGET_PPM'),'#,##0.#') );" />
                                                </Tooltip>
                       
                                            </ext:LineSeries>
                                            
                                            <%--숨김시리즈(result_ppm라인 시리즈 좌표위치 때문에 넣음. 이 시리즈 없으면 시작점이 0위치가 되어버림. 뭔가 이상..--%>
                                            <ext:BarSeries XField="MON" YField="RESULT_PPM" HiddenArray="true" />

                                            <%--결과ppm 시리즈--%>
                                            <ext:LineSeries XField="MON" YField="RESULT_PPM" UseSmooth="true">
                                                <StyleSpec>
                                                    <ext:Sprite StrokeStyle="green" LineWidth="3" />
                                                </StyleSpec>
                                                
                                                <HighlightConfig>
                                                    <ext:Sprite FillStyle="red" Radius="8" LineWidth="2" StrokeStyle="red" />
                                                </HighlightConfig>

                                                <Marker>
                                                    <ext:Sprite Radius="4" LineWidth="0" FillStyle="red" StrokeStyle="red" />                                                                                                        
                                                </Marker>

                                                <Label Field="RESULT_PPM" 
                                                        Display="Over" 
                                                        FillStyle="278f65"
                                                        FontWeight="Bold">
                                                    <Renderer Fn="RendererLineChartLabel" />                                                    
                                                </Label>

                                                <Tooltip TrackMouse="true" ShowDelay="0" DismissDelay="0" HideDelay="0">
                                                    <Renderer Handler="toolTip.setHtml(Ext.util.Format.number(record.get('RESULT_PPM'),'#,##0.#') );" />
                                                </Tooltip>

                                                <Renderer Fn="RendererMarker" />
                                                <Listeners>
                                                    <ItemClick Fn="fn_ItemClick" >                                                        
                                                    </ItemClick>
                                                    
                                                </Listeners>
                                            </ext:LineSeries>
                                        </Series>
                                        <Plugins>
                                            <ext:ChartItemEvents ID="ChartItemEvents2" runat="server" /> <%--차트 아이템 클릭시 이벤트 발생시키기 위해 필요한 plugin--%>
                                        </Plugins>
                                    </ext:CartesianChart>
                
                
                                </Items>
                            </ext:Panel>

                            <ext:Panel ID="ColumnChartPanel" runat="server" Layout="FitLayout" Region="South" Height="300" >
              
                                <Items>
                                    <ext:CartesianChart ID="Chart2" runat="server" InsetPadding="20" InnerPadding="0 0 0 70">
                                        <Store>
                                            <ext:Store ID="Store_ColumnChart" runat="server" AutoDataBind="true">
                                                <Model>
                                                    <ext:Model ID="Model4" runat="server">
                                                        <Fields>
                                                            <ext:ModelField Name="MM" />
                                                            <ext:ModelField Name="MON" />
                                                            <ext:ModelField Name="TARGET_COUNT" />
                                                            <ext:ModelField Name="RESULT_COUNT" />
                                                        </Fields>
                                                    </ext:Model>
                                                </Model>
                                            </ext:Store>
                                        </Store>

                                        <Axes>
                                            <ext:NumericAxis
                                                Position="Left"
                                                Fields="TARGET_COUNT,RESULT_COUNT"
                                                Grid="true"                                                                                                
                                                Minimum="0"  
                                                 
                                                >
                                                <Renderer Handler="return Ext.util.Format.number(label, '#,###');" />
                                                <Label TextAlign="Right"/>
                                                
                                                
                                            </ext:NumericAxis>

                                            <ext:CategoryAxis Position="Bottom" Fields="MON" Grid="true">
                                                <Label RotationDegrees="0" />
                                            </ext:CategoryAxis>
                                        </Axes>
                                        <Plugins>
                                            <ext:ChartItemEvents ID="ChartItemEvents1" runat="server" /> <%--차트 아이템 클릭시 이벤트 발생시키기 위해 필요한 plugin--%>
                                        </Plugins>
                                        <Series>
                                            
                                            <ext:BarSeries                                                
                                                XField="MON"
                                                YField="TARGET_COUNT,RESULT_COUNT"
                                                Titles="Target,Result"
                                                Stacked="False"
                                                Colors="#0000ff,#00b050"
                                                AutoDataBind="True" Title="Target,Result"
                                                >
                                             <%--   <Tooltip ID="Tooltip2" runat="server" TrackMouse="true" MinHeight="1" >                                                    
                                                    <Renderer Handler="xxxxx = context;var div = context.series.getTitle()[Ext.Array.indexOf(context.series.getYField(), context.field)]; toolTip.setTitle('('+ div+')' +Ext.util.Format.number(record.get(context.field),'#,##0'));" />                                                    
                                                </Tooltip>
                                                --%>
                                                
                                                <Label
                                                    Display="Outside"      
                                                    Field="TARGET_COUNT,RESULT_COUNT"                                                    
                                                    TextAlign="Center"  
                                                    Orientation="Horizontal"                                                                                                                                                          
                                                    Color="#0000ff"                                                                                                                                                                                                                                                                                                       
                                                    >
                                                    <Renderer Fn="RendererBarChartLabel"/>  
                                                    
                                                </Label>

                                                
                                                
                                            </ext:BarSeries>
                                            <%--
                                            <ext:BarSeries
                                                Highlight="true"
                                                XField="MM"
                                                YField="RESULT_COUNT"
                                                Stacked="false">
                                                <StyleSpec>
                                                    <ext:Sprite StrokeStyle="#00b050" FillStyle="#00b050"/>
                                                </StyleSpec>
                                                <HighlightConfig>
                                                    <ext:Sprite FillStyle="#00eb6b" StrokeStyle="#00b050" />
                                                </HighlightConfig>

                                                <Tooltip ID="Tooltip1" runat="server" TrackMouse="true">
                                                    <Renderer Handler="toolTip.setTitle(record.get('MM') + ': ' + Ext.util.Format.number(record.get('RESULT_COUNT'), '#,##0'));" />
                                                </Tooltip>
                                                <Label
                                                    Display="Outside"
                                                    Field="RESULT_COUNT"
                                                    Orientation="Horizontal"
                                                    Color="green"
                                                    TextAlign="Center"
                                                    FontWeight="Bold"
                                                    RotationDegrees="45">                                                    
                                                    <Renderer Fn="rendererColumnLabel" />
                                                </Label>                                               
                                            </ext:BarSeries>--%>
                                        </Series>                                        
                                    </ext:CartesianChart>

                                </Items>
                            </ext:Panel>
                        </Items>
                    </ext:Panel>


                    <ext:Panel ID="TopGridPanel" Region="South" runat="server" Height="154"  Layout="FitLayout" >
                        <Items>
                            <ext:Panel ID="TopGridPanelInner" Region="Center" Border="True" runat="server" Cls="grid_area" Height="130" StyleSpec="margin:0px 20px 20px 20px;">
                                <Items>
                                    <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Height="130" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                        <Store>
                                            <ext:Store ID="StoreTopGrid" runat="server" PageSize="50">
                                                <Model>
                                                    <ext:Model ID="Model5" runat="server">
                                                        <Fields>
                                                            <ext:ModelField NAME="YYYY" />
								                            <ext:ModelField NAME="DIV" />
								                            <ext:ModelField NAME="M01" />
                                                            <ext:ModelField NAME="M02" />
								                            <ext:ModelField NAME="M03" />
                                                            <ext:ModelField NAME="M04" />
                                                            <ext:ModelField NAME="M05" />
                                                            <ext:ModelField NAME="M06" />
                                                            <ext:ModelField NAME="M07" />
								                            <ext:ModelField NAME="M08" />
								                            <ext:ModelField NAME="M09" />
								                            <ext:ModelField NAME="M10" />
								                            <ext:ModelField NAME="M11"/>
								                            <ext:ModelField NAME="M12" /> 
                                                            <ext:ModelField NAME="MM" />   
                                                        </Fields>           
                                                    </ext:Model>
                                                </Model>
                                                <Listeners>
                                                    <Exception Handler="var e = e || {message: response.responseText}; Ext.Msg.alert('Exception','Load failed: '+e.message);" />
                                                    
                                                </Listeners>
                                            </ext:Store>
                                        </Store>
                                        <Plugins>
                                            <ext:BufferedRenderer ID="BufferedRenderer2"  runat="server"/>
                                        </Plugins>  
                                        <ColumnModel ID="ColumnModel2" runat="server">
                                            <Columns>                                
                                                <%--<ext:Column ID="DIV" ItemID="DIV" runat="server" DataIndex="DIV" Width="200" Align="Center" /> --%>

                                                <ext:TemplateColumn ID="TemplateColumn1"
                                                    runat="server"                      
                                                    Width="150"                                                                    
                                                    DataIndex="DIV"
                                                    TemplateString='<img style="width:49px;height:12px;" src="../../images/etc/{DIV}.png" />&nbsp;&nbsp;{DIV}'
                                                    Align="Center"
                                                />

                                                <ext:NumberColumn ID="M01" ItemID="DAYNM_01" runat="server" DataIndex="M01" Width="60" Align="Center" Flex="1"> 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M02" ItemID="DAYNM_02" runat="server" DataIndex="M02" Width="60" Align="Center" Flex="1"> 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M03" ItemID="DAYNM_03" runat="server" DataIndex="M03" Width="60" Align="Center" Flex="1"> 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M04" ItemID="DAYNM_04" runat="server" DataIndex="M04" Width="60" Align="Center" Flex="1"> 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M05" ItemID="DAYNM_05" runat="server" DataIndex="M05" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn> 
                                                <ext:NumberColumn ID="M06" ItemID="DAYNM_06" runat="server" DataIndex="M06" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M07" ItemID="DAYNM_07" runat="server" DataIndex="M07" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M08" ItemID="DAYNM_08" runat="server" DataIndex="M08" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M09" ItemID="DAYNM_09" runat="server" DataIndex="M09" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M10" ItemID="DAYNM_10" runat="server" DataIndex="M10" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M11" ItemID="DAYNM_11" runat="server" DataIndex="M11" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                                <ext:NumberColumn ID="M12" ItemID="DAYNM_12" runat="server" DataIndex="M12" Width="60" Align="Center" Flex="1" > 
                                                    <Renderer Fn="RenderGridColumnColor" />
                                                </ext:NumberColumn>
                                            </Columns>
                                        </ColumnModel>
                                        <Loader ID="Loader2" runat="server" AutoLoad="false" Mode="Data">
                                            <LoadMask ShowMask="true" />
                                        </Loader>
                                        <View>
                                            <ext:GridView ID="GridView2" runat="server" EnableTextSelection="true">                                                 
                                            </ext:GridView>
                                        </View>
                                        <SelectionModel>
                                            <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"/>
                                        </SelectionModel>
                       
                                    </ext:GridPanel>
                                </Items>
                            </ext:Panel>    
                        </Items>
                    </ext:Panel>

                    <ext:Panel ID="GridPanel" Region="South" Border="True" runat="server" Cls="grid_area" Height="190">
                        <Items>
                            <ext:GridPanel ID="Grid02" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="StoreBottomGrid" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField NAME="SEQ" />
								                    <ext:ModelField NAME="VEHICLE" />
								                    <ext:ModelField NAME="PARTNAME" />
                                                    <ext:ModelField NAME="PRESNM"       />   
								                    <ext:ModelField NAME="CNT" />                               
                                                    <ext:ModelField NAME="VENDNM" />                                              
                                                       
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
                                        <ext:Column ID="TITLE_COLUMN" runat="server" ItemID="EI31070_TITLE3"  Flex="1" Cls="TITLE_COLUMN"><%--Text="{0}월 세부 불량현황"--%>
                                            <Columns>
                                        
                                                <ext:RowNumbererColumn ID="NO" ItemID="NO" runat="server" Text="No" Width="40" Align="Center" />
                                                <ext:Column ID="VEHICLE" ItemID="VIN" runat="server" DataIndex="VEHICLE" Width="0" Align="Center" Flex="1"/> 
                                                <ext:Column ID="PARTNAME" ItemID="PARTNAME" runat="server" DataIndex="PARTNAME" Width="60" Align="Left" Flex="3"/> 
                                                <ext:Column ID="PRESNM" ItemID="PRESNM" runat="server" DataIndex="PRESNM" Width="60" Align="Left" Flex="3"/>
                                                <ext:NumberColumn ID="CNT" ItemID="COUNT" runat="server" DataIndex="CNT" Width="60" Align="Right" Flex="3" Format="#,##0"/>
                                            
                                            </Columns>
                                        </ext:Column>
                                        
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
                </Items>
            </ext:Panel>              
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_VM30001.aspx.cs" Inherits="Ax.SRM.WP.Home.SRM_VM.SRM_VM30001" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible" >
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
    <style type="text/css">
        .bottom_area_title_name2 { clear:both;  margin-top:0px; height:20px; display:block; background:url(../../images/common/title_icon_s.gif) 0 8px no-repeat; padding-left:10px;font-size:12px;color:#010101;text-align:left;font-weight:bold;}
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }

        //UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            // 그리드의 높이를 패널높이 만큼 자동 확장
            App.GridPanel.setHeight(App.Panel1.getHeight() - 30);
            App.Grid01.setHeight(App.GridPanel.getHeight());
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

        // 그리드의 셀을 더블클릭시 사용하는 메서드
        var CellDbClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {
//            var grid = grid.ownerCt;

//            var userID = grid.getStore().getAt(rowIndex).data["VENDCD"];
//            App.direct.Cell_DoubleClick(userID);
        }


        var CellClick = function (grid, obj1, cellIndex, obj2, obj3, rowIndex, obj4) {

//            var grid = grid.ownerCt;

//            var SRM2090_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2090_STD_YEAR"];
//            var SRM2100_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2100_STD_YEAR"];
//            var SRM2160_STD_YEAR = grid.getStore().getAt(rowIndex).data["SRM2160_STD_YEAR"];
//            var vendcd = grid.getStore().getAt(rowIndex).data["VENDCD"];

//            
//            App.direct.Cell_DoubleClick(vendcd, SRM2090_STD_YEAR, SRM2100_STD_YEAR, SRM2160_STD_YEAR);
        }

        document.onselectstart = function () { return false; }

    </script>
</head>
<body>
    <form id="SRM_VM30001" runat="server">
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
                    <ext:Label ID="lbl01_SRM_VM30001" runat="server" Cls="search_area_title_name" /><%--Text="SQ 인증사 조회" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>
            <ext:Panel ID="Panel2" runat="server" Region="North" Height="27" >
                <Content>
                    <table style="height:0px; margin-bottom: 10px;">
                        <tr>
                            <td align="left" style="color:#555;">
                                <ext:Label ID="lbl01_VM_MSG001" runat="server" />  <%--Text="☞ 업체 SQ인증 여부 확인 차원으로 활용하기 위해 제공되는 자료이며 UPDATE 시점 차이로 정보의 차이가 발생할 수 있습니다."--%>
                            </td>    
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="ConditionPanel" Region="North" Cls="search_area_table" runat="server" >
                <Content>
                    <table style="height:0px;">
                        <colgroup>
                            <col style="width: 100px;" />
                            <col style="width: 250px;" />
                            <col style="width: 100px;" />
                            <col style="width: 350px;" />
                            <col style="width: 100px;" />
                            <col style="width: 250px;" />
                            <col style="width: 100px;" />
                            <col />
                        </colgroup>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VENDCD" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_SQ_VENDCD" Width="150" Cls="inputText" runat="server" />      
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_SQ_VENDNAME" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_SQ_VENDNM" Width="250" Cls="inputText" runat="server" />      
                            </td>
                            <th>
                                <ext:Label ID="lbl01_BIZ_TYPE" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_BIZ_TYPE" Width="150" Cls="inputText" runat="server" />                                   
                            </td>
                            <th>
                                <ext:Label ID="lbl01_ADDR" runat="server" />
                            </th>  
                            <td>
                                <ext:TextField ID="txt01_ADDR" Width="400" Cls="inputText" runat="server" />      
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VENDCD6" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_T1_VENDCD" Width="150" Cls="inputText" runat="server" />      
                            </td>   
                            <th>
                                <ext:Label ID="lbl01_CMPNO" runat="server" />
                            </th>
                            <td>
                                <ext:TextField ID="txt01_CMPNO" Width="250" Cls="inputText" runat="server" />      
                            </td>
                            <td colspan="4"></td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
            <ext:Panel ID="Panel1" Region="Center" runat="server" StyleSpec="margin-bottom:10px;">
                <Items>
                    <ext:Label ID="lbl01_VM30001_TIT" runat="server" Cls="bottom_area_title_name2" Text="SQ업체목록"/><%--Text="SQ업체 목록"--%>
                    <ext:Panel ID="GridPanel" Region="Center" Border="True" runat="server" Cls="grid_area" >
                        <Items>                    
                            <ext:GridPanel ID="Grid01" runat="server" ColumnLines="true" StripeRows="true" Scroll="Both" TrackMouseOver="true" EnableTheming="true" EmptyText="No Records To Display...">
                                <Store>
                                    <ext:Store ID="Store1" runat="server" PageSize="50">
                                        <Model>
                                            <ext:Model ID="GridModel1" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="CORCD" />
                                                    <ext:ModelField Name="SQ_VENDCD" />
                                                    <ext:ModelField Name="SQ_VENDNM" />
                                                    <ext:ModelField Name="BIZ_TYPE" />
                                                    <ext:ModelField Name="CERTI_YN" />
                                                    <ext:ModelField Name="GRADE" />  
                                                    <ext:ModelField Name="REPRESENM" />  
                                                    <ext:ModelField Name="ADDR" />  
                                                    <ext:ModelField Name="CMPNO" />
                                                    <ext:ModelField Name="T1_VENDCD" />
                                                    <ext:ModelField Name="T1_VENDNM" />
                                                    <ext:ModelField Name="REMARK" />
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
                                        <ext:Column ID="VENDCD" ItemID="SQ_VENDCD" runat="server" DataIndex="SQ_VENDCD" Width="110" Align="Center" /><%--Text="업체코드"--%>
                                        <ext:Column ID="SQ_VENDNAME" ItemID="SQ_VENDNM" runat="server" DataIndex="SQ_VENDNM" Width="200" Align="Left" /><%--Text="업체명"--%>
                                        <ext:Column ID="BIZ_TYPE" ItemID="BIZ_TYPE" runat="server" DataIndex="BIZ_TYPE" Width="70" Align="Center" /><%--Text="업종"--%>
                                        <ext:Column ID="CERTI_YN" ItemID="CERTI_YN" runat="server" DataIndex="CERTI_YN" Width="70" Align="Center" /><%--Text="인증여부"--%>
                                        <ext:Column ID="GRADE2" ItemID="GRADE" runat="server" DataIndex="GRADE" Width="70" Align="Center" /><%--Text="등급"--%>
                                        <ext:Column ID="REPRESENM" ItemID="REPRESENM" runat="server" DataIndex="REPRESENM" Width="100" Align="Center" /><%--Text="대표자명"--%>
                                        <ext:Column ID="ADDR" ItemID="ADDR" runat="server" DataIndex="ADDR" Width="400" Align="Left" /><%--Text="주소"--%>
                                        <ext:Column ID="CMPNO" ItemID="CMPNO" runat="server" DataIndex="CMPNO" Width="100" Align="Center" /><%--Text="사업자등록번호"--%>
                                        <%--Text="SQ주관장 1차사">--%>
                                        <ext:Column ID="T1_VEND" ItemID="T1_VEND" runat="server" >
                                            <Columns>
                                                <ext:Column ID="T1_VENDCD" ItemID="T1_VENDCD" runat="server" DataIndex="T1_VENDCD" Width="100" Align="Center" /><%--Text="업체코드"--%>
                                                <ext:Column ID="T1_VENDNM" ItemID="T1_VENDNM" runat="server" DataIndex="T1_VENDNM" Width="250" Align="Left" /><%--Text="주관장 업체명"--%>
                                            </Columns>
                                        </ext:Column>
                                        <ext:Column ID="REMARK" ItemID="REMARK" runat="server" DataIndex="REMARK" Width="300" Flex="1" Align="Left"/><%--Text="비고"--%>  
                                    </Columns>
                                </ColumnModel>
                                <Loader ID="Loader1" runat="server" AutoLoad="false" Mode="Data">
                                    <LoadMask ShowMask="true" />
                                </Loader>
                                <View>
                                    <ext:GridView ID="GridView1" runat="server" EnableTextSelection="true" />
                                </View>
                                <SelectionModel>                            
                                    <ext:RowSelectionModel ID="RowSelectionModel1" runat="server" SingleSelect="true" Mode="Single"/>
                                </SelectionModel>    
                                <BottomBar>
                                    <%--복사 또는 이름 변경시 Store 의 Load 핸들러에 있는 GridStatus1 이름도 같이 변경해주세요 --%>
                                    <ext:StatusBar ID="GridStatus1" runat="server" Height="24" DefaultText="0 Records To Display..."></ext:StatusBar>
                                </BottomBar>
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

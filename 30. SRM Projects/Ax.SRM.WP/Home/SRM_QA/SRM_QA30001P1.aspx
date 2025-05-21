<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_QA30001P1.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_QA.SRM_QA30001P1" %>
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

    <title>입고품 불량내용 상세조회</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />

    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">
        function UI_Shown() {
            this.UI_Resize();
        }

        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
        }

        function fn_UserSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 기본처리외 팝업창의 다른필드의 값을 가져와서 처리하고 싶다면 record 를 이용하도록 한다.
        }

        function fn_GridSetValues(popupID, objectID, typeNM, typeCD, record) {
            // 그리드의 경우 처리는 기존처럼 직접 처리하도록 하며, record 는 fn_UserSetValues 와 사용법이 동일하다.
        }

    </script>
    <style type="text/css">
        .search_area_table table th 
        {
            height:27px;
        }
	    /* 4.X에 이미지 보이도록 수정 */
	    #IMG_PANEL-bodyWrap,#IMG_PANEL02-bodyWrap		    
	    {
	        overflow :visible;
	    }            
    </style>
</head>
<body>
    <form id="SRM_QA30001P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <ext:TextField ID="txt01_BIZCD" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />
    <ext:TextField ID="txt01_INSPECT_DIV" runat="server" Hidden="true" />
    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>
        </Listeners>
        <Items>
            <ext:Panel ID="TitlePanel" runat="server" Region="North" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_QA30001P1" runat="server" Cls="search_area_title_name" /> <%--Text="입고품 불량내용 상세조회" />--%>
                    <ext:Panel ID="ButtonPanel" runat="server" StyleSpec="width:100%" Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>            
            <ext:Panel ID="ContentPanel1" runat="server" Cls="search_area_table" Region="Center" >
                <Content>
                    <table style="height:0px;"/>
                        <tr>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_VEND" runat="server" /><%--Text="업체코드" />--%>
                            </th>
                            <td style="width:300px;">
                                <ext:Label ID="VENDCD" runat="server" />    
                            </td>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_VENDNM" runat="server" /><%--Text="업체명"/>--%>
                            </th>
                            <td>
                                <ext:Label ID="VENDNM" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_OCCUR_DATE" runat="server" /><%--Text="발생일자" />--%>
                            </th>
                            <td>
                                <ext:Label ID="RCV_DATE" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_OCCURNO" runat="server" /><%--Text="발생번호" />--%>
                            </th>
                            <td>
                                <ext:Label ID="DEFNO" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_VIN" runat="server" /><%--Text="차종" />--%>
                            </th>
                            <td>
                                <ext:Label ID="VINCD" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_LOTNO" runat="server" /><%--Text="LOT 번호" />--%>
                            </th>
                            <td>
                                <ext:Label ID="LOTNO" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_PARTNO" runat="server" /><%--Text="Part-No." />--%>
                            </th>
                            <td>
                                <ext:Label ID="PARTNO" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_PARTNM" runat="server" /><%--Text="Part-Name" />--%>
                            </th>
                            <td>
                                <ext:Label ID="PARTNM" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_ITEMNM4" runat="server" /><%--Text="품명" />--%>
                            </th>
                            <td>
                                <ext:Label ID="ITEMNM" runat="server" />
                            </td>
                            <th>
                                <ext:Label ID="lbl01_WRITE_EMP" runat="server" /><%--Text="작성자" />--%>
                            </th>
                            <td>
                                <ext:Label ID="NAME_KOR" runat="server" />
                            </td>
                        </tr> 
                    </table>
                    <br />
                    <table style="height:0px; border-top:1px solid #0071bd;" >
                        <tr>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_DEF_CNTT" runat="server" /><%--Text="불량내용" />--%>
                            </th>
                            <td>
                                <ext:Label ID="DEFNM" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_DEF_PLACE" runat="server" /><%--Text="불량발생장소" />--%>
                            </th>
                            <td>
                                <ext:Label ID="DEF_PLACECD" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_DELI_QTY" runat="server" /><%--Text="납품수량" />--%>
                            </th>
                            <td>
                                <ext:Label ID="INSPECT_QTY" runat="server" />
                            </td>
                        </tr> 
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_DEF_QTY" runat="server" /><%--Text="불량수량" />--%>
                            </th>
                            <td>
                                <ext:Label ID="DEF_QTY" runat="server" />
                            </td>
                        </tr> 
                    </table>
                    <br />
                    <table style="height:0px;  border-top:1px solid #0071bd;">
                        <tr>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_MGRT_CNTT" runat="server" /><%--Text="조치내용" />--%>
                            </th>
                            <td>
                                <ext:Label ID="MGRT_CNTTCD" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <ext:Label ID="lbl01_REPLY_DEM_DATE" runat="server" /><%--Text="대책회신요구일" />--%>
                            </th>
                            <td>
                                <ext:Label ID="REPLY_DEM_DATE" runat="server" />
                            </td>
                        </tr> 
                    </table>
                    <br />
                    <table style="height:0px;  border-top:1px solid #0071bd;">
                        <tr>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_OK_PHOTO" runat="server" /><%--Text="양품사진" />--%>
                            </th>
                            <td style="width:300px; height:170px; padding:4px 0px 0px 4px;">
                                <ext:Panel ID="IMG_PANEL" runat="server" Region="West" Width="224px">
                                    <Items>
                                        <ext:Image ID="OK_PHOTO" Height="160px" runat="server" ImageUrl="/images/etc/no_image.gif"><Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners></ext:Image>
                                    </Items>
                                </ext:Panel>
                            </td>
                            <th style="width:120px;">
                                <ext:Label ID="lbl01_DEF_PHOTO" runat="server" /><%--Text="불량사진" />--%>
                            </th>
                            <td>
                                <ext:Panel ID="IMG_PANEL02" runat="server" Region="West" Width="224px">
                                    <Items>
                                        <ext:Image ID="DEF_PHOTO" Height="160px" runat="server" ImageUrl="/images/etc/no_image.gif"><Listeners><Click Handler="ImageZoomPopup(this);"></Click></Listeners></ext:Image>
                                    </Items>
                                </ext:Panel>
                            </td>
                        </tr> 
                    </table>
                </Content>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>

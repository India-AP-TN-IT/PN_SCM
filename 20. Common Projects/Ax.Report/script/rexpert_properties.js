// repert.js info
// version : rexpert 3.0
// date : 2012-03-09

// Rexpert context root url
//rex_gsRexServiceRootURL = window.location.protocol + "//" + window.location.host + "/RexServer30/";
rex_gsRexServiceRootURL = window.location.toString();
rex_gsRexServiceRootURL = rex_gsRexServiceRootURL.substr(0, rex_gsRexServiceRootURL.lastIndexOf("/") + 1);

// 2016.09.17   64비트 추가
if (window.navigator.cpuClass != null && window.navigator.cpuClass.toLowerCase() == "x64")
    rex_is32BitBrowser = false;
if (window.navigator.platform.toLowerCase() == "win64")
    rex_is32BitBrowser = false;

rex_gsPreViewURL = rex_gsRexServiceRootURL + "RexPreview.aspx";                 // preview page
rex_gsReportURL = rex_gsRexServiceRootURL + "rptFormFiles/";                    // rebfiles root directory
rex_gsDownloadURL = rex_gsRexServiceRootURL + "cab/";                           // cab & plugin download directory
rex_gsSetupURL = rex_gsRexServiceRootURL + "cab/download/setup.aspx";           // setup page url
// 2016.09.17   64비트 추가
//rex_gsViewerDownloadURL = rex_gsRexServiceRootURL + (rex_is32BitBrowser ? "cab/rexpert30viewer.exe" : "cab/rexpert30viewerx64.exe");  // Viewer Download Page URL
rex_gsViewerDownloadURL = rex_gsRexServiceRootURL + "cab/rexpert30viewer.exe";  // Viewer Download Page URL
rex_gsRptServiceURL = rex_gsRexServiceRootURL + "rexservice30.aspx";            // RexServer service url
rex_gsRptExportServiceURL = rex_gsRexServiceRootURL + "exportservice.aspx";     // Export Service URL
rex_gsRptExportURL = rex_gsRexServiceRootURL + "export.aspx";                   // Export URL

// default DBconnection
rex_gsUserService = "sql1";

// viewer Version
rex_viewer_version = "1,0,0,529";
rex_viewer_install = "EACH";  // EACH, ONCE, NONE

// setting CSV information
rex_gsCsvSeparatorColumn = "|*|";
rex_gsCsvSeparatorRow = "|#|";
rex_gsCsvSeparatorDataSet = "|@|";
rex_gsCsvEncoding = "utf-8"; 

// default XML xpath
rex_gsXPath = "gubun/rpt1/rexdataset/rexrow";

// Rexpert Web Viewer Windows Size
rex_gsPreViewFeatures = "center=yes,scrollbars=no,status=no,toolbar=no,resizable=1,location=no,menu=no,width=835,height=600";
rex_gsPreViewFeaturesModal = "center:yes;resizable:no;scroll:no;status:no;dialogWidth:825px;dialogHeight:600px";

// Language information
rex_gsViewerLanguage = "ko";

// RexServer 2.5 compatible
rex_gsServerVersion = "2.5";	// 2.5, 3.0

// setting RexServer 2.5
rex_gsRptServiceURL_RexServer25 = rex_gsRexServiceRootURL + "rexservice30.aspx";
rex_gsCsvSeparatorColumn_RexServer25 = "|*|";
rex_gsCsvSeparatorRow_RexServer25 = "|#|";
rex_gsCsvSeparatorDataSet_RexServer25 = "|@|";
rex_gsCsvEncoding_RexServer25 = "utf-8";
rex_gsXPath_RexServer25 = "root/main/rpt1/rexdataset/rexrow";

//setting css
/* 
rex_gsCss = [
	"appearance.pagemargin.visible=0"
	,"appearance.toolbar.button.pagecount.visible=0"
	,"appearance.toolbar.button.print.enable=0"
	,"accessibility.enable=0"
	,"appearance.canvas.backcolor=rgb(255,255,0)"
	,"appearance.control.backcolor=rgb(255,0,0)"
	,"appearance.canvas.offsetx=0"
	,"appearance.canvas.offsety=0"
	,"appearance.toolbar.button.open.visible=0"
	,"appearance.toolbar.button.closewindow.visible=0"
	,"appearance.tabheader.close.enable=0"
	,"appearance.reportlist.visible=1"
	,"print.appearance.allreportprint.enable=1"
	,"print.allreportprint=1"
];
 */

//call method

rex_gsMethod = [
	"Zoom('wholepage')"
	//,"Zoom('pagewidth')"
	//,"Zoom('200')"
	//,"ZoomIn()"
	//,"ZoomOut()"
]


//plugin - webcrypto
/* 
rex_gsPluginTypeWeb = "crypto.clipsoft";
rex_gsPluginWebParam = {"name": "name",
						"common-enable-encode": "1",
						"common-enable-decode": "0",
						"common-delimiter": "|!|",
						"common-encoding": "euc-kr",
						"common-enable-log": "0",
						"common-log-filename": "c:\test2.log"};

rex_gsPluginTypeWeb = "crypto.xecureweb";
rex_gsPluginWebParam = {"name": "name",
						"common-enable-encode": "1",
						"common-enable-decode": "0",
						"common-delimiter": "|!|",
						"common-encoding": "euc-kr",
						"common-enable-log": "0",
						"common-log-filename": "c:\test2.log",
						"xecureweb-gateaddr": "ip-address:443:8080",
						"xecureweb-authtype": "",
						"xecureweb-mehtod": "POST"};
*/

// plugin - DRM
/*
rex_gsPluginType = "markany";
rex_gsPluginParam = {"datapath": rex_gsRexServiceRootURL + "/plugin/markany/MaFpsCommon.jsp",
					"datafilename": "MaPrintInfoCUSTRP.dat",
					"enablecapture": "0",
					"enablespool": "0",
					"enableprinter": "0",
					"printeroption": "3",
					"imagesaferoption": "0"};
*/
/*
rex_gsPluginType = "bcqure";
rex_gsPluginParam = {"initpath": rex_gsRexServiceRootURL +  "/plugin/bcqre/prnInit/",
					"datapath": rex_gsRexServiceRootURL +  "/plugin/bcqre/bcqre.server.jsp",
					"docnumber": "ksfc",
					"docname": "ksfc",
					"barcodewidth": "600",
					"barcodeminheight": "50",
					"barcodemaxheight": "200"};
*/


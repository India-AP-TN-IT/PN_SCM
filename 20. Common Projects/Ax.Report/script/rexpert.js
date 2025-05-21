var rexScript_version = "2014-02-07";
var rexScript_datetime = "20140207";
var rex_gsRexServiceRootURL = window.location.protocol + "//" + window.location.host + "/RexServer30/";
var rex_gsPreViewURL = rex_gsRexServiceRootURL + "rexpreview.jsp";
var rex_gsReportURL = rex_gsRexServiceRootURL + "rebfiles/";
var rex_gsDownloadURL = rex_gsRexServiceRootURL + "cab/";
var rex_gsSetupURL = rex_gsRexServiceRootURL + "cab/download/setup.jsp";
var rex_is32BitBrowser = true;      // 2016.09.17   64비트 추가
var rex_gsViewerDownloadURL = rex_gsRexServiceRootURL + "cab/getviewer.jsp?f=rexpert30viewer.exe";
var rex_gsRptServiceURL = rex_gsRexServiceRootURL + "rexservice.jsp";
var rex_gsRptExportServiceURL = rex_gsRexServiceRootURL + "exportservice.jsp";
var rex_gsRptExportURL = rex_gsRexServiceRootURL + "export.jsp";
var rex_gsUserService = "";
var rex_viewer_version = "1,0,0,0";
var rex_viewer_install = "EACH";
var rex_gsCsvSeparatorColumn = "|*|";
var rex_gsCsvSeparatorRow = "|#|";
var rex_gsCsvSeparatorDataSet = "|@|";
var rex_gsCsvEncoding = "utf-8";
var rex_gsXPath = "gubun/rpt1/rexdataset/rexrow";
var rex_gsPreViewFeatures = "center=yes,scrollbars=no,status=no,toolbar=no,resizable=1,location=no,menu=no";
var rex_gsPreViewFeaturesModal = "center:yes;resizable:no;scroll:no;status:no;dialogWidth:825px;dialogHeight:600px";
var rex_gsViewerLanguage = "ko";
var rex_gsServerVersion = "3.0";
var rex_gsRptServiceURL_RexServer25 = rex_gsRexServiceRootURL + "rexservice25.jsp";
var rex_gsCsvSeparatorColumn_RexServer25 = "|*|";
var rex_gsCsvSeparatorRow_RexServer25 = "|*|";
var rex_gsCsvSeparatorDataSet_RexServer25 = "|@|";
var rex_gsCsvEncoding_RexServer25 = "utf-8";
var rex_gsXPath_RexServer25 = "root/main/rpt1/rexdataset/rexrow";
var rex_gsShowparameterdialog = "0";
var rex_gsHttpTimeout;
var rex_gsCss;
var rex_gsMethod;
var rex_gsPluginTypeWeb;
var rex_gsPluginWebParam;
var rex_gsPluginType;
var rex_gsPluginParam;
var rex_gsPluginHttpParam;
var rex_gsPluginFileType;
var rex_gsPluginFileParam;
var rex_Agent = function () {
    var a = navigator.userAgent;
    function is(s, t) {
        return ((s || "").indexOf(t) > -1)
    };
    this.isWin = is(a, "Windows") || is(a.toLowerCase(), "msie") || is(a.toLowerCase(), "rv:");
    this.isMac = is(a, "Macintosh");
    this.isUnix = !(this.isWin || this.isMac);
    this.isVista = is(a.toLowerCase(), "nt 6");
    this.isWinXp = is(a.toLowerCase(), "nt 5.1");
    this.isW2k = is(a.toLowerCase(), "nt 5.0");
    this.isW98 = is(a.toLowerCase(), "windows 98");
    this.isOP = is(a.toLowerCase(), "opera");
    this.isIE = is(a.toLowerCase(), "msie");
    this.isFF = is(a.toLowerCase(), "firefox");
    this.isCR = is(a.toLowerCase(), "chrome");
    this.isSF = is(a.toLowerCase(), "safari");

    if (!this.isIE && !this.isFF && !this.isCR && !this.isSF && !this.isOP) this.isIE = is(a.toLowerCase(), "rv:");
    if (this.isIE) {
        this.isWin = true;
        try {
            var v = parseFloat(a.match(/MSIE ([0-9\.]+)/)[1]);
            if (isNaN(v)) this.isIE0 = true;
            if (6 <= v && v < 7) {
                this.isIE6 = true;
                return
            } else if (7 <= v && v < 8) {
                this.isIE7 = true;
                return
            } else if (5.5 <= v && v < 6) {
                this.isIE55 = true;
                return
            } else if (v < 5.5) {
                this.isIE5 = true;
                this.isIE = false;
                return
            } else if (8 <= v && v < 9) {
                this.isIE8 = true;
                return
            } else if (9 <= v && v < 10) {
                this.isIE9 = true;
                return
            } else if (10 <= v && v < 11) {
                this.isIE10 = true;
                return
            }
        } catch (e) {
            var v = parseFloat(a.match(/rv:([0-9\.]+)/)[1]);
            if (11 <= v) {
                this.isIE11 = true;
                return
            }
        }
    }
};
function rex_writeRexCtl(a) {
    var b = "100%";
    var c = "100%";
    if (arguments.length > 1) b = arguments[1];
    if (arguments.length > 2) c = arguments[2];
    document.write(rex_getRexCtl(a, b, c))
}
function rex_getRexCtl() {
    var a = new rex_Agent();
    var b = "";
    var c = "RexCtl";
    var d = "100%";
    var e = "100%";
    if (arguments.length > 0) c = arguments[0];
    if (arguments.length > 1) d = arguments[1];
    if (arguments.length > 2) e = arguments[2];
    if ((a.isWin || a.isIE) && !a.isFF) {
        if (a.isIE) {
            // 2016.09.17   64비트 추가
            //var f = "CODEBASE='" + rex_gsDownloadURL + (rex_is32BitBrowser ? "Rexpert30ViewerEXE.cab" : "Rexpert30ViewerEXEx64.cab") + "#version=" + rex_viewer_version + "'";
            var f = "CODEBASE='" + rex_gsDownloadURL + "Rexpert30ViewerEXE.cab" + "#version=" + rex_viewer_version + "'";
            if (rex_viewer_install.toUpperCase() == "NONE") f = "";

            // teebarcode control
            b += "<object id='axTBarCode5'  classid='CLSID:10ED9AE3-DA1A-461C-826A-CD9C850C58E2' CODEBASE='" + rex_gsRexServiceRootURL + "/cab/TBarCode5.cab#version=5,3,0,49' type='application/x-oleobject' style='display: none'></object>";
            // teebarcode control 10
            //b += "<object id='axTBarCode10'  classid='CLSID:FEF2D6AE-79C4-497C-8D69-4E0F45FCFBC5' CODEBASE='" + rex_gsRexServiceRootURL + "/cab/TBarCode10.cab#version=10,2,2,13543' type='application/x-oleobject' style='display: none'></object>";

            // report viewer
            b += "<object id='" + c + "' classid='CLSID:FC035099-833E-4AB1-BF48-37D08F5E553C' " + f + " width='" + d + "' height='" + e + "'>";
            b += "<iframe id='rex_ifrmRexPreview' name='rex_ifrmRexPreview' src='" + rex_gsSetupURL + "?version=" + rex_viewer_version + "' width='100%' height='100%' frameborder='0'></iframe>";
            b += "</object>";
        } else {
            var g = "application/rexpert3.0.plugin,version=" + rex_viewer_version;
            var h = rex_viewer_version.split(",");
            var j = parseInt(h[0]) * 10000 + parseInt(h[1]) * 1000 + parseInt(h[2]) * 1000 + parseInt(h[3]) * 1;
            var k = "";
            var l = "";
            var m = "";
            var n = "N";
            if (j < 10136) {
                g = "application/rexpert3.0.plugin,version=1.0.0.1"
            }
            if (a.isCR || a.isOP || a.isSF || a.isFF) {
                for (var i = 0; i < navigator.mimeTypes.length; i++) {
                    var o = navigator.mimeTypes[i].description;
                    var p = navigator.mimeTypes[i].type;
                    if (o == "rexpert 3.0 plugin viewer") {
                        n = "Y";
                        k = p.split("=");
                        l = k[1].split(",");
                        m = l[3]
                    }
                }
                if (n == "N" || (parseInt(m) < parseInt(h[3]))) {
                    this.window.location.replace(rex_gsSetupURL + "?version=" + rex_viewer_version)
                }
            }
            b += "<object id='" + c + "' ";
            if (n == "Y") {
                b += "type='" + "application/rexpert3.0.plugin,version=1,0,0," + m + "' "
            } else {
                b += "type='" + g + "' "
            }
            // 2016.09.17   64비트 추가
            //b += " codebase='" + rex_gsDownloadURL + (rex_is32BitBrowser ? "rexpert30viewer.exe" : "rexpert30viewerx64.exe") + "' ";
            b += " codebase='" + rex_gsDownloadURL + "rexpert30viewer.exe" + "' ";
            b += " pluginspage='" + rex_gsSetupURL + "?version=" + rex_viewer_version + "' " + " width='" + d + "' height='" + e + "'></object>"
        }
        if (a.isIE || a.isFF) {
            b += "<script type='text/javascript' for='RexCtl' event='FinishDocument'>" + "\r\n";
            b += "	OnFinishDocument();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='javascript' for='RexCtl' event='FinishPrint'>" + "\r\n";
            b += "	OnFinishPrint();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='javascript' for='RexCtl' event='FinishExport(FileName)'>" + "\r\n";
            b += "	OnFinishExport(FileName);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='HyperLinkClicked(Path, Cancel)'>";
            b += "	Cancel = true" + "\r\n";
            b += "	On Error Resume Next" + "\r\n";
            b += "	If Not IsNull(goOOF.event.hyperlinkclicked) Then" + "\r\n";
            b += "		Call goOOF.event.hyperlinkclicked(RexCtl, \"hyperlinkclicked\", MakeHyperLinkClickedArg(Path))" + "\r\n";
            b += "	End If" + "\r\n";
            b += "	Err.Clear" + "\r\n";
            b += "</script>";
            b += "<script language='javascript' for='RexCtl' event='FinishPrintResult(ResultCode)'>" + "\r\n";
            b += "	OnFinishPrintResult(ResultCode);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonPrintClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonPrintClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonPrintClickAfter'>" + "\r\n";
            b += "	OnButtonPrintClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonExportClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonExportClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonExportClickAfter'>" + "\r\n";
            b += "	OnButtonExportClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonRefreshClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonRefreshClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonRefreshClickAfter'>" + "\r\n";
            b += "	OnButtonRefreshClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonExportXLSClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonExportXLSClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonExportXLSClickAfter'>" + "\r\n";
            b += "	OnButtonExportXLSClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonExportPDFClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonExportPDFClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonExportPDFClickAfter'>" + "\r\n";
            b += "	OnButtonExportPDFClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='vbscript' for='RexCtl' event='ButtonExportHWPClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonExportHWPClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonExportHWPClickAfter'>" + "\r\n";
            b += "	OnButtonExportHWPClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script language='javascript' for='RexCtl' event='CancelPrint()'>";
            b += "	OnCancelPrint()" + "\r\n";
            b += "</script>";
            b += "<script language='vbscript' for='RexCtl' event='ButtonCloseWindowClickBefore(Cancel)'>";
            b += "	Cancel = false" + "\r\n";
            b += "	Call OnButtonCloseWindowClickBefore(Cancel)" + "\r\n";
            b += "</script>";
            b += "<script type='text/javascript' for='RexCtl' event='ButtonCloseWindowClickAfter'>" + "\r\n";
            b += "	OnButtonCloseWindowClickAfter();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='PrintPage(totalpage, page)'>" + "\r\n";
            b += "	OnPrintPage(totalpage, page);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='RexpertError(name, description)'>" + "\r\n";
            b += "	OnRexpertError(name, description);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='CancelExport'>" + "\r\n";
            b += "	OnCancelExport();" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='FinishPrintResult(resultcode)'>" + "\r\n";
            b += "	OnFinishPrintResult(resultcode);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='ErrorEvent(errorXML)'>" + "\r\n";
            b += "	OnErrorEvent(errorXML);" + "\r\n";
            b += "</script>" + "\r\n";
            b += "<script type='text/javascript' for='RexCtl' event='BeforePrint(PrintName, FromPage, ToPage, Copies, Cancel)'>" + "\r\n";
            b += "	OnBeforePrint(PrintName, FromPage, ToPage, Copies, Cancel);" + "\r\n";
            b += "</script>" + "\r\n"
        }
    } else {
        b += "<iframe id='rex_ifrmRexPreview' name='rex_ifrmRexPreview' src='about:blank' width='99%' height='99%' frameborder='0' scrolling='no'></iframe>"
    }
    return b
}
function rex_fnLocationHost() {
    var a = "" + document.location;
    var b = window.location.protocol + "//";
    var c = b.length;
    var d = a.indexOf("/", c);
    var e = a.substring(0, d);
    return e
}
var rex_goParamSet = {};
var rex_gaReports = new Array();
var rex_gaReportsIndex = 0;
function GetfnParamSet() {
    if (arguments.length > 0) {
        return GetParamSet(arguments[0])
    } else {
        return GetParamSet()
    }
}
function GetParamSet() {
    if (arguments.length > 0) {
        rex_goParamSet[arguments[0]] = new rex_ParamSet(arguments[0]);
        rex_goParamSet[arguments[0]].datatype = "CSV";
        return rex_goParamSet[arguments[0]]
    } else {
        rex_goParamSet["0"] = new rex_ParamSet("0");
        return rex_goParamSet["0"]
    }
}
function rex_ParamSet(l) {
    this.id = l;
    this.type = "http";
    this.opentype = "";
    this.rptname = "";
    this.exportservice = {};
    this.exportservice.param = {};
    this.exportservice.filename = null;
    this.exportservice.filetype = "pdf";
    this.datatype = "";
    this.data = "";
    this.connectname = "";
    this.connectiononce = "";
    this.xpath = "";
    this.rebfiles = {};
    this.subreports = {};
    this.params = {};
    this.httpparams = {};
    this.datasets = {};
    this.printoption = "";
    this.event = {};
    this.plugin = {};
    this.plugin.param = {};
    this.plugin.type = "";
    this.plugin.cookie = "";
    this.plugin.web = {};
    this.plugin.web.param = {};
    this.printinfo = {};
    this.saveinfo = {};
    this.title = "";
    this.win = null;
    this.userdefineparam = null;
    this.encoding = "";
    this.path = "";
    this.windowtitle = "Rexpert Viewer";
    this.paramtype = "string";
    this.event.init = null;
    this.event.finishdocument = null;
    this.event.finishprint = null;
    this.event.finishprintall = null;
    this.event.finishprintalleach = null;
    this.event.finishexport = null;
    this.event.finishprintresult = null;
    this.event.buttonprintclickbefore = null;
    this.event.buttonprintclickafter = null;
    this.event.buttonexportclickbefore = null;
    this.event.buttonexportclickafter = null;
    this.event.buttonrefreshclickbefore = null;
    this.event.buttonrefreshclickafter = null;
    this.event.buttonexportxlsclickbefore = null;
    this.event.buttonexportxlsclickafter = null;
    this.event.buttonexportpdfclickbefore = null;
    this.event.buttonexportpdfclickafter = null;
    this.event.buttonexporthwpclickbefore = null;
    this.event.buttonexporthwpclickafter = null;
    this.event.cancelprint = null;
    this.event.buttonclosewindowclickbefore = null;
    this.event.buttonclosewindowclickafter = null;
    this.event.printpage = null;
    this.event.cancelexport = null;
    this.event.finishprintresult = null;
    this.event.rexperterror = null;
    this.event.errorevent = null;
    this.event.beforeprint = null;
    rex_ParamSet.prototype.pushclear = function () {
        rex_gaReports = new Array();
        rex_gaReportsIndex = 0
    };
    rex_ParamSet.prototype.push = function (a) {
        rex_gaReports.push(a)
    };
    rex_ParamSet.prototype.reb = function (a) {
        if (this.rebfiles[a] == undefined) {
            this.rebfiles[a] = new rex_RebFile(a)
        }
        this.rebfiles[a].value = "";
        return this.rebfiles[a]
    };
    rex_ParamSet.prototype.param = function (a) {
        if (this.params[a] == undefined) {
            this.params[a] = {}
        }
        this.params[a].value = "";
        return this.params[a]
    };
    rex_ParamSet.prototype.httpparam = function (a) {
        if (this.httpparams[a] == undefined) {
            this.httpparams[a] = {}
        }
        this.httpparams[a].value = "";
        return this.httpparams[a]
    };
    rex_ParamSet.prototype.sub = function (a) {
        if (this.subreports[a] == undefined) {
            this.subreports[a] = new rex_RebSubReport(a)
        }
        this.subreports[a].value = "";
        return this.subreports[a]
    };
    rex_ParamSet.prototype.con = function (a) {
        if (this.subreports[a] == undefined) {
            this.subreports[a] = new rex_RebSubReport(a)
        }
        this.subreports[a].value = "";
        return this.subreports[a]
    };
    rex_ParamSet.prototype.dataset = function (a) {
        if (this.datasets[a] == undefined) {
            this.datasets[a] = {}
        }
        this.datasets[a].value = "";
        return this.datasets[a]
    };
    rex_ParamSet.prototype.toString = function () {
        var a = "";
        var b = new rex_RebConnection();
        var c = {};
        var d = new rex_RebFile();
        a += "<?xml version='1.0' encoding='utf-8'?>";
        a += "<oof version ='3.0'>";
        if (this.title != "") {
            a += "<document title='" + this.title + "' enable-thread='0'>"
        } else {
            a += "<document title='report' enable-thread='0'>"
        }
        if (this.type == undefined) this.type = "http";
        a += "<file-list>";
        var e = "";
        var f = "";
        if (this.rptname != undefined) {
            e += d.toStringFile(this.rptname, "", "", "") + "";
            if (this.exportservice.filename == null) {
                this.exportservice.filename = this.rptname.substr(this.rptname.lastIndexOf("/") + 1)
            }
        }
        var g = "";
        var h = "";
        var i = "";
        for (var j in this.rebfiles) {
            i = "";
            for (var k in this.rebfiles[j].subreports) {
                if (k != undefined) {
                    if (this.rebfiles[j].sub(k).namespace == undefined) {
                        c["namespace"] = k
                    } else {
                        c["namespace"] = this.rebfiles[j].sub(k).namespace
                    }
                    c["type"] = this.rebfiles[j].sub(k).type;
                    c["path"] = this.rebfiles[j].sub(k).path;
                    c["data"] = this.rebfiles[j].sub(k).data;
                    c["connectname"] = this.rebfiles[j].sub(k).connectname;
                    c["connectiononce"] = this.rebfiles[j].sub(k).connectiononce;
                    c["datatype"] = this.rebfiles[j].sub(k).datatype;
                    c["xpath"] = this.rebfiles[j].sub(k).xpath;
                    c["encoding"] = this.rebfiles[j].sub(k).encoding;
                    c["rptname"] = this.rebfiles[j].rptname;
                    b = new rex_RebConnection();
                    i += b.toString(c, this.rebfiles[j].sub(k).httpparams, this.rebfiles[j].sub(k).datasets)
                }
            }
            if (i == "") {
                if (this.type != "ado") {
                    if (this.rebfiles[j].connectname != undefined && this.rebfiles[j].type != undefined) {
                        c["type"] = this.rebfiles[j].type;
                        c["namespace"] = this.rebfiles[j].namespace;
                        c["path"] = this.rebfiles[j].path;
                        c["data"] = this.rebfiles[j].data;
                        c["connectname"] = this.rebfiles[j].connectname;
                        c["connectiononce"] = this.rebfiles[j].sub(k).connectiononce;
                        c["datatype"] = this.rebfiles[j].datatype;
                        c["xpath"] = this.rebfiles[j].xpath;
                        c["encoding"] = this.rebfiles[j].encoding;
                        c["rptname"] = this.rebfiles[j].rptname;
                        b = new rex_RebConnection();
                        i += b.toString(c, this.rebfiles[j].httpparams, this.rebfiles[j].datasets)
                    }
                    if (this.rebfiles[j].connectname != undefined) {
                        c["connectname"] = this.rebfiles[j].connectname;
                        c["rptname"] = this.rebfiles[j].rptname;
                        i += b.toString(c, this.rebfiles[j].httpparams, this.rebfiles[j].datasets)
                    }
                }
            }
            if (i != "") {
                i = "<connection-list>" + i + "</connection-list>"
            }
            if (this.rebfiles[j].rptname != undefined) {
                d = new rex_RebFile();
                f += d.toStringFile(this.rebfiles[j].rptname, d.toStringField(this.rebfiles[j].params, this.paramtype), i, d.toStringConfigParam(this.rebfiles[j].configparams)) + "";
                if (this.exportservice.filename == null) {
                    this.exportservice.filename = this.rebfiles[j].rptname.substr(this.rebfiles[j].rptname.lastIndexOf("/") + 1)
                }
            }
        }
        if (f == null || f == "") {
            a += e
        } else {
            a += f
        }
        a += "</file-list>";
        g = "";
        h = "";
        g += "<connection-list>";
        for (var j in this.subreports) {
            if (this.subreports[j].namespace == undefined) {
                c["namespace"] = j
            } else {
                c["namespace"] = this.subreports[j].namespace
            }
            c["type"] = this.subreports[j].type;
            c["path"] = this.subreports[j].path;
            c["data"] = this.subreports[j].data;
            c["connectname"] = this.subreports[j].connectname;
            c["connectiononce"] = this.subreports[j].connectiononce;
            c["datatype"] = this.subreports[j].datatype;
            c["xpath"] = this.subreports[j].xpath;
            c["encoding"] = this.subreports[j].encoding;
            c["rptname"] = this.rptname;
            b = new rex_RebConnection();
            h += b.toString(c, this.subreports[j].httpparams, this.subreports[j].datasets)
        }
        if (h == "") {
            c["type"] = this.type;
            c["namespace"] = this.namespace;
            c["path"] = this.path;
            c["data"] = this.data;
            c["connectname"] = this.connectname;
            c["connectiononce"] = this.connectiononce;
            c["datatype"] = this.datatype;
            c["xpath"] = this.xpath;
            c["encoding"] = this.encoding;
            c["rptname"] = this.rptname;
            g += b.toString(c, this.httpparams, this.datasets)
        } else {
            g += h
        }
        g += "</connection-list>";
        if (i == "") {
            if (this.type != "ado") {
                a += g
            }
        }
        a += d.toStringField(this.params, this.paramtype);
        a += "<plugin-list>";
        if (this.plugin.type != "") {
            a += "	<plugin type='" + this.plugin.type + "'>";
            a += "		 <config-param-list>";
            for (var j in rex_gsPluginParam) {
                a += "		 		 <config-param name='" + j + "'>" + rex_gsPluginParam[j] + "</config-param>"
            }
            if (this.plugin.cookie != "") {
                a += "<config-param name='cookie'>" + this.plugin.cookie + "</config-param>"
            }
            a += "		 </config-param-list>";
            a += "		 <http-param-list>";
            for (var j in rex_gsPluginHttpParam) {
                a += "		 		 <http-param name='" + j + "'>" + rex_gsPluginHttpParam[j] + "</http-param>"
            }
            a += "		 </http-param-list>";
            a += "	</plugin>"
        }
        if (rex_gsPluginTypeWeb != undefined) {
            a += "	<plugin type='" + rex_gsPluginTypeWeb + "'>";
            a += "		 <config-param-list>";
            for (var j in rex_gsPluginWebParam) {
                a += "	<config-param name='" + j + "'>" + rex_gsPluginWebParam[j] + "</config-param>"
            }
            a += "		 </config-param-list>";
            a += "	</plugin>"
        }
        if (rex_gsPluginFileType != undefined) {
            a += "	<plugin type='" + rex_gsPluginFileType + "'>";
            a += "		 <config-param-list>";
            for (var j in rex_gsPluginFileParam) {
                a += "	<config-param name='" + j + "'>" + rex_gsPluginFileParam[j] + "</config-param>"
            }
            a += "		 </config-param-list>";
            a += "	</plugin>"
        }
        a += "</plugin-list>";
        a += "</document>";
        a += "</oof>";
        return a
    }
}
function rex_RebFile() {
    this.id = arguments[0];
    this.subreports = {};
    this.params = {};
    this.httpparams = {};
    this.configparams = {};
    rex_RebFile.prototype.sub = function (a) {
        if (this.subreports[a] == undefined) {
            this.subreports[a] = new rex_RebSubReport(a)
        }
        return this.subreports[a]
    };
    rex_RebFile.prototype.con = function (a) {
        if (this.subreports[a] == undefined) {
            this.subreports[a] = new rex_RebSubReport(a)
        }
        return this.subreports[a]
    };
    rex_RebFile.prototype.param = function (a) {
        if (this.params[a] == undefined) {
            this.params[a] = {}
        }
        return this.params[a]
    };
    rex_RebFile.prototype.httpparam = function (a) {
        if (this.httpparams[a] == undefined) {
            this.httpparams[a] = {}
        }
        return this.httpparams[a]
    };
    rex_RebFile.prototype.configparam = function (a) {
        if (this.configparams[a] == undefined) {
            this.configparams[a] = {}
        }
        return this.configparams[a]
    };
    rex_RebFile.prototype.toStringFile = function (a, b, c, d) {
        var e = "";
        if (a.length > 7) {
            if (a.substring(0, 7) != "http://" && a.substring(0, 8) != "https://") {
                a = rex_gsReportURL + a + ".reb"
            }
        } else {
            a = rex_gsReportURL + a + ".reb"
        }
        e += "<file type='reb' path='" + a + "'>";
        e += "<config-param-list>";
        if (rex_gsShowparameterdialog != undefined) {
            if (rex_gsShowparameterdialog == "1") {
                e += "<config-param name='showparameterdialog'>1</config-param>"
            }
        }
        if (document.cookie != "" && document.cookie != null) {
            e += "<config-param name='cookie'>" + document.cookie + "</config-param>"
        }
        e += "</config-param-list>";
        e += b;
        e += c;
        e += d;
        e += "</file>";
        return e
    };
    rex_RebFile.prototype.toStringField = function (a, b) {
        var c = "";
        if (b == "index") {
            c += "<field-list namebind='0'>"
        } else {
            c += "<field-list>"
        }
        for (var d in a) {
            var e = "";
            if (a[d].value != undefined) {
                e = a[d].value
            }
            if (a[d].isnull != undefined) {
                c += "<field name='" + d + "' isnull='1'><![CDATA[" + e + "]]></field>"
            } else {
                c += "<field name='" + d + "'><![CDATA[" + e + "]]></field>"
            }
        }
        c += "</field-list>";
        return c
    };
    rex_RebFile.prototype.toStringConfigParam = function (a) {
        var b = "";
        b += "<config-param-list>";
        for (var c in a) {
            b += "<config-param name='" + c + "'><![CDATA[" + a[c].value + "]]></config-param>"
        }
        b += "</config-param-list>";
        return b
    }
}
function rex_RebSubReport() {
    this.id = arguments[0];
    this.params = {};
    this.httpparams = {};
    this.datasets = {};
    rex_RebSubReport.prototype.param = function (a) {
        if (this.params[a] == undefined) {
            this.params[a] = {}
        }
        return this.params[a]
    };
    rex_RebSubReport.prototype.httpparam = function (a) {
        if (this.httpparams[a] == undefined) {
            this.httpparams[a] = {}
        }
        return this.httpparams[a]
    };
    rex_RebSubReport.prototype.dataset = function (a) {
        if (this.datasets[a] == undefined) {
            this.datasets[a] = {}
        }
        return this.datasets[a]
    }
}
function rex_RebConnection() {
    rex_RebConnection.prototype.toString = function (a, b, c) {
        var d = "";
        var e = a["type"];
        var f = a["namespace"];
        var g = a["path"];
        var h = false;
        var j = a["data"];
        var k = a["connectname"];
        var l = a["connectiononce"];
        var m = a["datatype"];
        var n = a["encoding"];
        var o = a["xpath"];
        var p = a["rptname"];
        if (e == undefined || e == "") e = "http";
        if (f == undefined || f == "") f = "*";
        if (g == undefined || g == "") {
            h = false;
            if (rex_gsServerVersion == "2.5") {
                g = rex_gsRptServiceURL_RexServer25
            } else {
                g = rex_gsRptServiceURL
            }
        } else {
            h = true
        }
        if (j == undefined) {
            j = ""
        }
        if (k == undefined || k == "") {
            if (rex_gsServerVersion == "2.5") {
                k = ""
            } else {
                k = rex_gsUserService
            }
        }
        if (m == undefined || m == "") m = "CSV";
        if (n == undefined || n == "") {
            if (rex_gsServerVersion == "2.5") {
                n = rex_gsCsvEncoding_RexServer25
            } else {
                n = rex_gsCsvEncoding
            }
        }
        if (o == undefined || o == "") {
            if (rex_gsServerVersion == "2.5") {
                if (e == "http") {
                    if (!h) o = rex_gsXPath_RexServer25
                } else {
                    //o = "{.xml.root%}"
                    o = "{%dataset.xml.root%}";     // 2014.10.27 수정 by KGW
                }
            } else {
                if (e == "http") {
                    if (!h) o = rex_gsXPath
                } else {
                    //o = "{.xml.root%}"
                    o = "{%dataset.xml.root%}";     // 2014.10.27 수정 by KGW
                }
            }
        }
        d += "<connection type='" + e + "' namespace='" + f + "'>";
        var q = "";
        if (b != undefined) {
            for (var r in b) {
                if (typeof (b[r].value) == "object") {
                    for (var i = 0; i < b[r].value.length; i++) {
                        q += "<http-param name='" + r + "'><![CDATA[" + b[r].value[i] + "]]></http-param>"
                    }
                } else {
                    q += "<http-param name='" + r + "'><![CDATA[" + b[r].value + "]]></http-param>"
                }
            }
        }
        if (e == "http") {
            if (h == false) {
                if (rex_gsServerVersion == "2.5") {
                    var s = q;
                    q = "";
                    q += "<http-param-list>";
                    q += s;
                    q += "<http-param name='designtype'>run</http-param>";
                    q += "<http-param name='datatype'>" + m.toUpperCase() + "</http-param>";
                    q += "<http-param name='sql'>{%auto%}</http-param>";
                    q += "<http-param name='split'></http-param>";
                    q += "<http-param name='userservice'>" + k + "</http-param>";
                    q += "<http-param name='image'></http-param>";
                    q += "<http-param name='rex_param_sql'></http-param>";
                    q += "<http-param name='presql'>{.ado.pre.sql%}</http-param>";
                    q += "<http-param name='postsql'>{.ado.post.sql%}</http-param>";
                    if (rex_gsPluginTypeWeb != undefined) {
                        q += "<http-param name='pSessionKey'>internal</http-param>"
                    }
                    q += "</http-param-list>"
                } else {
                    var s = q;
                    q = "";
                    q += "<http-param-list>";
                    q += s;
                    q += "<http-param name='Q1SQL'>{%auto%}</http-param>";
                    q += "<http-param name='OE'>None</http-param>";
                    q += "<http-param name='CN'>" + k + "</http-param>";
                    q += "<http-param name='ID'>SD" + m.toUpperCase() + "</http-param>";
                    q += "<http-param name='REBNM'>" + p + "</http-param>";
                    if (rex_gsPluginTypeWeb != undefined) {
                        if (rex_gsPluginTypeWeb == "crypto.clipsoft") {
                            q += "<http-param name='pSessionKey'>internal</http-param>"
                        }
                        q += "<http-param name='PE'>TRUE</http-param>"
                    } else {
                        q += "<http-param name='PE'>FALSE</http-param>"
                    }
                    q += "<http-param name='QC'>1</http-param>";
                    q += "<http-param name='OT'>DataOnly</http-param>";
                    q += "<http-param name='Q1Type'>SQL</http-param>";
                    q += "</http-param-list>"
                }
            } else {
                if (q != "") {
                    q = "<http-param-list>" + q + "</http-param-list>"
                }
            }
            d += "<config-param-list>";
            d += "<config-param name='path'>" + g + "</config-param>";
            if (l == "1") {
                d += "<config-param name='connection.once'>1</config-param>"
            }
            if (document.cookie != "" && document.cookie != null) {
                d += "<config-param name='cookie'><![CDATA[" + document.cookie + "]]></config-param>"
            }
            if (rex_gsHttpTimeout != undefined) {
                for (var t in rex_gsHttpTimeout) {
                    d += "	<config-param name='" + t + "'>" + rex_gsHttpTimeout[t] + "</config-param>"
                }
            }
            d += "</config-param-list>";
            d += q
        } else if (e == "file") {
            d += "<config-param-list>";
            d += "<config-param name='connection.once'>1</config-param>";
            d += "<config-param name='path'>" + g + "</config-param>";
            d += "</config-param-list>";
            if (q != "") {
                d += q
            }
        } else if (e == "memo") {
            d += "<config-param-list>";
            if (m.toUpperCase() == "CSV") {
                d += "<config-param name='data'><![CDATA[" + j + "]]></config-param>"
            } else {
                d += "<config-param name='data'>" + j + "</config-param>"
            }
            d += "</config-param-list>"
        }
        if (m.toUpperCase() == "CSV") {
            if (rex_gsServerVersion == "2.5") {
                d += "<content content-type='csv'>";
                if (e == "memo") {
                    d += "<content-param name='col-delim'>" + rex_gsCsvSeparatorColumn + "</content-param>";
                    d += "<content-param name='row-delim'>" + rex_gsCsvSeparatorRow + "</content-param>";
                    d += "<content-param name='dataset-delim'>" + rex_gsCsvSeparatorDataSet_RexServer25 + "</content-param>";
                    d += "<content-param name='dataset-index'>{.index%}</content-param>";
                    n = "utf16le"
                } else {
                    d += "<content-param name='col-delim'>" + rex_gsCsvSeparatorColumn_RexServer25 + "</content-param>";
                    d += "<content-param name='row-delim'>" + rex_gsCsvSeparatorRow_RexServer25 + "</content-param>";
                    d += "<content-param name='dataset-delim'>" + rex_gsCsvSeparatorDataSet_RexServer25 + "</content-param>"
                }
                d += "<content-param name='encoding'>" + n + "</content-param>";
                d += "</content>"
            } else {
                d += "<content content-type='csv'>";
                d += "<content-param name='col-delim'>" + rex_gsCsvSeparatorColumn + "</content-param>";
                d += "<content-param name='row-delim'>" + rex_gsCsvSeparatorRow + "</content-param>";
                d += "<content-param name='dataset-delim'>" + rex_gsCsvSeparatorDataSet + "</content-param>";
                if (e == "memo") {
                    n = "utf16le";
                    d += "<content-param name='dataset-index'>{.index%}</content-param>"
                }
                d += "<content-param name='encoding'>" + n + "</content-param>";
                d += "</content>"
            }
        } else {
            var u = "";
            if (c != undefined) {
                for (var r in c) {
                    u += "<content content-type='xml' namespace='" + r + "'>";
                    u += "<content-param name='root'>" + c[r].xpath + "</content-param>";
                    u += "<content-param name='preservedwhitespace'>1</content-param>";
                    u += "<content-param name='bindmode'>name</content-param>";
                    u += "</content>"
                }
            }
            if (u == "") {
                u += "<content content-type='xml'>";
                u += "<content-param name='root'>" + o + "</content-param>";
                u += "<content-param name='preservedwhitespace'>1</content-param>";
                u += "<content-param name='bindmode'>name</content-param>";
                u += "</content>"
            }
            d += u
        }
        d += "</connection>";
        if (e == "ado") {
            d = ""
        }
        return d
    }
}
rex_ParamSet.prototype.open = function () {
    this.opentype = "open";
    var a = arguments;

    switch (a.length) {
        case 1:
            this.win = window.open(rex_gsPreViewURL + "?id=" + this.id, a[0], rex_gsPreViewFeatures + ",width=825,height=600");
            break;
        case 2:
            this.win = window.open(rex_gsPreViewURL + "?id=" + this.id, "", rex_gsPreViewFeatures + ",width=" + a[0] + ",height=" + a[1]);
            break;
        case 3:
            this.win = window.open(rex_gsPreViewURL + "?id=" + this.id, a[0], rex_gsPreViewFeatures + ",width=" + a[1] + ",height=" + a[2]);
            break;
        default:
            this.win = window.open(rex_gsPreViewURL + "?id=" + this.id, "", rex_gsPreViewFeatures + ",width=825,height=600");
            break;
    }

    if (this.win == null || (this.win != null && (this.win.outerWidth == 0 || this.win.closed))) {
        alert("Pop-up blocker or pop-up blocker program is executing.\r\nPlease try again after you turn off the pop-up blocker.");
    }
};

rex_ParamSet.prototype.openself = function () {
    this.opentype = "open";

    document.location.href = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale;
};

rex_ParamSet.prototype.iframe = function (a) {
    this.opentype = "iframe";
    var b = new rex_Agent();
    if (b.isIE) {
        if (typeof (a) == "object") {
            document.getElementById(a.name).src = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale
        } else {
            document.getElementById(a).src = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale
        }
    } else {
        if (typeof (a) == "object") {
            document.getElementById(a.name).contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale
        } else {
            document.getElementById(a).contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale
        }
    }
};
rex_ParamSet.prototype.embed = function (a) {
    this.opentype = "embed";
    var b = new rex_Agent();
    var c;
    var d;
    d = document.getElementById(a);
    c = rex_goParamSet[this.id];
    if (b.isWin) {
        var e = c.printoption;
        var f = c.exportoption;
        var g = c.toolbarbuttonoption;
        if (e != null) {
            rex_fnPrintSetting(d, e)
        }
        if (f != null) {
            rex_fnExportVisible(d, f)
        }
        if (g != null) {
            rex_fnToolBarButtonEnableTrue(d, g)
        }
        try { } catch (ex) {
            return
        }
        if (c.event.init != undefined) {
            c.event.init(d, "init", null)
        }
        d.CloseAll();
        d.OpenOOF(c.toString())
    } else {
        document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id + "&rptMode=" + rptMode + "&rptLocale=" + rptLocale
    }
};
rex_ParamSet.prototype.openmodal = function () {
    this.opentype = "openmodal";
    window.showModalDialog(rex_gsPreViewURL + "?id=" + this.id, window, rex_gsPreViewFeaturesModal)
};
rex_ParamSet.prototype.print = function () {
    this.opentype = "print";
    if (arguments.length > 0) {
        this.print.dialog = arguments[0];
        this.print.startpage = arguments[1];
        this.print.endpage = arguments[2];
        this.print.copycount = arguments[3];
        this.print.Option = "";
        this.printoption = arguments[4]
    } else {
        this.print.dialog = this.printinfo.dialog;
        this.print.startpage = this.printinfo.startpage;
        this.print.endpage = this.printinfo.endpage;
        this.print.copycount = this.printinfo.copycount;
        this.print.Option = "";
        this.printoption = this.printinfo.Option
    }
    var a = new rex_Agent();
    if (a.isIE) {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        }
    } else {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        }
    }
};
rex_ParamSet.prototype.printall = function () {
    for (var i = 0; i < rex_gaReports.length; i++) {
        rex_gaReports[i].opentype = "print";
        if (arguments.length > 0) {
            rex_gaReports[i].printinfo = {};
            rex_gaReports[i].printinfo.dialog = arguments[0];
            rex_gaReports[i].printinfo.startpage = arguments[1];
            rex_gaReports[i].printinfo.endpage = arguments[2];
            rex_gaReports[i].printinfo.copycount = arguments[3];
            rex_gaReports[i].printinfo.Option = arguments[4]
        }
        if (this.event.beforeprintalleach != undefined) {
            rex_gaReports[i].event.beforeprintalleach = this.event.beforeprintalleach
        }
        if (this.event.init != undefined) {
            rex_gaReports[i].event.init = this.event.init
        }
        if (this.event.finishdocument != undefined) {
            rex_gaReports[i].event.finishdocument = this.event.finishdocument
        }
        if (this.event.finishprintalleach != undefined) {
            rex_gaReports[i].event.finishprintalleach = this.event.finishprintalleach
        }
        if (this.event.finishprintall != undefined) {
            rex_gaReports[i].event.finishprintall = this.event.finishprintall
        }
    }
    rex_PrintAllEvent("", "", "")
};
function rex_PrintAllEvent(a, b, c) {
    var d;
    if (rex_gaReportsIndex > 0) {
        d = rex_gaReports[rex_gaReportsIndex - 1];
        if (d.event.finishprintalleach != undefined) {
            d.event.finishprintalleach(a, "finishprintalleach", {
                "report": d
            })
        }
    }
    if (rex_gaReports.length > 0 && rex_gaReports.length > rex_gaReportsIndex) {
        d = rex_gaReports[rex_gaReportsIndex];
        if (d.event.beforeprintalleach != undefined) {
            var e = d.event.beforeprintalleach(a, "beforeprintalleach", {
                "report": d
            });
            if (e != null) {
                d = e
            }
        }
        d.event.finishprint = rex_PrintAllEvent;
        d.print();
        rex_gaReportsIndex++
    } else {
        d = rex_gaReports[rex_gaReportsIndex - 1];
        if (d.event.finishprintall != undefined) {
            d.event.finishprintall(a, "finishprintall", {
                "reports": rex_gaReports
            })
        }
        rex_gaReports = new Array();
        rex_gaReportsIndex = 0
    }
}
rex_ParamSet.prototype.printdirect = function () {
    this.opentype = "printdirect";
    if (arguments.length > 0) {
        this.print.printname = arguments[0];
        this.print.trayid = arguments[1];
        this.print.startpage = arguments[2];
        this.print.endpage = arguments[3];
        this.print.copycount = arguments[4];
        this.print.Option = "";
        this.printoption = arguments[5]
    } else {
        this.print.printname = this.printinfo.printname;
        this.print.trayid = this.printinfo.trayid;
        this.print.startpage = this.printinfo.startpage;
        this.print.endpage = this.printinfo.endpage;
        this.print.copycount = this.printinfo.copycount;
        this.print.Option = "";
        this.printoption = this.printinfo.Option
    }
    var a = new rex_Agent();
    if (a.isIE) {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b)
        } else {
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        }
    } else {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        }
    }
};
rex_ParamSet.prototype.printdirectall = function () {
    for (var i = 0; i < rex_gaReports.length; i++) {
        rex_gaReports[i].opentype = "printdirect";
        if (arguments.length > 0) {
            rex_gaReports[i].printinfo = {};
            rex_gaReports[i].printinfo.printname = arguments[0];
            rex_gaReports[i].printinfo.trayid = arguments[1];
            rex_gaReports[i].printinfo.startpage = arguments[2];
            rex_gaReports[i].printinfo.endpage = arguments[3];
            rex_gaReports[i].printinfo.copycount = arguments[4];
            rex_gaReports[i].printinfo.Option = arguments[5]
        }
        if (this.event.finishprintdirectalleach != undefined) {
            rex_gaReports[i].event.finishprintdirectalleach = this.event.finishprintdirectalleach
        }
        if (this.event.finishprintdirectall != undefined) {
            rex_gaReports[i].event.finishprintdirectall = this.event.finishprintdirectall
        }
    }
    rex_PrintDirectAllEvent("", "", "")
};
function rex_PrintDirectAllEvent(a, b, c) {
    var d;
    if (rex_gaReportsIndex > 0) {
        d = rex_gaReports[rex_gaReportsIndex - 1];
        if (d.event.finishprintdirectalleach != undefined) {
            d.event.finishprintdirectalleach(a, "finishprintdirectalleach", {
                "report": d
            })
        }
    }
    if (rex_gaReports.length > 0 && rex_gaReports.length > rex_gaReportsIndex) {
        d = rex_gaReports[rex_gaReportsIndex];
        d.event.finishprint = rex_PrintDirectAllEvent;
        d.printdirect();
        rex_gaReportsIndex++
    } else {
        d = rex_gaReports[rex_gaReportsIndex - 1];
        if (d.event.finishprintdirectall != undefined) {
            d.event.finishprintdirectall(a, "finishprintdirectall", {
                "reports": rex_gaReports
            })
        }
        rex_gaReports = new Array();
        rex_gaReportsIndex = 0
    }
}
rex_ParamSet.prototype.save = function () {
    this.opentype = "save";
    if (arguments.length > 0) {
        this.save = {};
        this.save.dialog = arguments[0];
        this.save.filetype = arguments[1];
        this.save.fileName = arguments[2];
        this.save.startpage = arguments[3];
        this.save.endpage = arguments[4];
        this.save.Option = arguments[5]
    } else {
        this.save = {};
        this.save.dialog = this.saveinfo.dialog;
        this.save.filetype = this.saveinfo.filetype;
        this.save.fileName = this.saveinfo.fileName;
        this.save.startpage = this.saveinfo.startpage;
        this.save.endpage = this.saveinfo.endpage;
        this.save.Option = this.saveinfo.Option
    }
    var a = new rex_Agent();
    if (a.isIE) {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        }
    } else {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        }
    }
};
rex_ParamSet.prototype.saveupload = function () {
    this.opentype = "saveupload";
    if (arguments.length > 0) {
        this.saveupload = {};
        this.saveupload.dialog = arguments[0];
        this.saveupload.filetype = arguments[1];
        this.saveupload.fileName = arguments[2];
        this.saveupload.startpage = arguments[3];
        this.saveupload.endpage = arguments[4];
        this.saveupload.Option = arguments[5];
        this.saveupload.uploadurl = arguments[6]
    } else {
        this.saveupload = {};
        this.saveupload.dialog = this.saveinfo.dialog;
        this.saveupload.filetype = this.saveinfo.filetype;
        this.saveupload.fileName = this.saveinfo.fileName;
        this.saveupload.startpage = this.saveinfo.startpage;
        this.saveupload.endpage = this.saveinfo.endpage;
        this.saveupload.Option = this.saveinfo.Option;
        this.saveupload.uploadurl = this.saveinfo.uploadurl
    }
    var a = new rex_Agent();
    if (a.isIE) {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        }
    } else {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b);
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        } else {
            document.getElementById("rex_ifrmRexPreview").contentWindow.location.href = rex_gsPreViewURL + "?id=" + this.id
        }
    }
};
rex_ParamSet.prototype.saveall = function () {
    for (var i = 0; i < rex_gaReports.length; i++) {
        rex_gaReports[i].opentype = "save";
        if (arguments.length > 0) {
            rex_gaReports[i].saveinfo = {};
            rex_gaReports[i].saveinfo.dialog = arguments[0];
            rex_gaReports[i].saveinfo.filetype = arguments[1];
            rex_gaReports[i].saveinfo.fileName = arguments[2];
            rex_gaReports[i].saveinfo.startpage = arguments[3];
            rex_gaReports[i].saveinfo.endpage = arguments[4];
            rex_gaReports[i].saveinfo.Option = arguments[5]
        }
    }
    rex_SaveAllEvent("", "", "")
};
function rex_SaveAllEvent(a, b, c) {
    var d;
    if (rex_gaReportsIndex > 0) { }
    if (rex_gaReports.length > 0 && rex_gaReports.length > rex_gaReportsIndex) {
        d = rex_gaReports[rex_gaReportsIndex];
        d.event.finishexport = rex_SaveAllEvent;
        d.save();
        rex_gaReportsIndex++
    } else {
        rex_gaReports = new Array();
        rex_gaReportsIndex = 0
    }
}
rex_ParamSet.prototype.exportserver = function () {
    this.opentype = "export";
    if (arguments.length > 0) {
        this.exportservice = {};
        this.exportservice.filename = arguments[0];
        this.exportservice.filetype = arguments[1];
        this.exportservice.afterjob = arguments[2]
    }
    var a = new rex_Agent();
    if (a.isIE) {
        if (document.getElementById("rex_ifrmRexPreview") == null) {
            var b = "<iframe id='rex_ifrmRexPreview' src='" + rex_gsPreViewURL + "?id=" + this.id + "' width='0' height='0' frameborder='0'></iframe>";
            document.body.insertAdjacentHTML("beforeEnd", b)
        } else {
            document.getElementById("rex_ifrmRexPreview").src = rex_gsPreViewURL + "?id=" + this.id
        }
    } else {
        window.open(rex_gsPreViewURL + "?id=" + this.id, "", "center=yes,scrollbars=no,status=no,toolbar=no,resizable=0,location=no,menu=no, left=1000, top=1000, width=10,height=10")
    }
};
function rex_fnPrintSetting(a, b) {
    var c = b.split(";");
    for (var i = 0; i < c.length; i++) {
        a.SetCSS("print." + c[i])
    }
    a.UpdateCSS()
}
function rex_fnExportVisible(a, b) {
    var c = b.split(";");
    var d = [];
    for (var i = 0; i < c.length; i++) {
        d[i] = c[i]
    }
    for (var i = 0; i < d.length; i++) {
        var e = d[i].split("=");
        a.SetCSS("export.appearance." + e[0] + ".visible=" + e[1])
    }
    a.UpdateCSS()
}
function rex_fnToolBarButtonEnableTrue(a, b) {
    var c = b.split(";");
    var d = [];
    for (var i = 0; i < c.length; i++) {
        d[i] = c[i]
    }
    for (var i = 0; i < d.length; i++) {
        var e = d[i].split("=");
        a.SetCSS("appearance.toolbar.button." + e[0] + ".visible=" + e[1])
    }
    a.UpdateCSS()
}
function rex_gfGetAjaxRequest() {
    try {
        obj = new XMLHttpRequest()
    } catch (trymicrosoft) {
        try {
            obj = new ActiveXObject("Msxml2.XMLHTTP")
        } catch (othermicrosoft) {
            try {
                obj = new ActiveXObject("Microsoft.XMLHTTP")
            } catch (failed) {
                obj = null
            }
        }
    }
    return obj
}
function rex_GetgoAjax() {
    return new rex_goAjax()
}
function rex_goAjax() {
    this.Ajax = rex_gfGetAjaxRequest();
    this.SetRequestHeader = rex_goAjax_SetRequestHeader;
    this.AddParameter = rex_goAjax_AddParameter;
    this.Open = rex_goAjax_Open;
    this.Send = rex_goAjax_Send;
    this.Ajax.onreadystatechange = rex_goAjax_onreadystatechange;
    this.Path = "";
    this.Parameter = "";
    this.Response = rex_goAjax_Response;
    this.Method = "POST";
    this.isASync = false;
    this.DataType = "XML";
    this.isShowWait = false
}
function rex_goAjax_Open() {
    this.Ajax.open(this.Method, this.Path, this.isASync)
}
function rex_goAjax_SetRequestHeader(a, b) {
    this.Ajax.setRequestHeader(a, b)
}
function rex_goAjax_AddParameter(a, b) {
    if (this.Parameter != "") this.Parameter += "&";
    b = b.replace(/%/g, "%");
    b = b.replace(/\+/g, "+");
    b = b.replace(/=/g, "=");
    b = b.replace(/&/g, "&");
    this.Parameter += a + "=" + b
}
function rex_goAjax_Send(a) {
    if (arguments.length != 0) {
        this.Parameter = arguments[0]
    }
    if (this.isASync == false) {
        if (this.Method == "POST") {
            this.Ajax.send(this.Parameter)
        } else {
            this.Ajax.send("")
        }
        return
    } else {
        window.showModalDialog("RexProgress.jsp", this, "center:yes;resizable:no;scroll:no;status:no;dialogWidth:400px;dialogHeight:300px")
    }
}
function rex_goAjax_onreadystatechange() { }
function rex_goAjax_Response() {
    if (this.Ajax.readyState == 4) {
        if (this.Ajax.status == 200) {
            if (this.DataType == "XML") {
                return this.Ajax.responseXML
            } else if (this.DataType == "CSV") {
                return this.Ajax.responseText
            } else {
                return this.Ajax.responseText
            }
        } else {
            return ""
        }
    }
}
function rex_gfAjaxExcute(a, b, c, d, e, f) {
    var g = rex_GetgoAjax();
    g.Method = a;
    g.isASync = b;
    g.Path = c;
    g.DataType = e;
    g.Open();
    if (f != "") {
        g.SetRequestHeader("Content-Type", f)
    } else {
        g.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=EUC-KR")
    }
    if (a == "POST") {
        if (d != "") {
            g.Send(d)
        } else {
            g.Send()
        }
    } else {
        g.Send()
    }
    return g
}
function fnVBEventHandler(a, b, c) {
    fnReportEvent(a, b, c)
}
function fnRexScriptVersion() {
    return rexScript_version
}
function getParameter(a) {
    var b = window.location.search.substring(1);
    var c = b.split("&");
    for (var i = 0; i < c.length; i++) {
        var d = c[i].split("=");
        if (d[0] == a) {
            return d[1]
        }
    }
    return null
}
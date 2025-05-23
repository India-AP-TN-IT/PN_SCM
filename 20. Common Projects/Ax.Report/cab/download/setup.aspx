﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="setup.aspx.cs" Inherits="setup" validateRequest="false" %>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="ko" />
		<meta name="description" content="Download Rexpert Viewer, the cross-platform browser plug-in" />
		<title>REXPERT VIEWER</title> 
<!--master.com.adobe.cfm -->
<!-- com.adobe.ssi,v 1.12 2008/07/29 06:49:04 kahamed Exp -->
<link type="text/css" rel="stylesheet" href="screen.css?v=20141226080000" media="screen" charset="utf-8" />
<script type="text/javascript">
	function fnOnLoad() {
		var sParam = window.location.search;
		sParam = sParam.substr(1);
		var aParam = sParam.split("=");

//		idVersion.innerHTML = aParam[1];
		document.getElementById("idVersion").innerHTML = aParam[1];

		//location.href="../rexpert30viewer.exe";
//		buttonDownload.href="../getviewer.jsp?f=rexpert30viewer.exe";
	}
</script>
</head>
<body onload="fnOnLoad()" style="margin:0 0 0 0;width:100%;height:100%">
<!--googleon: index-->
<div id="layoutLogic" class="L0">
		<div id="L0C1" class="pod p0 columns-1-A-A">
			<div id="L0C1-body" class="pod-body"> 
		<h1 id="pageHeader" style="background:#0554a1;">REXPERT Viewer</h1>
    <form name="downloadForm" id="downloadForm" method="get">
    	<div id="JSError" style="display:none;"></div>
    	<div class="pullout-left left-125">
			<p class="pullout-item"><img src="REXPERT_BI_01.jpg" width="183" height="71" alt="REXPERT Viewer" /></p>
			<h2>REXPERT Viewer Install</h2>
			<div class="pullout-right right-wrap" >
				<p>
					<strong>REXPERT Viewer Ver: <span id="idVersion" name="idVersion">1.0.0.48</span></strong>
				</p>
			</div>
			<p class="note">
				<br />
			</p>
			<div class="pullout-right right-wrap">
				<p class="pullout-item"><strong><br />
					<span id="totalfilesize"></span></strong>
				</p>
				<div class="columns-2-Abb-A">
					<p><a class="download-button" id="buttonDownload" href="../rexpert30viewer.exe">Install</a></p>
					<p>
						<strong>To apply you must rerun the web browser.</strong>
					</p>
				</div>
			</div>
		</div>
		<input type="hidden" name="installer" id="installer" value="Flash_Player_10_for_Windows_Internet_Explorer" />

	</form>

<br class="clear-both" />
</div>
		</div>
	
	<br class="clear-both" />
</div>
 <!--googleoff: index-->
<div id="globalfooter" style="background:#0554a1;">
  <p id="copyright">COPYRIGHT(C) 2005 CLIPSOFT. <a href="http://www.clipsoft.co.kr" target="_new">ALL RIGHT RESERVED.</a>.</p>
</div>
</body>
</html>
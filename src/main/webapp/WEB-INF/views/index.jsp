<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link href="<%=request.getContextPath() %>/static/css/bootstrap.css" type="text/css" rel="stylesheet" />
	<!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	<title>Cassandra lan party</title>
</head>
<body onload="loaded();">
	<div class="container">
		<div class="hero-unit" style="padding: 25px">
			<h1>Cassandra Lan Party</h1>
			<p>Join the #devoxxfr party !</p>
			<p>
				<a class="btn btn-primary btn-large" href="<%=request.getContextPath() %>/clp/configuration"><i class="icon-arrow-right icon-white"></i> Setup your machine and join the party !</a>
			</p>
		</div>

		<div class="page-header">
			<h1>Cassandra Ring <small>Live !</small> <button class="btn btn-primary btn-small" id="autoRefresh"><i class="icon-stop icon-white"></i> Disable Auto-refresh</button></h1>
		</div>
		<table class="table table-striped table-condensed">
			<thead>
				<tr>
					<th>Ip Address</th>
					<th>Data Center</th>
					<th>Rack</th>
					<th>Status</th>
					<th>State</th>
					<th>Load</th>
					<th>Owns</th>
					<th>Token</th>
				</tr>
			</thead>
			<tbody id="ring-table-body">
				<tr>
					<td>ip</td>
					<td>dc</td>
					<td>rack</td>
					<td>status</td>
					<td>state</td>
					<td>load</td>
					<td>owns</td>
					<td>token</td>
				</tr>
			</tbody>
		</table>
	</div>
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.min.js" language="javascript" type="text/javascript"></script>
	<script src="https://raw.github.com/jquery/jquery-tmpl/master/jquery.tmpl.js" language="javascript" type="text/javascript"></script>
	<script>
	var contextPath = "<%=request.getContextPath() %>";
	var autoRefresh = true;
	var debug = false;

	// called when dom is ready
	function loaded() {
		setupAutoRefresh();
		setupLiveUpdates();
	}

	function setupAutoRefresh() {
		$("#autoRefresh").click(function() {
			autoRefresh = !autoRefresh;
			$("#autoRefresh").html(autoRefresh 
								? "<i class='icon-stop icon-white'></i> Disable auto-refresh" 
								: "<i class='icon-play icon-white'></i> Enable auto-refresh");
		});
	}

	function setupLiveUpdates() {
		liveUpdate();
		// call live update every 4 seconds if auto refresh is enabled
		setInterval(function() {
			if (autoRefresh) { 
				liveUpdate();
			}
		}, 4000);
	}

	function liveUpdate() {
		$.getJSON(contextPath + "/clp/rest/ring", 
				{
					debug : debug
				}
				, function(json) { 
					displayRingTable(json);
				}
			)
			.error(function() {
				$("#ring-table-body").html("An error occured while retrieving ring data");
			}
		);
	}

	function statusColor(status) {
		if (status == "down") {
			return "btn-danger";
		} else if (status == "up") {
			return "btn-success";
		} else {
			return "";
		}
	}

	function displayRingTable(json) {
		$("#ring-table-body").html("");
		$.each(json, function(node, node) {
			$("#ring-table-body").html(
				  $("#ring-table-body").html() 
				+ "<tr>"
				+ "<td>" + node.ip + "</td>" 
				+ "<td>" + node.dc + "</td>" 
				+ "<td>" + node.rack + "</td>" 
				+ "<td><button class='btn btn-small " + statusColor(node.status) + "' style='width:100%'></button></td>" 
				+ "<td>" + node.state + "</td>" 
				+ "<td>" + node.load + "</td>" 
				+ "<td>" + node.owns + "</td>" 
				+ "<td style=\"width: 350px\"><code>" + node.token + "</code>" + (node.ip == "${yourIp}" ? '&larr; <span class="label label-success">you</span>' : "") + "</td>" 
				+ "</tr>"
			);
		});
	}
	</script>
</body>
</html>
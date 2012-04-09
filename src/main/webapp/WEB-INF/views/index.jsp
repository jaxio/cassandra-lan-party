<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link href="<%=request.getContextPath() %>/static/css/bootstrap.css" type="text/css" rel="stylesheet" />
	<link href="<%=request.getContextPath() %>/static/css/treemap.css" type="text/css" rel="stylesheet" />
	<!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	<title>Cassandra lan party</title>
</head>
<body onload="loaded();">
	<div class="container">
		<div class="page-header">
			<h1>Cassandra Lan Party</h1>
			<h3>Devoxx fr 2012</h3>
			<a class="btn btn-primary btn-warning" href="<%=request.getContextPath() %>/clp/configuration"><i class="icon-arrow-right icon-white"></i> Go to party setup</a>
		</p>
		<div class="page-header">
			<h1>Cluster visualization <small>Live !</small></h1>
		</div>
		<div class="btn-toolbar">
			<div class="btn-group">
				<button class="btn btn-info dropdown-toggle" data-toggle="dropdown"><li class="icon-eye-open icon-white"></li> Change visualization <span class="caret"></span></button>
				<ul class="dropdown-menu">
					<li><a id="r-sq">Square</a></li>
					<li><a id="r-st">Strip</a></li>
					<li><a id="r-sd">Slide and Dice</a></li>
				</ul>
			</div>
			<div class="btn-group">
				<button class="btn btn-primary" id="autoRefresh"><i class="icon-stop icon-white"></i> Disable Auto-refresh</button>
			</div>
			<div class="btn-group">
				<button class="btn btn-primary" data-toggle="modal" href="#cassandraClient"><i class="icon-edit icon-white"></i> Setup Cassandra client</button>
			</div>
		</div>
		<div id="infovis-container">
			<div id="infovis"></div>
		</div>

		<div class="page-header">
			<h1>Cassandra Ring <small>Live !</small></h1>
		</div>
		<table class="table table-striped table-bordered table-condensed">
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
	<!-- node host modal dialog -->
	<div class="modal hide fade" id="cassandraClient">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Cassandra client configuration</h3>
		</div>
		<div class="modal-body">
			<label>Node host</label>
			<input type="text" id="probeHost" class="input-small" placeholder="127.0.0.1" value="127.0.0.1">
			<span class="help-inline">This ip should have a running cassandra instance</span>
			<label>Keyspace</label>
			<input type="text" id="keyspace" class="input-small" placeholder="ks" value="ks">
			<span class="help-inline">Keyspace of your application</span>
			<div id="probeInvalid" class="alert alert-block alert-error hide fade in">
				<a class="close" data-dismiss="alert" href="#">×</a>
				<h4 class="alert-heading">Oh snap! You got an error!</h4>
				<p>Make sure the ip is valid</p>
			</div>
			<div id="probeInvalid" class="alert alert-error hide">
				<a class="close" data-dismiss="alert" href="#">×</a>
				<h3 class="alert-heading">Oh snap! You got an error!</h3>
				<p>Make sure the ip is valid</p>
			</div>
			<div id="probeChanged" class="alert alert-success hide">
				<a class="close" data-dismiss="alert" href="#">×</a>
				<h3 class="alert-heading">Success</h3>
				<p>You changed successfully the node host</p>
			</div>
		</div>
		<div class="modal-footer">
			<a href="#" data-dismiss="modal" class="btn">Close</a>
			<a id="checkProbe" class="btn btn-primary">Check</a>
		</div>
	</div>
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.js" language="javascript" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/jit.js" language="javascript" type="text/javascript"></script>
	<!--[if IE]><script src="<%=request.getContextPath() %>/static/js/excanvas.js" language="javascript" type="text/javascript" ></script><![endif]-->
	<script src="<%=request.getContextPath() %>/static/js/treemap.js" language="javascript" type="text/javascript"></script>
	<script>
	var contextPath = "<%=request.getContextPath() %>";
	var autoRefresh = true;
	var debug = false;

	// called when dom is ready
	function loaded() {
		setupAutoRefresh();
		setupProbeChecker();
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

	function setupProbeChecker() {
		$("#checkProbe").click(function() {
			$.getJSON(contextPath + "/clp/rest/checkProbe",
				{
					probeHost : $("#probeHost").val(), 
					keyspace : $("#keyspace").val() 
				})
				.success(function() {
					$("#probeChanged").show();
				})
				.error(function() {
					$("#probeHost").val("127.0.0.1"); 
					$("#probeInvalid").show();
				});
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
		$.getJSON(contextPath + "/clp/rest/treemap",
				{
					probeHost : $("#probeHost").val(), 
					keyspace : $("#keyspace").val(), 
					debug : debug
				}
				, function(json) { 
					displayTreeMap(json);
				}
			)
			.error(function() {
				$("#infovis").html("An error occured while retrieving ring data");
			}
		);
		$.getJSON(contextPath + "/clp/rest/ring", 
				{
					probeHost : $("#probeHost").val(), 
					keyspace : $("#keyspace").val(), 
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

	function displayRingTable(json) {
		$("#ring-table-body").html("");
		$.each(json, function(node, node) {
			$("#ring-table-body").html(
				$("#ring-table-body").html() 
					+ "<tr>"
					+ "<td>" + node.ip + "</td>" 
					+ "<td>" + node.dc + "</td>" 
					+ "<td>" + node.rack + "</td>" 
					+ "<td>" + node.status + "</td>" 
					+ "<td>" + node.state + "</td>" 
					+ "<td>" + node.load + "</td>" 
					+ "<td>" + node.owns + "</td>" 
					+ "<td style=\"width: 350px; text-align: center;\"><code>" + node.token + "</code></td>" 
					+ "</tr>"
			);
		});
	}
	</script>
</body>
</html>
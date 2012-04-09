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
</head>
<body onload="loaded();">
	<div class="container">
		<div class="page-header">
			<h1>Cassandra Lan Party</h1>
			<h3>Devoxx fr 2012</h3>
			<p>
				${nbDataCenter} Data Center, ${nbRackPerDataCenter} Racks per Data Center, ${nbParticipantPerRack} Participants per rack.<br/>
				Current Ip : ${currentIp}
			</p>
			<p>
			  	<button class="btn btn-primary btn-warning" data-toggle="modal" href="#partySetup">Party setup</button>
				<a class="btn btn-primary" href="#cluster">Live visualization</a>
			  	<button class="btn btn-primary" data-toggle="modal" href="#nodeHost">Change node host</button>
			</p>
		</div>
		<c:forEach items="${dataCenters}" var="dataCenter">
			<div class="page-header">
				<h1><spring:eval expression="dataCenter.name" /> <small>data center</small></h1>
			</div>
			<table class="table table-striped table-bordered table-condensed">
				 <thead>
				 	<tr>
						<th>Ip</th>
						<th>Rack</th>
						<th>Index</th>
						<th>Token</th>
					</tr>
				 </thead>
				 <tbody>
					<c:forEach items="${dataCenter.participants}" var="participant">
						<tr>
							<td><spring:eval expression="participant.ip" /></td>
							<td><spring:eval expression="participant.rack" /></td>
							<td><spring:eval expression="participant.nodeIndexInDataCenter" /></td>
							<td>
								<code><spring:eval expression="participant.token" /></code>
								<c:if test="${participant.ip eq currentIp}">&larr; <span class="label label-success">yours</span></c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:forEach>
		
		<div class="page-header">
			<h1>Cassandra Ring <small>live!</small></h1>
		</div>
		<table class="table table-striped table-bordered table-condensed">
			<thead>
				<tr>
		      		<th>ip</th>
		      		<th>dc</th>
		      		<th>rack</th>
		      		<th>status</th>
		      		<th>state</th>
		      		<th>load</th>
		      		<th>owns</th>
		      		<th>token</th>
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
		<a name="cluster"></a>
		<div class="page-header">
			<h1>Cluster visualization <small>live!</small></h1>
		</div>
		<div class="btn-toolbar">
			<div class="btn-group">
				<button id="autoRefresh" class="btn btn-primary" data-toggle="button" >Auto-refresh</button>
			</div>
			<div class="btn-group">
          		<button class="btn btn-info dropdown-toggle" data-toggle="dropdown">Visualization <span class="caret"></span></button>
				<ul class="dropdown-menu">
			  		<li><a id="r-back">Back</a></li>
	            	<li><a id="r-sq">Square</a></li>
	            	<li><a id="r-st">Strip</a></li>
	            	<li><a id="r-sd">Slide and Dice</a></li>
          		</ul>
        	</div>			
		</div>
		<div id="infovis-container">
			<div id="infovis"></div>
		</div>
	</div>
	<!-- node host modal dialog -->
	<div class="modal hide fade" id="nodeHost">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Change node host</h3>
		</div>
		<div class="modal-body">
			<label>Node host</label>
  			<input type="text" id="probeHost" class="span3" placeholder="localhost" value="localhost">
  			<span class="help-inline">This ip should have a running cassandra instance</span>
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
			<a id="checkProbe" class="btn btn-primary">Update</a>
		</div>
	</div>		
	<!-- party setup modal dialog -->
	<div class="modal hide fade" id="partySetup">
		<form action="<%=request.getContextPath() %>/clp/index">
			<div class="modal-header">
				<a class="close" data-dismiss="modal">×</a>
				<h3>Party setup</h3>
			</div>
			<div class="modal-body">
				<fieldset>
		    		<div class="control-group">
						<label class="control-label" for="nbDataCenter">Number of data centers</label>
		  				<div class="controls">
		    				<input type="text" class="input" id="nbDataCenter" name="nbDataCenter" placeholder="3" value="3">
		  				</div>
		     		</div>
				    <div class="control-group">
		      			<label class="control-label" for="nbRackPerDataCenter">Number of rack <strong>per</strong> data center</label>
		      			<div class="controls">
		        			<input type="text" class="input" id="nbRackPerDataCenter" name="nbRackPerDataCenter" placeholder="2" value="2">
		      			</div>
		      		</div>
		    		<div class="control-group">
		      			<label class="control-label" for="nbParticipantPerRack">Number of participant <strong>per</strong> rack</label>
		      			<div class="controls">
		        			<input type="text" class="input" id="nbParticipantPerRack" name="nbParticipantPerRack" placeholder="4" value="4">
		      			</div>
		      		</div>
		  		</fieldset>
			</div>
			<div class="modal-footer">
				<a href="#" data-dismiss="modal" class="btn">Close</a>
				<button type="subtmi" id="updateProbe" class="btn btn-primary">Check</button>
			</div>
		</form>
	</div>
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.js" language="javascript" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/jit.js" language="javascript" type="text/javascript"></script>
	<!--[if IE]><script src="<%=request.getContextPath() %>/static/js/excanvas.js" language="javascript" type="text/javascript" ></script><![endif]-->
	<script src="<%=request.getContextPath() %>/static/js/treemap.js" language="javascript" type="text/javascript"></script>
</body>
<script>
	
	// called when dom is complete
	function loaded() {
		setupAutoRefresh();
		setupLiveUpdates();
		setupProbeChecker();
	}
	
	function setupLiveUpdates() {
		liveUpdate();
		// call live update every 3 seconds
		setInterval(function() {
			if (autoRefresh) { liveUpdate();}
		}, 3000);
	}
	
	function setupAutoRefresh() {
		$("#autoRefresh").click(function() {
			autoRefresh = !autoRefresh;
		});
	}
	
	function setupProbeChecker() {
		$("#checkProbe").click(function() {
			var url = "<%=request.getContextPath() %>/clp/rest/checkProbe?probeHost=" + $("#probeHost").val(); 
			$.getJSON(url)
				.success(function(data) {$("#probeChanged").show();})
				.error(function() {$("#probeInvalid").show();});
		});
	}
	
	function displayRingTable(json) {
  			$("#ring-table-body").empty();
			$.each(json, function(node, node) {
				$("#ring-table-body").append(
				+ "<tr>"
				+ "<td>" + node.ip + "</td>" 
				+ "<td>" + node.dc + "</td>" 
				+ "<td>" + node.rack + "</td>" 
				+ "<td>" + node.status + "</td>" 
				+ "<td>" + node.state + "</td>" 
				+ "<td>" + node.load + "</td>" 
				+ "<td>" + node.owns + "</td>" 
				+ "<td><code>" + node.token + "</code></td>" 
				+ "</tr>");
			});
	}
	
	function liveUpdate() {
		$.getJSON("<%=request.getContextPath() %>/clp/rest/treemap?probeHost=" + $("#probeHost").val(), function(json) { displayTreeMap(json);})
			.error(function() {$("#infovis").html("An error occured while retrieving ring data");});
		$.getJSON("<%=request.getContextPath() %>/clp/rest/ring?probeHost=" + $("#probeHost").val(), "", function(json) { displayRingTable(json);})
			.error(function() {$("#ring-table-body").html("An error occured while retrieving ring data");});
	}
</script>
</html>
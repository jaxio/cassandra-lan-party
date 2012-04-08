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
				${nbDataCenter} Data Center, ${nbRackPerDataCenter} Racks per Data Center, ${nbParticipantPerRack} Participants per rack </span>
			</p>
			<p><a class="btn btn-primary btn-large" href="#cluster">Live visualization</a></p>
		</div>
		<c:forEach items="${dataCenters}" var="dataCenter">
			<div class="page-header">
				<h1><spring:eval expression="dataCenter.name" /> <small>data center</small></h1>
			</div>
			<table class="table table-striped table-bordered table-condensed">
				 <thead>
				 	<tr>
						<th>Io</th>
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
							<td><code><spring:eval expression="participant.token" /></code><c:if test="${participant.currentUser}"><span class="label label-success">yours</span></c:if></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:forEach>
		
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
			<div class="btn-group">
			  	<button class="btn btn-warning" data-toggle="modal" href="#nodeHost">Change node host</button>
			</div>
		</div>
		<div id="treemap">
			<div id="infovis"></div>
		</div>
	</div>
	<div class="modal hide fade" id="nodeHost">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>Change node host</h3>
		</div>
		<div class="modal-body">
			<label>Node host</label>
  			<input type="text" id="probeHost" class="span3" placeholder="localhost">
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
			<a id="updateProbe" class="btn btn-primary">Update</a>
		</div>
	</div>			
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.js" language="javascript" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/jit.js" language="javascript" type="text/javascript"></script>
	<!--[if IE]><script src="<%=request.getContextPath() %>/static/js/excanvas.js" language="javascript" type="text/javascript" ></script><![endif]-->
	<script src="<%=request.getContextPath() %>/static/js/treemap.js" language="javascript" type="text/javascript"></script>
</body>
<script>
	function loaded() {
		refreshTreeMap();
		$("#autoRefresh").click(function() {
			autoRefresh = !autoRefresh;
		});
		setInterval(function() {if (autoRefresh) { refreshTreeMap();}}, 3000);
		$("#updateProbe").click(function() {
			var url = "<%=request.getContextPath() %>/clp/rest/updateProbe?probeHost=" + $("#probeHost").val(); 
			$.getJSON(url)
				.success(function(data) {$("#probeChanged").show();})
				.error(function() {$("#probeInvalid").show();});
		});
	}
	function refreshTreeMap() {
		$.getJSON("<%=request.getContextPath() %>/clp/rest/ring","", function(json) { displayTreeMap(json);});
		//displayTreeMap({"children":[{"id":"fb1bf9ef-150a-4d73-8f46-48df017a7b25","name":"datacenter1","data":{"$color":"#3A87AD","$area":1,"nbRacks":1},"children":[{"id":"2de843ee-8be0-478e-90e3-b70751f6bf39","name":"rack1","data":{"$area":1,"$color":"#D9EDF7","nbMachines":3},"children":[{"name":"127.0.0.1","id":"f2479620-7fc4-4d56-9cde-9175151b5b0c","data":{"ip":"127.0.0.1","dc":"datacenter1","rack":"rack1","status":"up","state":"normal","load":"122,72 KB","owns":"8,33%","token":"127605887595351923798765477786913079296","$area":8,"$color":"#5BB75B"}},{"name":"127.0.0.3","id":"01c5cc53-a7ec-4153-9f66-8d498258a162","data":{"ip":"127.0.0.3","dc":"datacenter1","rack":"rack1","status":"up","state":"normal","load":"135,59 KB","owns":"33,33%","token":"113427455640312814857969558651062452225","$area":33,"$color":"#5BB75B"}},{"name":"127.0.0.2","id":"0e597787-b4c7-4b74-b28a-49e62c65ef88","data":{"ip":"127.0.0.2","dc":"datacenter1","rack":"rack1","status":"down","state":"normal","load":"135,56 KB","owns":"58,33%","token":"56713727820156407428984779325531226112","$area":58,"$color":"#DA4F49"}}]}]}],"id":"7d467d99-5e18-4875-9a3c-39d7ae9fb347","name":"Cluster Sat Apr 07 00:25:02 CEST 2012","data":{"$area":1,"$color":"#2d6987"}});
	}
</script>
</html>
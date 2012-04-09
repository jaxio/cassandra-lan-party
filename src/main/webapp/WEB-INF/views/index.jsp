<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<link href="<%=request.getContextPath() %>/res/css/bootstrap.min.css" type="text/css" rel="stylesheet">
	<link href="<%=request.getContextPath() %>/static/treemap.css" type="text/css" rel="stylesheet" />
	<script src="<%=request.getContextPath() %>/static/jquery-1.7-min.js" type="text/javascript"></script>
	<!--[if IE]><script src="<%=request.getContextPath() %>/static/excanvas.js" language="javascript" type="text/javascript" ></script><![endif]-->
	<script src="<%=request.getContextPath() %>/static/jit.js" language="javascript" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/treemap.js" language="javascript" type="text/javascript"></script>
</head>
<body onload="initTreeMap()">
	<div class="container">
		<h1>Cassandra Lan Party - DEVOXX FR 2012</h1>
		Configuration for : </br></br>
		<span class="badge badge-info">${nbDataCenter} Data Center </span></br></br>
		<span class="badge badge-info">${nbRackPerDataCenter} Racks per Data Center</span></br></br> 
		<span class="badge badge-info">${nbParticipantPerRack} Participants per rack </span></br></br>
		<a href="#cluster"><span class="badge badge-info">See Cluster live visualization</span></a></br></br>
	
		<c:forEach items="${dataCenters}" var="dataCenter">
			<div class="alert alert-info">Data Center : <strong><spring:eval expression="dataCenter.name" /></strong></div>
			<table class="table table-striped table-bordered table-condensed">
				 <thead>
				 	<tr>
						<th>IP</th>
						<th>DC</th>
						<th>RACK</th>
						<td>index</td>
						<th>TOKEN (copy-paste yours)</th>
					</tr>
				 </thead>
				 <tbody>
					<c:forEach items="${dataCenter.participants}" var="participant">
						<tr>
							<td><spring:eval expression="participant.ip" /></td>
							<td><spring:eval expression="dataCenter.name" /></td>
							<td><spring:eval expression="participant.rack" /></td>
							<td style="text-align: right"><spring:eval expression="participant.nodeIndexInDataCenter" /></td>
							<td style="width: 400px; text-align: right">
								<c:if test="${participant.currentUser}">
									<strong>
								</c:if>
		
								<spring:eval expression="participant.token" />
								
								<c:if test="${participant.currentUser}">
									</strong>
									<span class="label label-success">Your token!</span>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:forEach>
		
		<a name="cluster"></a>
		<div class="alert alert-info">Cluster live visualization</div>
		<div class="btn-toolbar">
			<div class="btn-group">
			  	<button class="btn" onclick="initTreeMap()">Refresh</button>
			</div>
			<div class="btn-group">
			  	<button class="btn" id="r-back">Back</button>
			</div>
			<div class="btn-group">
			  <button class="btn" id="r-sq">Square</button>
			  <button class="btn" id="r-st">Strip</button>
			  <button class="btn" id="r-sd">Slide and Dice</button>
			</div>
		</div>
		<div id="treemap">
			<div id="infovis"></div>
		</div>
	</div>
</body>
<script>
	function initTreeMap() {
		$.getJSON("<%=request.getContextPath() %>/clp/rest/ring","", function(json) { displayTreeMap(json);});
		//displayTreeMap({"children":[{"id":"fb1bf9ef-150a-4d73-8f46-48df017a7b25","name":"datacenter1","data":{"$color":"#3A87AD","$area":1,"nbRacks":1},"children":[{"id":"2de843ee-8be0-478e-90e3-b70751f6bf39","name":"rack1","data":{"$area":1,"$color":"#D9EDF7","nbMachines":3},"children":[{"name":"127.0.0.1","id":"f2479620-7fc4-4d56-9cde-9175151b5b0c","data":{"ip":"127.0.0.1","dc":"datacenter1","rack":"rack1","status":"up","state":"normal","load":"122,72 KB","owns":"8,33%","token":"127605887595351923798765477786913079296","$area":8,"$color":"#5BB75B"}},{"name":"127.0.0.3","id":"01c5cc53-a7ec-4153-9f66-8d498258a162","data":{"ip":"127.0.0.3","dc":"datacenter1","rack":"rack1","status":"up","state":"normal","load":"135,59 KB","owns":"33,33%","token":"113427455640312814857969558651062452225","$area":33,"$color":"#5BB75B"}},{"name":"127.0.0.2","id":"0e597787-b4c7-4b74-b28a-49e62c65ef88","data":{"ip":"127.0.0.2","dc":"datacenter1","rack":"rack1","status":"down","state":"normal","load":"135,56 KB","owns":"58,33%","token":"56713727820156407428984779325531226112","$area":58,"$color":"#DA4F49"}}]}]}],"id":"7d467d99-5e18-4875-9a3c-39d7ae9fb347","name":"Cluster Sat Apr 07 00:25:02 CEST 2012","data":{"$area":1,"$color":"#2d6987"}});
	}
</script>
</html>
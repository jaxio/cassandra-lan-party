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
						<th>Token</th>
					</tr>
				 </thead>
				 <tbody>
					<c:forEach items="${dataCenter.participants}" var="participant">
						<tr>
							<td><spring:eval expression="participant.ip" /></td>
							<td><spring:eval expression="dataCenter.name" /></td>
							<td><spring:eval expression="participant.rack" /></td>
							<td>
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
		
		<div id="infovis"></div>
	</div>
</body>
<script>
	function initTreeMap() {
		$.getJSON("<%=request.getContextPath() %>/clp/rest/ring","", function(json) { displayTreeMap(json);});
	}
</script>
</html>
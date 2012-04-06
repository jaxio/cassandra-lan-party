<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
	<link href="<%=request.getContextPath() %>/res/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<h1>Cassandra Lan Party - DEVOXX FR 2012</h1>
		</br>
		Configuration for : </br></br>
		<span class="badge badge-info">${nbDataCenter} Data Center </span></br></br>
		<span class="badge badge-info">${nbRackPerDataCenter} racks per Data Center</span></br></br> 
		<span class="badge badge-info">${nbParticipantPerRack} participants per rack </span></br></br>
	
		<c:forEach items="${dataCenters}" var="dataCenter" varStatus="_st">
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
				<c:forEach items="${dataCenter.participants}" var="participant" varStatus="_st2">
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
	</div>
</body>



</html>
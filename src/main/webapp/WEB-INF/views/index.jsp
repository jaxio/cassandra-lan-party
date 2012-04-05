<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
 <STYLE type="text/css">
   .dc1 { background-color: lightblue } 
   .dc2 { background-color: yellow } 
   .dc3 { background-color: pink } 
 </STYLE>
</head>
<body>
	<h1>Cassandra Lan Party - DEVOXX FR 2012</h1>
	
	Configuration for : ${nbDataCenter} Data Center, ${nbRackPerDataCenter} racks per Data Center and ${nbParticipantPerRack} participants per rack

	<table border="1">
		<tr>
			<th>IP</th>
			<th>DC</th>
			<th>RACK</th>
			<th>Token</th>
		</tr>
		<c:forEach items="${participants}" var="p" varStatus="_st">
			<tr class="<spring:eval expression="p.styleClass" />">
				<td><spring:eval expression="p.ip" /></td>
				<td><spring:eval expression="p.dcName" /></td>
				<td><spring:eval expression="p.rack" /></td>
				<td><spring:eval expression="p.token" /></td>

			</tr>
		</c:forEach>
	</table>
</body>



</html>
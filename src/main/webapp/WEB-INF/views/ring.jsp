<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="tags" tagdir="/WEB-INF/tags"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" uri="http://www.springframework.org/tags"
%><%@ page language="java" contentType="text/html charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<body>
	<h1>Cassandra Lan Party - DEVOXX FR 2012</h1>
	
	<table border="1">
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
		<c:forEach items="${nodeInfos}" var="node">
			<tr>
				<td><spring:eval expression="node.ip" /></td>
				<td><spring:eval expression="node.dc" /></td>
				<td><spring:eval expression="node.rack" /></td>
				<td><spring:eval expression="node.status" /></td>
				<td><spring:eval expression="node.state" /></td>
				<td><spring:eval expression="node.load" /></td>
				<td><spring:eval expression="node.owns" /></td>
				<td><spring:eval expression="node.token" /></td>
			</tr>
		</c:forEach>
	</table>
</body>

</html>
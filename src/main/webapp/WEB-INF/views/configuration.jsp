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
			<a class="btn btn-primary btn-warning" href="<%=request.getContextPath() %>/clp/index"><i class="icon-arrow-left icon-white"></i> Go back home</a>
		</div>

		<div class="page-header">
			<h1>Party configuration <small>Grab your token !</small></h1>
		</div>
		<div class="well">
			${nbDataCenter} Data centers, ${nbRackPerDataCenter} Racks per data center, ${nbParticipantPerRack} Participants per rack.
			<button class="btn btn-primary" data-toggle="modal" href="#partyConfiguration"><i class="icon-edit icon-white"></i> Change party configuration</button>
			<br/>
			Your current Ip : <code>${pageContext.request.remoteHost}</code>
		</div>

		<ul class="nav nav-tabs">
			<c:forEach items="${dataCenters}" var="dataCenter" varStatus="status">
				<li${status.first ? ' class="active"' : ''}><a href="#${dataCenter.id}" data-toggle="tab"><spring:eval expression="dataCenter.name" /></a></li>
			</c:forEach>
		</ul>
		<div class="tab-content">
			<c:forEach items="${dataCenters}" var="dataCenter" varStatus="status">
				<div class="tab-pane${status.first ? ' active' : ''}" id="${dataCenter.id}">
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
									<td>${participant.ip}</td>
									<td>${participant.rack}</td>
									<td>${participant.nodeIndexInDataCenter}</td>
									<td style="width: 350px; text-align: center;">
										<code>${participant.token}</code>
										<c:if test="${participant.ip eq pageContext.request.remoteAddr}">&larr; <span class="label label-success">yours</span></c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</c:forEach>
		</div>
	</div>
	<!-- party configuration modal dialog -->
	<div class="modal hide fade" id="partyConfiguration">
		<form action="<%=request.getContextPath() %>/clp/configuration">
			<div class="modal-header">
				<a class="close" data-dismiss="modal">×</a>
				<h3>Party configuration</h3>
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
				<button type="subtmi" id="updateProbe" class="btn btn-primary">Generate</button>
			</div>
		</form>
	</div>
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.js" language="javascript" type="text/javascript"></script>
</body>
</html>
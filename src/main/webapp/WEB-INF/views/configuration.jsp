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
			<a class="btn btn-primary" href="<%=request.getContextPath() %>/clp/index"><i class="icon-arrow-left icon-white"></i> Go back home</a>
		</div>
		<div class="page-header">
			<h1>1. Download <small>Grab your distribution !</small></h1>
		</div>
		<p>
			<a href="/static/apache-cassandra-1.0.9-bin.tar.gz" class="btn btn-primary btn-success"><i class="icon-download-alt icon-white"></i>apache-cassandra-1.0.9-bin.tar.gz</a>
		</p>
		
		<div class="page-header">
			<h1>2. Configure <small>Configure your install</small></h1>
		</div>
		<p>
			Unzip the distribution and open <code>conf/cassandra.yaml</code> and update the following properties
		</p>
		<table class="table table-bordered table-striped">
			<tbody>
				<tr class="popupDoc" title="<code>Line 22</code>" data-content="The principle is that each node should be given an equal slice of the token ring, here it is computed for you to have a nicely even ring, find it below.">
					<td><code>initial_token:</code></td>
					<td><code>initial_token: ${yourToken}</code></td>
				</tr>
				<tr class="popupDoc" title="<code>Line 98</code>" data-content="One seed for each datacenter, here we just get the first node in each datacenter.">
					<td><code>-seeds: "127.0.0.1"</code></td>
					<td><code>-seeds: "10.1.1.1,10.2.1.1,10.3.1.1"</code></td>
				</tr>
				<tr class="popupDoc" title="<code>Line 181</code>" data-content="You need to listen to your real ip, so the other nodes can talk to you.">
					<td><code>listen_address: localhost</code></td>
					<td><code>listen_address: ${yourIp}</code></td>
				</tr>
				<tr class="popupDoc" title="<code>Line 193</code>" data-content="You need to listen to your real ip, so the other nodes can talk to you.">
					<td><code>rpc_address: localhost</code></td>
					<td><code>rpc_address: ${yourIp}</code></td>
				</tr>
				<tr class="popupDoc" title="<code>Line 343</code>" data-content="Proximity is determined by rack and data center, which are assumed to correspond to the 3rd and 2nd octet of each node's IP address, respectively.">
					<td><code>endpoint_snitch: org.apache.cassandra.locator.SimpleSnitch</code></td>
					<td><code>endpoint_snitch: org.apache.cassandra.locator.RackInferringSnitch</code></td>
				</tr>
			</tbody>
		</table>

		<div class="page-header">
			<h1>3. Party <small>See the party machine and tokens.</small></h1>
		</div>
		<div class="well">
			${nbDataCenter} Data centers, ${nbRackPerDataCenter} Racks per data center, ${nbParticipantPerRack} Participants per rack.
		</div>

		<ul class="nav nav-tabs">
			<c:forEach items="${dataCenters}" var="dataCenter" varStatus="status">
				<li${dataCenter.id eq yourDataCenterId ? ' class="active"' : ''}>
					<a href="#${dataCenter.id}" data-toggle="tab">
						${dataCenter.id == yourDataCenterId ? '<i class="icon-arrow-down"></i> ' : ''}<spring:eval expression="dataCenter.name" />
					</a>
				</li>
			</c:forEach>
		</ul>
		<div class="tab-content">
			<c:forEach items="${dataCenters}" var="dataCenter" varStatus="status">
				<div class="tab-pane${dataCenter.id eq yourDataCenterId ? ' active' : ''}" id="${dataCenter.id}">
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
									<td style="width: 350px;">
										<code>${participant.token}</code>
										${participant.ip == yourIp ? '&larr; <span class="label label-success">yours</span>' : ''}
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</c:forEach>
		</div>
	</div>
	<script src="<%=request.getContextPath() %>/static/js/jquery-1.7-min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath() %>/static/js/bootstrap.min.js" language="javascript" type="text/javascript"></script>
	<script>
		$(".popupDoc").popover({placement:'bottom'})
	</script>
</body>
</html>
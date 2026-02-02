<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
	body {
	  background-color: #e8f8e8;
	  }
</style>


<h2>店舗登録完了</h2>

<div class="complete-container">

<%
    String success = (String)request.getAttribute("successMessage");
    String error = (String)request.getAttribute("errorMessage");
%>

<% if (success != null) { %>
    <p class="complete-message"><%= success %></p>
<% } %>

<% if (error != null) { %>
    <p class="error-message"><%= error %></p>
<% } %>

    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">管理者ホームに戻る</a>
</div>

<%@include file="../../footer.html" %>

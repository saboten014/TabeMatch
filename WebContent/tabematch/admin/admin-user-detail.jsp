<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>ユーザー詳細</h2>

<%
Users user = (Users) request.getAttribute("user");
%>

<table border="1" cellpadding="10">
<tr><th>ID</th><td><%= user.getUserId() %></td></tr>
<tr><th>ユーザー名</th><td><%= user.getUserName() %></td></tr>
<tr><th>登録日</th><td><%= user.getCreatedAt() %></td></tr>
</table>

<br>

<a href="AdminUserDeleteConfirm.action?userId=<%= user.getUserId() %>" class="btn btn-danger">削除する</a>

<%@include file="../../footer.html" %>

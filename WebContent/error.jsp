<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="header.html" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css">

<div class="header-e">
	<div class="logo">たべまっち</div>
</div>


<h1>😫エラーが発生しました😫</h1>

<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.isEmpty()) {
%>
    <p><%= errorMessage %></p>
<%
    }
%>

<p style="text-align: center;">
	<a class="in-btn" href="<%= request.getContextPath() %>/tabematch/Login.action">ログイン画面に戻る</a>
</p>

<%@include file="footer.html" %>
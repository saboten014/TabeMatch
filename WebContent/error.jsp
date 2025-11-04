<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="header.html" %>

<h1>エラーが発生しました</h1>

<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.isEmpty()) {
%>
    <p><%= errorMessage %></p>
<%
    }
%>

<p><a href="<%= request.getContextPath() %>/tabematch/Login.action">ログイン画面に戻る</a></p>

<%@include file="footer.html" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>

<%
    String contextPath = request.getContextPath();
    Users user = (Users)session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../Login.action");
        return;
    }
%>

<h1>トップページ</h1>

<p>ようこそ、<%= user.getUserName() %>さん</p>

<h2>メニュー</h2>
<ul>
    <li><a href="search.jsp">店舗検索</a></li>
    <li><a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a></li>
</ul>

<%@include file="../../footer.html" %>
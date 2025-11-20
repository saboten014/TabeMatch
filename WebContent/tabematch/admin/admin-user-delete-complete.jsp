<%@page pageEncoding="UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_home.css">

<div class="container">
    <h2>ユーザー削除</h2>

    <%
        String successMessage = (String)request.getAttribute("successMessage");
        String errorMessage = (String)request.getAttribute("errorMessage");
    %>

    <% if (successMessage != null) { %>
        <div class="success-message">
            <p><%= successMessage %></p>
        </div>
    <% } %>

    <% if (errorMessage != null) { %>
        <div class="error-message">
            <p><%= errorMessage %></p>
        </div>
    <% } %>

    <div class="button-group">
        <a href="<%= request.getContextPath() %>/tabematch/admin/AdminUserList.action" class="btn">ユーザー一覧に戻る</a>
        <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp" class="btn">管理者ホームに戻る</a>
    </div>
</div>

<%@include file="../../footer.html" %>
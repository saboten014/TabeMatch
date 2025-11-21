<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- CSS読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_user_detail.css">

<h2>ユーザー詳細</h2>

<div class="detail-container">
<%
Users user = (Users) request.getAttribute("user");
%>
    <table>
        <tr>
            <th>ID</th>
            <td><%= user.getUserId() %></td>
        </tr>
        <tr>
            <th>ユーザー名</th>
            <td><%= user.getUserName() %></td>
        </tr>
        <tr>
            <th>登録日</th>
            <td><%= user.getCreatedAt() %></td>
        </tr>
    </table>

    <div class="button-container">
        <a href="AdminUserDeleteConfirm.action?userId=<%= user.getUserId() %>" class="btn btn-danger">削除する</a>
        <a href="<%= request.getContextPath() %>/tabematch/admin/AdminUserList.action" class="btn btn-back">← 一覧に戻る</a>
    </div>
</div>

<%@include file="../../footer.html" %>
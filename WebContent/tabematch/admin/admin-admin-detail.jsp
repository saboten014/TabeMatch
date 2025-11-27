<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- CSS読み込み（キャッシュ回避付き） -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_admin_detail.css?v=<%= System.currentTimeMillis() %>">

<h2>管理者詳細</h2>

<div class="detail-container">
<%
    Users admin = (Users) request.getAttribute("admin");
    String loginUserId = (String) request.getAttribute("loginUserId");
%>
    <table>
        <tr>
            <th>ID</th>
            <td><%= admin.getUserId() %></td>
        </tr>
        <tr>
            <th>管理者名</th>
            <td><%= admin.getUserName() %></td>
        </tr>
        <tr>
            <th>登録日</th>
            <td><%= admin.getCreatedAt() %></td>
        </tr>
    </table>

    <div class="button-container">
        <%-- 自分自身は削除ボタンを表示しない --%>
        <% if (loginUserId != null && !loginUserId.equals(admin.getUserId())) { %>
            <a href="AdminAdminDeleteConfirm.action?userId=<%= admin.getUserId() %>" class="btn btn-danger">削除する</a>
        <% } else { %>
            <span>※ 自分自身の管理者は削除できません</span>
        <% } %>
        <a href="AdminAdminList.action" class="btn btn-back">← 一覧に戻る</a>
    </div>
</div>

<%@include file="../../footer.html" %>
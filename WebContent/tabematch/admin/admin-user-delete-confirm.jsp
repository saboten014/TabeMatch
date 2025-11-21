<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- CSS読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_user_delete_confirm.css">

<h2>ユーザー削除確認</h2>

<div class="confirm-container">
    <div class="warning-icon">⚠️</div>
    <p class="confirm-message">本当にこのユーザーを削除しますか？<br>この操作は取り消すことができません。</p>

    <div class="button-container">
        <form action="AdminUserDelete.action" method="post">
            <input type="hidden" name="userId" value="${userId}">
            <button type="submit" class="btn btn-danger">はい、削除します</button>
        </form>
        <a href="AdminUserList.action" class="btn btn-cancel">いいえ（戻る）</a>
    </div>
</div>

<%@include file="../../footer.html" %>
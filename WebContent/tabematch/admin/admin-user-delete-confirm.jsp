<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>ユーザー削除確認</h2>

<p>本当にこのユーザーを削除しますか？</p>

<form action="AdminUserDelete.action" method="post">
    <input type="hidden" name="userId" value="${userId}">
    <button type="submit" class="btn btn-danger">はい、削除します</button>
</form>

<br>

<a href="AdminUserList.action">いいえ（戻る）</a>

<%@include file="../../footer.html" %>

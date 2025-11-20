<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="../main/user_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-insert.css">

<div class=zenbu>
<h1>管理者アカウント登録</h1>

<form action="AdminInsertExecute.action" method="post">

    <table>
        <tr>
            <td>メールアドレス<span class="required">*</span></td>
            <td>
                <input type="email" name="userId" maxlength="50" required>
            </td>
        </tr>
        <tr>
            <td>パスワード<span class="required">*</span></td>
            <td>
                <input type="password" name="password" maxlength="255" required>
            </td>
        </tr>
        <tr>
            <td>ユーザー名<span class="required">*</span></td>
            <td>
                <input type="text" name="userName" maxlength="50" required>
            </td>
        </tr>

        <!-- ★管理者区分を固定 -->
        <input type="hidden" name="usersTypeId" value="3">

        <tr>
            <td colspan="2" style="text-align:center;">
                <input type="submit" value="登録">
            </td>
        </tr>
    </table>
</form>


</div>
<%@include file="../../footer.html" %>

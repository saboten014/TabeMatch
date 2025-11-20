<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="/tabematch/main/admin_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- CSS読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_insert.css">

<h1>管理者アカウント登録</h1>

<div class="error-message">
<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
    <p><%= errorMessage %></p>
<%
    }
%>
</div>

<div class="form-container">
<form action="AdminInsertExecute.action" method="post">
    <table>
        <tr>
            <td>メールアドレス<span class="required">*</span></td>
            <td>
                <input type="email" name="userId" maxlength="50" required>
                <small>50文字以内</small>
            </td>
        </tr>
        <tr>
            <td>パスワード<span class="required">*</span></td>
            <td>
                <input type="password" name="password" id="adminPassword" maxlength="255" required style="width: 280px; display: inline-block; vertical-align: middle;">
                <button type="button" onclick="togglePassword('adminPassword', this)" style="display: inline-block; vertical-align: middle;">👁️ 表示</button>
                <small>225文字以内</small>
            </td>
        </tr>
        <tr>
            <td>ユーザー名<span class="required">*</span></td>
            <td>
                <input type="text" name="userName" maxlength="50" required>
                <small>50文字以内</small>
            </td>
        </tr>
        <!-- ★管理者区分を固定 -->
        <input type="hidden" name="usersTypeId" value="3">
        <tr>
            <td colspan="2" style="text-align: center;">
                <input type="submit" value="登録">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
</form>
</div>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理者ホームに戻る</a>
</div>

<script>
function togglePassword(inputId, button) {
    var input = document.getElementById(inputId);
    if (input.type === "password") {
        input.type = "text";
        button.textContent = "🔒 非表示";
    } else {
        input.type = "password";
        button.textContent = "👁️ 表示";
    }
}
</script>
<%@include file="../../footer.html" %>
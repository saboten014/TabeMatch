<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="dao.AllergenDAO" %>
<%@include file="../header.html" %>

<h1>新規ユーザー登録</h1>

<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
    <p style="color: red;"><%= errorMessage %></p>
<%
    }
%>

<form action="RegisterExecute.action" method="post">
    <table>
        <tr>
            <td>メールアドレス:</td>
            <td><input type="email" name="userId" size="30" maxlength="50" required>
                <small>(50文字以内)</small>
            </td>
        </tr>
        <tr>
            <td>パスワード:</td>
            <td>
                <input type="password" name="password" id="registerPassword" size="30" maxlength="225" required>
                <button type="button" onclick="togglePassword('registerPassword', this)" style="margin-left: 5px;">
                    👁️ 表示
                </button>
                <br><small>(225文字以内)</small>
            </td>
        </tr>
        <tr>
            <td>パスワード確認:</td>
            <td>
                <input type="password" name="passwordConfirm" id="confirmPassword" size="30" maxlength="225" required>
                <button type="button" onclick="togglePassword('confirmPassword', this)" style="margin-left: 5px;">
                    👁️ 表示
                </button>
            </td>
        </tr>
        <tr>
            <td>ユーザー名:</td>
            <td><input type="text" name="userName" size="30" maxlength="50" required>
                <small>(50文字以内)</small>
            </td>
        </tr>
        <tr>
            <td>アレルギー情報:</td>
            <td>
<%
    // アレルゲン一覧を取得
    AllergenDAO allergenDao = new AllergenDAO();
    List<Allergen> allergenList = allergenDao.getAllAllergens();

    for (Allergen allergen : allergenList) {
%>
                <input type="checkbox" name="allergenIds" value="<%= allergen.getAllergenId() %>" id="reg_allergy_<%= allergen.getAllergenId() %>">
                <label for="reg_allergy_<%= allergen.getAllergenId() %>"><%= allergen.getAllergenName() %></label><br>
<%
    }
%>
                <small>※該当するアレルギーをすべて選択してください（複数選択可）</small>
            </td>
        </tr>
        <!-- ユーザー区分を一般ユーザー（1）で固定 -->
        <input type="hidden" name="usersTypeId" value="1">
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="登録">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
</form>

<p><a href="Login.action">ログイン画面に戻る</a></p>

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

<%@include file="../footer.html" %>
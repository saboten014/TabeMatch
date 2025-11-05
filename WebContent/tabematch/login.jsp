<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>

<h1>ログイン</h1>

<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    String successMessage = (String)request.getAttribute("successMessage");

    if (errorMessage != null) {
%>
    <p style="color: red;"><%= errorMessage %></p>
<%
    }

    if (successMessage != null) {
%>
    <p style="color: green;"><%= successMessage %></p>
<%
    }
%>

<form action="LoginExecute.action" method="post">
    <table>
        <tr>
            <td>メールアドレス:</td>
            <td><input type="email" name="login" size="30" required></td>
        </tr>
        <tr>
            <td>パスワード:</td>
            <td><input type="password" name="password" size="30" required></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="ログイン">
            </td>
        </tr>
    </table>
</form>

<p><a href="Register.action">新規ユーザー登録はこちら</a></p>

<%@include file="../footer.html" %>
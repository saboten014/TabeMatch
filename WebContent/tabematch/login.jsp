<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>
<%@include file="login_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<style>
  body {
    background-color: #e8f8e8 !important;
    font-family: "Kosugi Maru", "Meiryo", sans-serif !important;
    margin: 0;
    padding: 0;
  }
  /* ===== メニューバーを横並びに強制 ===== */
  .header {
    display: flex !important;
    flex-direction: row !important;
    justify-content: space-between !important;
    align-items: center !important;
    flex-wrap: nowrap !important;
  }
  .nav-links {
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    flex-wrap: nowrap !important;
  }
  .nav-links a {
    display: inline-block !important;
    margin-left: 25px !important;
    white-space: nowrap !important;
  }
  /* ===== フォーム部分 ===== */
  h1 {
    margin-top: 120px;
    font-size: 28px;
    text-align: center;
    color: #333;
  }
  form {
    display: inline-block;
    margin-top: 30px;
    text-align: left;
  }
  table {
    border-collapse: collapse;
    margin: 0 auto;
  }
  td {
    padding: 12px 10px;
    font-size: 18px;
    vertical-align: middle;
  }
  input[type="email"],
  input[type="password"],
  input[type="text"]#loginPassword {
    font-size: 18px;
    padding: 10px;
    width: 280px;
    border: 1px solid #aaa;
    border-radius: 6px;
    box-sizing: border-box;
  }
  button {
    font-size: 16px;
    padding: 10px 14px;
    border: 1px solid #aaa;
    border-radius: 6px;
    background-color: #fff;
    cursor: pointer;
    vertical-align: middle;
  }
  button:hover {
    background-color: #ccffcc;
  }
  input[type="submit"] {
    margin-top: 20px;
    font-size: 18px;
    padding: 12px 40px;
    border: none;
    border-radius: 8px;
    background-color: #ffffff;
    cursor: pointer;
  }
  input[type="submit"]:hover {
    background-color: #00bfff;
  }
  a {
    display: block;
    margin-top: 15px;
    text-align: center;
    color: #d14;
    text-decoration: none;
    font-size: 16px;
  }
  a:hover {
    text-decoration: underline;
  }
  /* ===== リンクボタンのスタイル ===== */
  .link-button {
    display: inline-block;
    padding: 12px 24px;
    background-color: #ffffff;
    border: 2px solid #b2d8b0;
    border-radius: 8px;
    color: #333;
    text-decoration: none;
    font-size: 16px;
    font-weight: 500;
    transition: all 0.3s ease;
    margin: 0;
  }
  .link-button:hover {
    text-decoration: none;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  /* 新規ユーザー登録ボタン（赤） */
  .register-button:hover {
    background-color: #ffcccc;
    border-color: #ff9999;
  }
  /* 店舗掲載リクエストボタン（黄色） */
  .shop-button:hover {
    background-color: #fff9cc;
    border-color: #ffeb99;
  }
  /* ===== メッセージ部分中央寄せ ===== */
  .message {
    text-align: center;
    margin-top: 15px;
  }
</style>
<h1>ログイン</h1>
<div class="message">
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
</div>
<div style="text-align:center;">
<form action="LoginExecute.action" method="post">
    <table>
        <tr>
            <td>メールアドレス:</td>
            <td><input type="email" name="login" required></td>
        </tr>
        <tr>
            <td>パスワード:</td>
            <td>
                <input type="password" name="password" id="loginPassword" required style="width: 280px; display: inline-block; vertical-align: middle;">
                <button type="button" onclick="togglePassword('loginPassword', this)" style="display: inline-block; vertical-align: middle; margin-left: 5px;">👁️ 表示</button>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="ログイン">
            </td>
        </tr>
    </table>
</form>
</div>
<div style="text-align: center; margin-top: 30px; display: flex; justify-content: center; gap: 20px;">
    <a href="Register.action" class="link-button register-button">新規ユーザー登録はこちら</a>
    <a href="ShopRequest.action" class="link-button shop-button">店舗掲載リクエストはこちら</a>
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
<%@include file="../footer.html" %>
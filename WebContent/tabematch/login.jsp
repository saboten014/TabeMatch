<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<style>
  body {
    background-color: #e8f8e8 !important;
    font-family: "Kosugi Maru", "Meiryo", sans-serif !important;
    margin: 0;
    padding: 0;
  }
  /* ===== メニューバー用CSS（user_menu.jspに任せる） ===== */
  /* ログイン画面専用：メニューを中央に */
  .nav-links {
    display: flex !important;
    align-items: center !important;
  }
  .nav-links a {
    line-height: normal !important;
    vertical-align: middle !important;
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
  /* ===== ログインボタンのスタイル ===== */
  input[type="submit"],
  input[type="submit"].login-button,
  form input[type="submit"],
  table input[type="submit"] {
    margin-top: 20px !important;
    font-size: 18px !important;
    padding: 12px 40px !important;
    border: 2px solid #4da6ff !important;
    border-radius: 8px !important;
    background-color: #cce5ff !important;
    color: #333 !important;
    cursor: pointer !important;
    transition: all 0.3s ease !important;
  }
  input[type="submit"]:hover,
  input[type="submit"].login-button:hover,
  form input[type="submit"]:hover,
  table input[type="submit"]:hover {
    background-color: #99ccff !important;
    border-color: #3399ff !important;
    transform: translateY(-2px) !important;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15) !important;
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
  .register-button {
    background-color: #ffcccc !important;
    border: 2px solid #ff9999 !important;
    color: #333 !important;
    box-sizing: border-box;
  }
  .register-button:hover {
    background-color: #ff9999 !important;
    border-color: #ff6666 !important;
  }
  /* 店舗掲載リクエストボタン（黄色） */
  .shop-button {
    background-color: #fff9cc !important;
    border: 2px solid #ffeb99 !important;
    color: #333 !important;
    box-sizing: border-box;
  }
  .shop-button:hover {
    background-color: #ffeb99 !important;
    border-color: #ffd966 !important;
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
                <input type="submit" value="ログイン" class="login-button" id="loginSubmitBtn"
                       onmouseover="this.style.setProperty('background-color', '#99ccff', 'important'); this.style.setProperty('border-color', '#3399ff', 'important');"
                       onmouseout="this.style.setProperty('background-color', '#cce5ff', 'important'); this.style.setProperty('border-color', '#4da6ff', 'important');">
            </td>
        </tr>
    </table>
</form>
</div>
<div style="text-align: center; margin-top: 50px; display: flex; justify-content: center; gap: 30px; flex-wrap: wrap;">
    <!-- 新規登録セクション -->
    <div style="border: 3px solid #ff9999; border-radius: 12px; padding: 30px 40px; background-color: #fff5f5; min-width: 320px; box-sizing: border-box;">
        <p style="font-size: 18px; color: #333; margin-bottom: 20px; font-weight: 500;">初めてご利用の方はこちら</p>
        <a href="Register.action" class="link-button register-button" style="display: block; white-space: nowrap;">新規ユーザー登録</a>
    </div>

    <!-- 店舗掲載リクエストセクション -->
    <div style="border: 3px solid #ffeb99; border-radius: 12px; padding: 30px 40px; background-color: #fffef5; min-width: 320px; box-sizing: border-box;">
        <p style="font-size: 18px; color: #333; margin-bottom: 20px; font-weight: 500;">店舗様向けサービスはこちら</p>
        <a href="ShopRequest.action" class="link-button shop-button" style="display: block; white-space: nowrap;">店舗掲載リクエスト</a>
    </div>
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

// ログインボタンのスタイルを強制適用
window.addEventListener('DOMContentLoaded', function() {
    var loginBtn = document.getElementById('loginSubmitBtn');
    if (loginBtn) {
        loginBtn.style.setProperty('background-color', '#cce5ff', 'important');
        loginBtn.style.setProperty('border', '2px solid #4da6ff', 'important');
        loginBtn.style.setProperty('color', '#333', 'important');
    }
});
</script>
<%@include file="../footer.html" %>
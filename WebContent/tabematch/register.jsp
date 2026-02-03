<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="dao.AllergenDAO" %>
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
  /* ===== タイトル ===== */
  h1 {
    margin-top: 120px;
    padding-top: 20px;
    font-size: 32px;
    text-align: center;
    color: #333;
    margin-bottom: 10px;
  }
  /* ===== フォーム部分 ===== */
  .form-container {
    text-align: center;
    margin-top: 30px;
  }
  form {
    display: inline-block;
    text-align: left;
  }
  table {
    border-collapse: collapse;
    margin: 0 auto;
  }
  td {
    padding: 15px 10px;
    font-size: 18px;
    vertical-align: middle;
  }
  td:first-child {
    text-align: right;
    padding-right: 20px;
    font-weight: 500;
    width: 180px;
    font-size: 18px;
  }
  input[type="text"],
  input[type="email"],
  input[type="password"] {
    font-size: 16px;
    padding: 10px 12px;
    width: 400px;
    border: 1px solid #aaa;
    border-radius: 6px;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    box-sizing: border-box;
  }
  small {
    color: #888;
    font-size: 20px;
    display: block;
    margin-top: 5px;
  }
  .required {
    color: #ff6b6b;
    font-weight: bold;
    margin-left: 3px;
  }
  button {
    font-size: 16px;
    padding: 10px 14px;
    border: 1px solid #aaa;
    border-radius: 6px;
    background-color: #fff;
    cursor: pointer;
    vertical-align: middle;
    margin-left: 5px;
  }
  button:hover {
    background-color: #ccffcc;
  }
  /* ===== チェックボックスのグリッド ===== */
  .checkbox-grid {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 15px 20px;
    margin-bottom: 15px;
    width: 600px;
  }
  .checkbox-item {
    display: flex;
    align-items: center;
  }
  .checkbox-item input[type="checkbox"] {
    margin: 0;
    padding: 0;
    width: 16px;
    height: 16px;
    flex-shrink: 0;
  }
  .checkbox-item label {
    font-size: 20px;
    cursor: pointer;
    margin-left: 5px;
    white-space: nowrap;
  }
  /* その他アレルギー入力欄 */
  .other-allergy {
    margin-top: 10px;
  }
  .other-allergy input[type="text"] {
    width: 400px;
  }
  /* ===== ボタン ===== */
  input[type="submit"],
  input[type="reset"] {
    margin-top: 30px;
    font-size: 18px;
    padding: 14px 50px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    transition: all 0.3s ease;
  }
  input[type="submit"] {
    background-color: #ffcccc;
    color: #333;
    margin-right: 15px;
    border: 2px solid #ff9999;
  }
  input[type="submit"]:hover {
    background-color: #ff9999;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
  input[type="reset"] {
    background-color: #cce5ff;
    color: #333;
    border: 2px solid #99ccff;
  }
  input[type="reset"]:hover {
    background-color: #99ccff;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
  /* ===== エラーメッセージ ===== */
  .error-message {
    text-align: center;
    margin-top: 15px;
  }
  .error-message p {
    color: #d14;
    background-color: #ffe6e6;
    padding: 12px 20px;
    border-radius: 6px;
    display: inline-block;
    border: 1px solid #ffcccc;
  }
  /* ===== 戻るリンク ===== */
  .back-link {
    text-align: center;
    margin-top: 30px;
    margin-bottom: 50px;
  }
  .back-link a {
    display: inline-block;
    padding: 12px 30px;
    background-color: #ffcccc;
    border: 2px solid #ff9999;
    border-radius: 8px;
    color: #333;
    text-decoration: none;
    font-size: 16px;
    transition: all 0.3s ease;
  }
  .back-link a:hover {
    background-color: #ff9999;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
</style>

<h1>新規ユーザー登録</h1>

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
<form action="RegisterExecute.action" method="post">
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
                <input type="password" name="password" id="registerPassword" maxlength="225" required style="width: 280px; display: inline-block; vertical-align: middle;">
                <button type="button" onclick="togglePassword('registerPassword', this)" style="display: inline-block; vertical-align: middle;">👁️ 表示</button>
                <small>225文字以内</small>
            </td>
        </tr>
        <tr>
            <td>パスワード確認<span class="required">*</span></td>
            <td>
                <input type="password" name="passwordConfirm" id="confirmPassword" maxlength="225" required style="width: 280px; display: inline-block; vertical-align: middle;">
                <button type="button" onclick="togglePassword('confirmPassword', this)" style="display: inline-block; vertical-align: middle;">👁️ 表示</button>
            </td>
        </tr>
        <tr>
            <td>ユーザー名<span class="required">*</span></td>
            <td>
                <input type="text" name="userName" maxlength="50" required>
                <small>50文字以内</small>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top; padding-top: 20px;">NG食材情報</td>
            <td>
                <div class="checkbox-grid">
<%
    // アレルゲン一覧を取得
    AllergenDAO allergenDao = new AllergenDAO();
    List<Allergen> allergenList = allergenDao.getAllAllergens();
    for (Allergen allergen : allergenList) {
%>
                    <div class="checkbox-item">
                        <input type="checkbox" name="allergenIds" value="<%= allergen.getAllergenId() %>" id="reg_allergy_<%= allergen.getAllergenId() %>">
                        <label for="reg_allergy_<%= allergen.getAllergenId() %>"><%= allergen.getAllergenName() %></label>
                    </div>
<%
    }
%>
                </div>
                <div class="other-allergy">
                    <label for="otherAllergy">要配慮食材:</label>
                    <input type="text" name="otherAllergy" id="otherAllergy" placeholder="例: とうもろこし、トマト">
                </div>
                <small>※配慮が必要な食材をすべて選択してください（複数選択可）</small>
            </td>
        </tr>
        <!-- ユーザー区分を一般ユーザー（1）で固定 -->
        <input type="hidden" name="usersTypeId" value="1">
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
    <a href="Login.action">← ログイン画面に戻る</a>
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
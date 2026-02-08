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
		        <input type="text"
		               name="userId"
		               id="request_mail"
		               maxlength="100"
		               required
		               placeholder="example@mail.com"
		               pattern="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
		               title="半角英数字で正しいメール形式を入力してください">
		        <div id="email-error" class="error-text" style="color: red; font-size: 0.8em; display: none; font-weight: bold;">
		        </div>
		    </td>
		</tr>

        <tr>
		    <td>パスワード<span class="required">*</span></td>
		    <td>
		        <div class="input-with-button">
		            <input type="password"
		                   name="password"
		                   id="registerPassword"
		                   maxlength="32"
		                   required
		                   pattern="^[a-zA-Z0-9]+$"
		                   title="半角英数字のみ使用可能です">
		            <button type="button" onclick="togglePassword('registerPassword', this)">👁️ 表示</button>
		        </div>
		        <div id="pass-error" class="error-text" style="color: red; font-size: 0.8em; display: none;"></div>
		        <small>8～32文字の半角英数字</small>
		    </td>
		</tr>

		<tr>
		    <td>パスワード確認<span class="required">*</span></td>
		    <td>
		        <div class="input-with-button">
		            <input type="password"
		                   name="passwordConfirm"
		                   id="confirmPassword"
		                   maxlength="32"
		                   required>
		            <button type="button" onclick="togglePassword('confirmPassword', this)">👁️ 表示</button>
		        </div>
		        <div id="confirm-error" class="error-text" style="color: red; font-size: 0.8em; display: none;">
		            ※パスワードが一致しません
		        </div>
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
		                <%-- name="allergenIds" はAction側と一致しているのでそのままでOK --%>
		                <input type="checkbox" name="allergenIds" value="<%= allergen.getAllergenId() %>" id="reg_allergy_<%= allergen.getAllergenId() %>">
		                <label for="reg_allergy_<%= allergen.getAllergenId() %>"><%= allergen.getAllergenName() %></label>
		            </div>
		<%
		    }
		%>
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
document.addEventListener("DOMContentLoaded", () => {
    // --- 要素の取得 ---
    const form = document.querySelector("form");
    const emailInput = document.getElementById("request_mail");
    const emailError = document.getElementById("email-error");
    const passInput = document.getElementById("registerPassword");
    const confirmInput = document.getElementById("confirmPassword");
    const passError = document.getElementById("pass-error");
    const confirmError = document.getElementById("confirm-error");

    // --- 正規表現パターン ---
    const emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    const passPattern = /^[a-zA-Z0-9]+$/;

    // --- 1. メールアドレスのバリデーション ---
    if (emailInput) {
        emailInput.addEventListener("input", () => {
            const hasFullWidth = /[^\x01-\x7E]/.test(emailInput.value);

            if (emailInput.value === "") {
                emailError.style.display = "none";
                emailInput.style.borderColor = "";
            } else if (hasFullWidth) {
                emailError.textContent = "※全角文字が含まれています";
                emailError.style.display = "block";
                emailInput.style.borderColor = "red";
            } else if (!emailPattern.test(emailInput.value)) {
                emailError.textContent = "※正しいメール形式で入力してください";
                emailError.style.display = "block";
                emailInput.style.borderColor = "red";
            } else {
                emailError.style.display = "none";
                emailInput.style.borderColor = "#99ccff";
            }
        });
    }

    // --- 2. パスワードのバリデーション ---
    const validatePassword = () => {
        const passValue = passInput.value;
        if (passValue === "") {
            passError.style.display = "none";
            passInput.style.borderColor = "";
        } else if (!passPattern.test(passValue)) {
            passError.textContent = "※英数字のみ（記号不可）で入力してください";
            passError.style.display = "block";
            passInput.style.borderColor = "red";
        } else if (passValue.length < 8) {
            passError.textContent = "※8文字以上で入力してください";
            passError.style.display = "block";
            passInput.style.borderColor = "red";
        } else {
            passError.style.display = "none";
            passInput.style.borderColor = "#99ccff";
        }
        checkMatch(); // パスワードが変わったら一致チェックも再実行
    };

    const checkMatch = () => {
        if (confirmInput.value === "") {
            confirmError.style.display = "none";
            confirmInput.style.borderColor = "";
        } else if (passInput.value !== confirmInput.value) {
            confirmError.style.display = "block";
            confirmInput.style.borderColor = "red";
        } else {
            confirmError.style.display = "none";
            confirmInput.style.borderColor = "#99ccff";
        }
    };

    if (passInput) passInput.addEventListener("input", validatePassword);
    if (confirmInput) confirmInput.addEventListener("input", checkMatch);

    // --- 3. 送信時の最終ガード（1つのsubmitにまとめる） ---
    form.addEventListener("submit", (e) => {
        let hasError = false;
        let messages = [];

        // メールの最終チェック
        if (!emailPattern.test(emailInput.value)) {
            messages.push("メールアドレスの形式が正しくありません。");
            hasError = true;
        }

        // パスワードの最終チェック
        if (passInput.value.length < 8 || !passPattern.test(passInput.value)) {
            messages.push("パスワードは英数字8文字以上で入力してください。");
            hasError = true;
        }

        // 一致の最終チェック
        if (passInput.value !== confirmInput.value) {
            messages.push("パスワードが一致していません。");
            hasError = true;
        }

        if (hasError) {
            alert(messages.join("\n"));
            e.preventDefault(); // 送信を中止
        }
    });
});

// togglePasswordは外に出したままでOK
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
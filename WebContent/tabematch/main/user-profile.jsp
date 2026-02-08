<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ page import="bean.Allergen" %>
<%@ page import="java.util.List" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_prof_v.css">
<title>プロフィール編集</title>

<div class="container">
    <h2 class="text-center">プロフィール編集</h2>

    <div class="card">
        <%-- エラーメッセージ表示 --%>
        <% String error = (String)request.getAttribute("errorMessage"); %>
        <% if (error != null) { %>
            <div class="alert-danger" style="margin-bottom: 20px; padding: 10px; border-radius: 10px; background-color: #fff1f0; color: #e57373; border: 1px solid #ffcdd2;">
                <%= error %>
            </div>
        <% } %>

        <form action="UserProfile.action" method="post" id="editProfileForm">
            <%-- Actionの「mode.equals("update")」を動かすために必要 --%>
            <input type="hidden" name="mode" value="update">

            <table class="edit-table">
                <%
                    Users user = (Users) request.getAttribute("user");
                    List<Allergen> allergenList = (List<Allergen>) request.getAttribute("allergenList");
                    // ユーザーが現在持っているアレルギーIDを取得
                    String currentAllergens = (user.getAllergenId() != null) ? user.getAllergenId() : "";
                %>

                <tr>
                    <th>ユーザー名</th>
                    <td>
                        <input type="text" name="userName" value="<%= user.getUserName() %>" required class="input-field">
                    </td>
                </tr>
                <tr>
                    <th>メールアドレス</th>
                    <td>
                        <input type="text" name="userMail" id="userMail" value="<%= user.getUserId() %>" required class="input-field">
                        <%-- メールのエラー表示エリアを追加 --%>
                        <div id="mail-error" style="color: red; font-size: 11px; display: none; margin-top: 5px;">※正しいメール形式で入力してください</div>
                    </td>
                </tr>
                <tr>
                    <th>新しいパスワード</th>
                    <td>
                        <div style="position: relative; display: flex; align-items: center;">
                            <input type="password" name="password" id="passInput" value="<%= user.getPassword() %>" required class="input-field" style="padding-right: 45px;">
                            <span id="togglePass" style="position: absolute; right: 12px; cursor: pointer; font-size: 1.2em; user-select: none;">👁️</span>
                        </div>
                        <div id="pass-error" style="color: red; font-size: 11px; display: none; margin-top: 5px;">※半角英数字8文字以上必要です</div>
                        <p style="font-size: 11px; color: #888; margin-top: 5px;">※変更しない場合も入力してください</p>
                    </td>
                </tr>
                <tr>
                    <th>パスワード(確認)</th>
                    <td>
                        <div style="position: relative; display: flex; align-items: center;">
                            <input type="password" name="confirmPassword" id="confirmPassInput" value="<%= user.getPassword() %>" required class="input-field" style="padding-right: 45px;">
                            <span id="toggleConfirmPass" style="position: absolute; right: 12px; cursor: pointer; font-size: 1.2em; user-select: none;">👁️</span>
                        </div>
                        <div id="confirm-error" style="color: red; font-size: 11px; display: none; margin-top: 5px;">※パスワードが一致しません</div>
                    </td>
                </tr>
                <tr>
                    <th>NG食材</th>
                    <td>
                        <div class="allergen-grid">
                            <%
                            if (allergenList != null) {
                                for (Allergen a : allergenList) {
                                    boolean checked = currentAllergens.contains(a.getAllergenId());
                            %>
                                <label class="checkbox-label">
                                    <input type="checkbox" name="allergen" value="<%= a.getAllergenId() %>" <%= checked ? "checked" : "" %>>
                                    <span class="checkbox-text"><%= a.getAllergenName() %></span>
                                </label>
                            <%
                                }
                            }
                            %>
                        </div>
                    </td>
                </tr>
            </table>

            <div class="btn">
                <button type="submit" class="btn-hensyu">変更を保存する</button>
                <a href="UserProfileView.action" class="btn-modoru">変更せずに戻る</a>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("editProfileForm");
    const mailInput = document.getElementById("userMail");
    const mailError = document.getElementById("mail-error");
    const passInput = document.getElementById("passInput");
    const confirmInput = document.getElementById("confirmPassInput");
    const passError = document.getElementById("pass-error");
    const confirmError = document.getElementById("confirm-error");

    const passPattern = /^[a-zA-Z0-9]+$/;
    const emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;

    // --- 1. メールアドレスバリデーション ---
    const validateMail = () => {
        const value = mailInput.value;
        const hasFullWidth = /[^\x01-\x7E]/.test(value); // 全角チェック

        if (value === "") {
            mailError.style.display = "none";
            mailInput.style.borderColor = "#ddd";
        } else if (hasFullWidth || !emailPattern.test(value)) {
            mailError.textContent = hasFullWidth ? "※全角文字が含まれています" : "※正しいメール形式で入力してください";
            mailError.style.display = "block";
            mailInput.style.borderColor = "red";
        } else {
            mailError.style.display = "none";
            mailInput.style.borderColor = "#81c784";
        }
    };

    // --- 2. パスワードリアルタイムバリデーション ---
    const validatePassword = () => {
        if (passInput.value === "") {
            passError.style.display = "none";
            passInput.style.borderColor = "#ddd";
        } else if (!passPattern.test(passInput.value) || passInput.value.length < 8) {
            passError.textContent = "※半角英数字8文字以上必要です";
            passError.style.display = "block";
            passInput.style.borderColor = "red";
        } else {
            passError.style.display = "none";
            passInput.style.borderColor = "#81c784";
        }
        checkMatch();
    };

    const checkMatch = () => {
        if (confirmInput.value === "") {
            confirmError.style.display = "none";
            confirmInput.style.borderColor = "#ddd";
        } else if (passInput.value !== confirmInput.value) {
            confirmError.style.display = "block";
            confirmInput.style.borderColor = "red";
        } else {
            confirmError.style.display = "none";
            confirmInput.style.borderColor = "#81c784";
        }
    };

    // イベントリスナー
    mailInput.addEventListener("input", validateMail);
    passInput.addEventListener("input", validatePassword);
    confirmInput.addEventListener("input", checkMatch);

    // --- 3. パスワード表示切り替え ---
    function setupPasswordToggle(toggleId, inputId) {
        const toggle = document.getElementById(toggleId);
        const input = document.getElementById(inputId);

        toggle.addEventListener('click', function() {
            const isPassword = input.getAttribute('type') === 'password';
            input.setAttribute('type', isPassword ? 'text' : 'password');
            this.textContent = isPassword ? '🙈' : '👁️';
            this.style.opacity = isPassword ? "0.5" : "1";
        });
    }

    setupPasswordToggle('togglePass', 'passInput');
    setupPasswordToggle('toggleConfirmPass', 'confirmPassInput');

    // --- 4. 送信時最終チェック ---
    form.addEventListener("submit", (e) => {
        // メールチェック
        const hasFullWidthMail = /[^\x01-\x7E]/.test(mailInput.value);
        if (hasFullWidthMail || !emailPattern.test(mailInput.value)) {
            alert("メールアドレスを正しく入力してください。");
            e.preventDefault();
            return;
        }

        // パスワードチェック
        if (!passPattern.test(passInput.value) || passInput.value.length < 8) {
            alert("パスワードは半角英数字8文字以上で入力してください。");
            e.preventDefault();
            return;
        }
        if (passInput.value !== confirmInput.value) {
            alert("パスワードが一致しません。");
            e.preventDefault();
        }
    });
});
</script>

<%@ include file="../../footer.html" %>
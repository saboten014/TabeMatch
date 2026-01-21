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
            <div class="alert-danger"><%= error %></div>
        <% } %>

        <form action="UserProfile.action" method="post">
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
                        <input type="email" name="userMail" value="<%= user.getUserId() %>" required class="input-field">
                    </td>
                </tr>
                <tr>
                    <th>新しいパスワード</th>
                    <td>
                        <div style="position: relative; display: flex; align-items: center;">
                            <input type="password" name="password" id="passInput" value="<%= user.getPassword() %>" required class="input-field" style="padding-right: 45px;">
                            <span id="togglePass" style="position: absolute; right: 12px; cursor: pointer; font-size: 1.2em; user-select: none;">👁</span>
                        </div>
                        <p style="font-size: 11px; color: #888; margin-top: 5px;">※変更しない場合も入力してください</p>
                    </td>
                </tr>
                <tr>
                    <th>パスワード(確認)</th>
                    <td>
                        <div style="position: relative; display: flex; align-items: center;">
                            <input type="password" name="confirmPassword" id="confirmPassInput" value="<%= user.getPassword() %>" required class="input-field" style="padding-right: 45px;">
                            <span id="toggleConfirmPass" style="position: absolute; right: 12px; cursor: pointer; font-size: 1.2em; user-select: none;">👁</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>アレルギー</th>
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

<%-- パスワード表示切り替えのスクリプト --%>
<script>
    function setupPasswordToggle(toggleId, inputId) {
        const toggle = document.getElementById(toggleId);
        const input = document.getElementById(inputId);

        toggle.addEventListener('click', function() {
            // password と text を切り替える
            const isPassword = input.getAttribute('type') === 'password';
            input.setAttribute('type', isPassword ? 'text' : 'password');
            // アイコンの透明度を変えるなどの演出（任意）
            this.style.opacity = isPassword ? "0.5" : "1";
        });
    }

    // 両方の入力欄に適用
    setupPasswordToggle('togglePass', 'passInput');
    setupPasswordToggle('toggleConfirmPass', 'confirmPassInput');
</script>

<%@ include file="../../footer.html" %>
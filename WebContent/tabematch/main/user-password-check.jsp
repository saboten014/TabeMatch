<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ include file="../../header.html" %>

<%
    Users loginUser = (Users) session.getAttribute("user");
    String userName = (loginUser != null) ? loginUser.getUserName() : "ゲスト";
%>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_prof_v.css">
<title>セキュリティ</title>

<div class="container">
    <h2 class="text-center">セキュリティ確認</h2>

    <div class="card" style="max-width: 500px; margin: 0 auto;">
        <div class="card-body" style="text-align: center;">
            <div style="margin-bottom: 20px;">
                <span style="font-size: 40px;">🔒</span>
            </div>
            <p style="color: #666; margin-bottom: 25px; line-height: 1.6;">
                <strong><%= userName %></strong> さんの情報を守るため、<br>
                現在のパスワードを入力してください。
            </p>

            <% String error = (String)request.getAttribute("errorMessage"); %>
            <% if (error != null) { %>
                <div class="alert-danger" style="margin-bottom: 20px; padding: 10px; border-radius: 10px; background-color: #fff1f0; color: #e57373; border: 1px solid #ffcdd2;">
                    <%= error %>
                </div>
            <% } %>

            <form action="UserProfile.action" method="post">
                <input type="hidden" name="mode" value="auth">

                <div style="margin-bottom: 30px; position: relative; display: flex; align-items: center;">
                    <input type="password" name="password" id="currentPassInput" placeholder="現在のパスワード" required
                           style="width: 100%; padding: 15px; padding-right: 45px; border-radius: 15px; border: 2px solid #e8f5e9; font-size: 16px; outline: none; transition: border-color 0.3s;"
                           onfocus="this.style.borderColor='#81c784'" onblur="this.style.borderColor='#e8f5e9'">

                    <%-- アイコン部分を id="toggleCurrentPass" で制御 --%>
                    <span id="toggleCurrentPass" style="position: absolute; right: 15px; cursor: pointer; font-size: 1.2em; user-select: none;">👁️</span>
                </div>

                <div class="btn" style="display: flex; flex-direction: column; gap: 10px;">
                    <button type="submit" class="btn-hensyu" style="border: none; width: 100%; cursor: pointer;">
                        次へ進む
                    </button>
                    <a href="UserProfileView.action" class="btn-modoru" style="width: 100%; box-sizing: border-box; text-align: center; text-decoration: none; display: block;">
                        キャンセル
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const toggle = document.getElementById('toggleCurrentPass');
        const input = document.getElementById('currentPassInput');

        if (toggle && input) {
            toggle.addEventListener('click', function() {
                // type属性の切り替え
                const isPassword = input.getAttribute('type') === 'password';
                input.setAttribute('type', isPassword ? 'text' : 'password');

                // アイコンの見た目を切り替え
                // 👁️ (表示中) ↔️ 🙈 (隠し中)
                this.textContent = isPassword ? '🙈' : '👁️';

                // 少し色を変えて「有効化されている感」を出す
                this.style.opacity = isPassword ? '0.5' : '1';
            });
        }
    });
</script>
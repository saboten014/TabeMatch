<%@page pageEncoding="UTF-8" %>

<%!

// ★★★ 修正箇所1: contextPathを宣言タグ（サーブレットのインスタンス変数）として定義 ★★★

    String contextPath;

%>

<%

    // ★★★ 修正箇所2: スクリプトレット内でインスタンス変数に値を代入 ★★★

    contextPath = request.getContextPath();



    // フォーム送信先となるActionのパス

    String actionPath = contextPath + "/tabematch/UserPassUpdate.action";

    Users user = (Users) session.getAttribute("user");

    String inputEmail = (String) request.getAttribute("newEmail");
    String currentEmail = "";

    if (inputEmail != null) {
        currentEmail = inputEmail; // エラーで戻ってきた時の値を保持
    } else if (user != null) {
        currentEmail = user.getUserId(); // 初回表示時はDBの値を表示
    }



    // Actionから設定されたメッセージを取得

    String errorMessage = (String) request.getAttribute("errorMessage");

    String successMessage = (String) request.getAttribute("successMessage");

%>

<%@include file="../../header.html" %>

<%@include file="/tabematch/main/user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= contextPath %>/css/password-change.css">

<style>
/* かわいくするための追加デザイン */
.form-container {
    border-radius: 20px !important;
    box-shadow: 0 8px 20px rgba(0,0,0,0.1) !important;
    border: 2px solid #e8f5e9 !important;
    max-width: 500px;
    margin: 40px auto;
    padding: 30px;
    background: #fff;
}
.section-title {
    font-size: 0.95em;
    color: #4CAF50;
    margin-top: 25px;
    margin-bottom: 10px;
    font-weight: bold;
    border-left: 5px solid #4CAF50;
    padding-left: 10px;
}
.input-hint {
    font-size: 0.8em;
    color: #888;
    margin-bottom: 8px;
}
.confirm-box {
    background-color: #fffde7;
    padding: 20px;
    border-radius: 15px;
    margin-top: 30px;
    border: 1px solid #fff59d;
}
hr {
    border: 0;
    border-top: 1px dashed #c8e6c9;
    margin: 25px 0;
}
button {
    width: 100%;
    padding: 15px;
    border-radius: 30px;
    border: none;
    background: linear-gradient(135deg, #66bb6a, #43a047);
    color: white;
    font-weight: bold;
    font-size: 1.1em;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(76, 175, 80, 0.3);
}
</style>

<body>

<div class="main-content-wrapper">
    <div class="form-container">
        <h2 style="text-align: center; color: #2e7d32; margin-bottom: 10px;">✨ アカウント設定</h2>
        <p style="text-align: center; font-size: 0.85em; color: #666; margin-bottom: 30px;">
            メールアドレスやパスワードを変更できます☘️
        </p>

        <%-- メッセージの表示 --%>
        <% if (errorMessage != null) { %>
            <p class="error" style="color: #ff5252; text-align: center; font-weight: bold;">🚨 <%= errorMessage %></p>
        <% } %>
        <% if (successMessage != null) { %>
            <p class="success" style="color: #4caf50; text-align: center; font-weight: bold;">✅ <%= successMessage %></p>
        <% } %>

        <form action="<%= actionPath %>" method="post">

            <div class="section-title">メールアドレス</div>
            <p class="input-hint">現在のアドレスが表示されています</p>
            <input type="email" id="newEmail" name="newEmail" value="<%= currentEmail %>" required
                   style="width:100%; padding:10px; border-radius:10px; border:1px solid #ddd;">

            <hr>

            <div class="section-title">パスワード変更</div>
            <p class="input-hint">変更しない場合は空欄のままでOK！</p>

            <label for="newPassword" style="font-size: 0.9em; display:block; margin-top:10px;">新しいパスワード:</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="新しいパスワードを入力"
                   style="width:100%; padding:10px; border-radius:10px; border:1px solid #ddd;">

            <label for="confirmPassword" style="font-size: 0.9em; display:block; margin-top:10px;">新しいパスワード（確認）:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="もう一度入力してね"
                   style="width:100%; padding:10px; border-radius:10px; border:1px solid #ddd;">

            <div class="confirm-box">
                <label for="currentPassword" style="color: #f57f17; font-weight: bold; display: block;">
                    現在のパスワード <span style="color:red;">*</span>
                </label>
                <p class="input-hint">保存するには現在のパスワードを入力してください</p>
                <input type="password" id="currentPassword" name="currentPassword" required
                       style="width:100%; padding:10px; border-radius:10px; border:2px solid #fff176;">
            </div>

            <div style="margin-top: 30px;">
                <button type="submit">設定を保存する</button>
            </div>
        </form>
    </div>
</div>

<%@include file="../../footer.html" %>
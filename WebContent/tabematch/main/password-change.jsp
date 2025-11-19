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

    // Actionから設定されたメッセージを取得
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<%@include file="../../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>

<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/password-change.css">

<body>

<div class="main-content-wrapper">
    <div class="form-container">
        <h2>🔑 パスワード変更</h2>

        <%-- エラーメッセージの表示 --%>
        <% if (errorMessage != null) { %>
            <p class="error">🚨 <%= errorMessage %></p>
        <% } %>

        <%-- 成功メッセージの表示 --%>
        <% if (successMessage != null) { %>
            <p class="success">✅ <%= successMessage %></p>
        <% } %>

        <form action="<%= actionPath %>" method="post">

            <label for="currentPassword">現在のパスワード:</label>
            <input type="password" id="currentPassword" name="currentPassword" required>

            <label for="newPassword">新しいパスワード:</label>
            <input type="password" id="newPassword" name="newPassword" required>

            <label for="confirmPassword">新しいパスワード（確認）:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>

            <button type="submit">パスワードを変更する</button>
        </form>
    </div>
</div>

<%@include file="../../footer.html" %>
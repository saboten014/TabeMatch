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

<style>
    /* ------------------------------------------- */
    /* メニューバーとの重なり解消のためのCSS */
    /* ------------------------------------------- */
    body {
        font-family: sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 0;
        /* メニューバーの高さ＋余白 (約70pxを想定) */
        padding-top: 70px;
    }

    /* フォームの中央配置用コンテナ */
    .main-content-wrapper {
        display: flex; /* Flexboxで中央寄せを再適用 */
        justify-content: center;
        align-items: flex-start; /* フォームを上部に寄せる */
        /* メニューバーの高さ70pxを除いた画面の高さいっぱいに広げる */
        min-height: calc(100vh - 70px);
        padding: 20px 0; /* 上下の余白 */
    }

    .form-container {
        width: 400px;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    h2 { text-align: center; color: #333; margin-bottom: 20px; }
    label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
    input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }
    button {
        width: 100%;
        padding: 12px;
        margin-top: 30px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
    }
    button:hover { background-color: #45a049; }
    .error { color: #D32F2F; text-align: center; margin-bottom: 15px; border: 1px solid #FFCDD2; padding: 10px; background-color: #FFEBEE; border-radius: 5px; }
    .success { color: #388E3C; text-align: center; margin-bottom: 15px; border: 1px solid #C8E6C9; padding: 10px; background-color: #E8F5E9; border-radius: 5px; }
</style>
</head>
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
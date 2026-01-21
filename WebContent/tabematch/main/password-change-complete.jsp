<%@page pageEncoding="UTF-8" %>
<%
    // 変数定義
    String contextPath = request.getContextPath();
    // ログアウト処理を行うActionへ飛ばす
    String logoutPath = contextPath + "/tabematch.main/Logout.action";
%>

<%@include file="../../header.html" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
    body {
        font-family: 'Kosugi Maru', sans-serif;
        background-color: #f0f9f0;
        margin: 0;
    }
    .complete-container {
        width: 90%;
        max-width: 550px;
        margin: 80px auto;
        padding: 40px;
        background-color: #ffffff;
        border-radius: 25px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        text-align: center;
        border: 2px solid #e8f5e9;
    }
    .success-icon {
        font-size: 4em;
        margin-bottom: 10px;
        display: inline-block;
        background: linear-gradient(135deg, #66bb6a, #43a047);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }
    .complete-title {
        font-size: 1.8em;
        color: #2e7d32;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .complete-message {
        font-size: 1.05em;
        color: #666;
        line-height: 1.8;
        margin-bottom: 20px;
    }
    .info-box {
        background-color: #f1f8e9;
        border-radius: 15px;
        padding: 20px;
        margin: 20px 0;
        text-align: left;
        border: 1px dashed #a5d6a7;
    }
    .info-box h3 {
        color: #388e3c;
        margin-top: 0;
        font-size: 1.1em;
    }
    .info-box ul {
        color: #555;
        line-height: 1.8;
        margin: 10px 0 0 0;
        padding-left: 20px;
        font-size: 0.9em;
    }
    /* 注意メッセージ：自動遷移を削除したため「お願い」のトーンに変更 */
    .re-login-notice {
        color: #f57f17;
        font-weight: bold;
        font-size: 0.95em;
        margin-top: 25px;
        padding: 12px;
        background-color: #fffde7;
        border-radius: 10px;
        border: 1px solid #ffe082;
    }
    .btn-logout {
        display: inline-block;
        width: 100%;
        max-width: 300px;
        margin-top: 20px;
        padding: 16px 0;
        background: linear-gradient(135deg, #66bb6a, #43a047);
        color: white !important;
        text-decoration: none;
        border-radius: 35px;
        font-weight: bold;
        font-size: 1.1em;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        border: none;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .btn-logout:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(76, 175, 80, 0.4);
    }
</style>

<div class="complete-container">
    <div class="success-icon">✨</div>
    <h1 class="complete-title">設定を保存しました</h1>

    <p class="complete-message">
        アカウント情報の変更が正常に完了しました。<br>
        セキュリティ保護のため、一度ログインし直してください☘️
    </p>

    <div class="info-box">
        <h3>💡 これからのログインについて</h3>
        <ul>
            <li>メールアドレスを変更した方は、<b>新しいアドレス</b>で。</li>
            <li>パスワードを変更した方は、<b>新しいパスワード</b>で。</li>
            <li>店舗情報（shop_mail）も一緒に更新されています！</li>
        </ul>
    </div>

    <div class="re-login-notice">
        🔑 準備ができたら、下のボタンからログインしてください。
    </div>

    <a href="<%= logoutPath %>" class="btn-logout">
        再ログインする
    </a>
</div>

<%@include file="../../footer.html" %>
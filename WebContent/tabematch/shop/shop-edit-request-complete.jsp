<%@page pageEncoding="UTF-8" %>
<%@include file="../../header.html" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
.complete-container {
    width: 90%;
    max-width: 550px;
    margin: 100px auto;
    padding: 40px;
    border: 2px solid #e8f5e9;
    border-radius: 25px;
    background-color: #ffffff;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
    text-align: center;
    font-family: 'Kosugi Maru', sans-serif;
}
.success-icon {
    font-size: 4.5em;
    background: linear-gradient(135deg, #66bb6a, #43a047);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 15px;
    display: inline-block;
}
.complete-title {
    font-size: 1.8em;
    color: #2e7d32;
    font-weight: bold;
    margin-bottom: 15px;
}
.complete-message {
    font-size: 1.1em;
    color: #666;
    line-height: 1.8;
    margin-bottom: 30px;
}
.info-box {
    background-color: #f1f8e9;
    border-radius: 15px;
    padding: 25px;
    margin: 25px 0;
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
    line-height: 2;
    margin: 10px 0 0 0;
    padding-left: 20px;
    font-size: 0.95em;
}
.btn-login {
    display: inline-block;
    width: 100%;
    max-width: 300px;
    padding: 15px 0;
    background: linear-gradient(135deg, #66bb6a, #43a047);
    color: white !important;
    text-decoration: none;
    border-radius: 30px;
    font-size: 1.1em;
    font-weight: bold;
    transition: all 0.3s;
    box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
    border: none;
}
.btn-login:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(76, 175, 80, 0.3);
    opacity: 0.9;
}
</style>

<div class="complete-container">
    <div class="success-icon">✨</div>

    <h1 class="complete-title">設定を保存しました</h1>

    <p class="complete-message">
        アカウント情報の変更が正常に完了しました。<br>
        安全のため一度ログアウトしましたので、再ログインをお願いします☘️
    </p>

    <div class="info-box">
        <h3>💡 これからのログインについて</h3>
        <ul>
            <li>メールアドレスを変更した方は、<b>新しいアドレス</b>を入力してください。</li>
            <li>パスワードを変更した方は、<b>新しいパスワード</b>を入力してください。</li>
            <li>店舗情報のメールアドレス（shop_mail）も連動して更新されています！</li>
        </ul>
    </div>

    <div style="margin-top: 40px;">
        <a href="${pageContext.request.contextPath}/tabematch/login.jsp" class="btn-login">
            ログイン画面へ
        </a>
    </div>
</div>

<%@include file="../../footer.html" %>
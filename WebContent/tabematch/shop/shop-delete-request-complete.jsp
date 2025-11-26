<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="../main/shop_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
.complete-container {
    width: 80%;
    max-width: 700px;
    margin: 80px auto;
    padding: 50px;
    border: 2px solid #FF9800;
    border-radius: 15px;
    background-color: #fff8e1;
    box-shadow: 0 6px 15px rgba(0,0,0,0.1);
    text-align: center;
    font-family: 'Kosugi Maru', sans-serif;
}
.warning-icon {
    font-size: 5em;
    color: #FF9800;
    margin-bottom: 20px;
}
.complete-title {
    font-size: 2em;
    color: #E65100;
    font-weight: bold;
    margin-bottom: 20px;
}
.complete-message {
    font-size: 1.2em;
    color: #333;
    line-height: 1.8;
    margin-bottom: 30px;
}
.info-box {
    background-color: #ffffff;
    border: 1px solid #FF9800;
    border-radius: 10px;
    padding: 20px;
    margin: 30px 0;
    text-align: left;
}
.info-box h3 {
    color: #E65100;
    margin-top: 0;
}
.info-box ul {
    color: #555;
    line-height: 1.8;
}
.attention-box {
    background-color: #ffebee;
    border: 2px solid #F44336;
    border-radius: 10px;
    padding: 20px;
    margin: 30px 0;
    text-align: left;
}
.attention-box h3 {
    color: #D32F2F;
    margin-top: 0;
}
.attention-box p {
    color: #721c24;
    line-height: 1.6;
}
.btn-back {
    display: inline-block;
    padding: 15px 40px;
    background-color: #FF9800;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-size: 1.1em;
    font-weight: bold;
    transition: all 0.3s;
}
.btn-back:hover {
    background-color: #F57C00;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}
</style>

<div class="complete-container">
    <div class="warning-icon">📮</div>

    <h1 class="complete-title">削除リクエストを送信しました</h1>

    <p class="complete-message">
        店舗削除リクエストが正常に送信されました。<br>
        管理者による確認をお待ちください。
    </p>

    <div class="info-box">
        <h3>📋 今後の流れ</h3>
        <ul>
            <li>管理者がリクエスト内容を確認します</li>
            <li>承認された場合、店舗情報とアカウントが削除されます</li>
            <li>却下された場合、却下理由が通知されます</li>
            <li>処理結果は、登録メールアドレスに通知されます</li>
        </ul>
    </div>

    <div class="attention-box">
        <h3>⚠️ ご注意</h3>
        <p>
            <strong>削除が承認されると、このアカウントではログインできなくなります。</strong><br>
            削除前に必要なデータがあれば、今のうちにバックアップを取ることをお勧めします。
        </p>
    </div>

    <a href="${pageContext.request.contextPath}/tabematch/shop/ShopProfile.action" class="btn-back">
        店舗プロフィールに戻る
    </a>
</div>

<%@include file="../../footer.html" %>
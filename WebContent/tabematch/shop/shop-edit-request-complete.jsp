<%@page pageEncoding="UTF-8" %>
<%@include file="../../header.html" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
/* フェードインアニメーション */
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

body {
    background-color: #f0f7f0; /* 全体になじむ淡いグリーン */
    margin: 0;
}

.complete-container {
    width: 90%;
    max-width: 600px;
    margin: 100px auto;
    padding: 50px 40px;
    border: none;
    border-radius: 30px;
    background: #ffffff;
    /* 柔らかい2重の影で立体感を出す */
    box-shadow: 0 20px 40px rgba(0,0,0,0.05), 0 1px 3px rgba(0,0,0,0.02);
    text-align: center;
    font-family: 'Kosugi Maru', sans-serif;
    animation: fadeInUp 0.8s ease-out; /* ふわっと表示 */
}

.success-icon-wrapper {
    display: inline-block;
    width: 100px;
    height: 100px;
    line-height: 100px;
    background: #f1f8e9;
    border-radius: 50%;
    margin-bottom: 25px;
    animation: bounce 2s infinite ease-in-out; /* ひょこひょこ動く */
}

.success-icon {
    font-size: 3.5em;
    display: block;
}

.complete-title {
    font-size: 2em;
    color: #2e7d32;
    font-weight: bold;
    margin-bottom: 20px;
    letter-spacing: 0.05em;
}

.complete-message {
    font-size: 1.15em;
    color: #546e7a;
    line-height: 1.8;
    margin-bottom: 35px;
}

.info-box {
    background: linear-gradient(145deg, #fffde7, #fff9c4); /* わずかなグラデーション */
    border-radius: 20px;
    padding: 30px;
    margin: 30px 0;
    text-align: left;
    border-left: 6px solid #fbc02d; /* 左側に太めのアクセント */
    box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
}

.info-box h3 {
    color: #f57f17;
    margin-top: 0;
    font-size: 1.2em;
    display: flex;
    align-items: center;
}

.info-box h3::before {
    content: "💡";
    margin-right: 10px;
}

.info-box ul {
    list-style: none;
    padding: 0;
    margin: 15px 0 0 0;
}

.info-box li {
    color: #607d8b;
    line-height: 2;
    font-size: 1em;
    position: relative;
    padding-left: 28px;
    margin-bottom: 8px;
}

.info-box li::before {
    content: "☘️";
    position: absolute;
    left: 0;
    top: 0;
}

.btn-wrapper {
    margin-top: 45px;
}

.btn-back {
    display: inline-block;
    width: 100%;
    max-width: 320px;
    padding: 18px 0;
    /* より鮮やかなグリーングラデーション */
    background: linear-gradient(135deg, #81c784, #4caf50);
    color: white !important;
    text-decoration: none;
    border-radius: 50px;
    font-size: 1.2em;
    font-weight: bold;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    box-shadow: 0 8px 20px rgba(76, 175, 80, 0.3);
    border: none;
}

.btn-back:hover {
    transform: translateY(-5px) scale(1.02);
    box-shadow: 0 12px 25px rgba(76, 175, 80, 0.4);
    opacity: 0.95;
}

/* スマホ対応 */
@media (max-width: 480px) {
    .complete-container {
        width: 85%;
        padding: 40px 20px;
    }
    .complete-title {
        font-size: 1.5em;
    }
}
</style>

<div class="complete-container">
    <div class="success-icon-wrapper">
        <span class="success-icon">✉️</span>
    </div>

    <h1 class="complete-title">送信完了しました！</h1>

    <p class="complete-message">
        店舗情報の編集リクエストを承りました。<br>
        管理者が内容を確認後、速やかに反映いたします☘️
    </p>

    <div class="info-box">
        <h3>今後の流れについて</h3>
        <ul>
            <li>管理者が内容を確認し、順次反映いたします。</li>
            <li>反映完了まで現在の店舗情報は変更されません。</li>
            <li>完了後、ご登録メールアドレスへ通知いたします。</li>
        </ul>
    </div>

    <div class="btn-wrapper">
        <a href="${pageContext.request.contextPath}/tabematch/shop/ShopProfile.action" class="btn-back">
            マイページへ戻る
        </a>
    </div>
</div>

<%@include file="../../footer.html" %>
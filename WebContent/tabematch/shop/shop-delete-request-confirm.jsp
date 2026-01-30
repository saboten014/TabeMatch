<%@page pageEncoding="UTF-8" %>
<%@page import="bean.Shop"%>

<%@include file="../../header.html" %>
<%@include file="../main/shop_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<%
    Shop shop = (Shop) request.getAttribute("shop");
    if (shop == null) {
        response.sendRedirect(request.getContextPath() + "/tabematch/shop/ShopProfile.action");
        return;
    }
%>

<style>
.delete-confirm-container {
	margin-top: 100px;
    width: 80%;
    max-width: 700px;
    margin: 100px auto;
    padding: 40px;
    border: 2px solid #F44336;
    border-radius: 15px;
    background-color: #fff5f5;
    box-shadow: 0 6px 15px rgba(0,0,0,0.1);
    font-family: 'Kosugi Maru', sans-serif;

}
.warning-icon {
    text-align: center;
    font-size: 5em;
    color: #F44336;
    margin-bottom: 20px;
}
.page-title {
    text-align: center;
    font-size: 2em;
    color: #F44336;
    font-weight: bold;
    margin-bottom: 30px;
}
.warning-box {
    background-color: #ffe6e6;
    border: 2px solid #F44336;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 30px;
}
.warning-box h3 {
    color: #D32F2F;
    margin-top: 0;
}
.warning-box ul {
    color: #721c24;
    line-height: 1.8;
}
.shop-info-box {
    background-color: #ffffff;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 30px;
}
.shop-info-box h3 {
    color: #333;
    margin-top: 0;
    border-bottom: 2px solid #ddd;
    padding-bottom: 10px;
}
.info-row {
    display: flex;
    padding: 10px 0;
    border-bottom: 1px dashed #ddd;
}
.info-row:last-child {
    border-bottom: none;
}
.info-label {
    font-weight: bold;
    color: #555;
    width: 30%;
}
.info-value {
    color: #333;
    width: 70%;
}
.form-group {
    margin-bottom: 20px;
}
.form-group label {
    display: block;
    font-weight: bold;
    color: #333;
    margin-bottom: 8px;
    font-size: 1.1em;
}
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
    font-size: 1em;
    resize: vertical;
    height: 120px;
}
.required {
    color: #F44336;
    font-weight: bold;
}
.button-section {
    margin-top: 30px;
    display: flex;
    justify-content: center;
    gap: 15px;
}
.btn {
    padding: 12px 30px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
    font-size: 1.1em;
    transition: all 0.3s;
    border: none;
    cursor: pointer;
}
.btn-delete {
    background-color: #F44336;
    color: white;
}
.btn-delete:hover {
    background-color: #D32F2F;
    transform: translateY(-2px);
}
.btn-cancel {
    background-color: #9E9E9E;
    color: white;
}
.btn-cancel:hover {
    background-color: #757575;
    transform: translateY(-2px);
}
.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 20px;
}
</style>

<div class="delete-confirm-container">
    <div class="warning-icon">⚠️</div>

    <h1 class="page-title">店舗削除リクエスト</h1>

    <div class="warning-box">
        <h3>🚨 重要な注意事項</h3>
        <ul>
            <li><strong>この操作は取り消すことができません</strong></li>
            <li>削除されると、店舗情報とアカウントが完全に削除されます</li>
            <li>過去の予約履歴も削除される可能性があります</li>
            <li>管理者による承認後、削除が実行されます</li>
        </ul>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <div class="shop-info-box">
        <h3>削除対象の店舗情報</h3>
        <div class="info-row">
            <div class="info-label">店舗ID:</div>
            <div class="info-value"><%= shop.getShopId() %></div>
        </div>
        <div class="info-row">
            <div class="info-label">店舗名:</div>
            <div class="info-value"><%= shop.getShopName() %></div>
        </div>
        <div class="info-row">
            <div class="info-label">住所:</div>
            <div class="info-value"><%= shop.getShopAddress() %></div>
        </div>
        <div class="info-row">
            <div class="info-label">メールアドレス:</div>
            <div class="info-value"><%= shop.getShopMail() %></div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/tabematch/shop/ShopDeleteRequest.action" method="post">
        <input type="hidden" name="mode" value="submit">

        <div class="form-group">
            <label for="deleteReason">削除理由 <span class="required">*</span></label>
            <textarea id="deleteReason" name="deleteReason" required placeholder="削除を希望する理由を具体的に入力してください（例：閉店のため、サービス終了のため、など）"></textarea>
        </div>

        <div class="button-section">
            <button type="submit" class="btn btn-delete" onclick="return confirm('本当に削除リクエストを送信しますか？この操作は取り消せません。')">削除リクエストを送信</button>
            <a href="${pageContext.request.contextPath}/tabematch/shop/ShopProfile.action" class="btn btn-cancel">キャンセル</a>
        </div>
    </form>
</div>

<%@include file="../../footer.html" %>
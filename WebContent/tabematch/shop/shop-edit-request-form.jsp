<%@page pageEncoding="UTF-8" %>
<%@page import="bean.Shop"%>

<%@include file="../../header.html" %>
<%@include file="../main/shop_menu.jsp" %>


<%
    Shop shop = (Shop) request.getAttribute("shop");
    if (shop == null) {
        response.sendRedirect(request.getContextPath() + "/tabematch/shop/ShopProfile.action");
        return;
    }
%>

<style>
.edit-request-container {
    width: 90%;
    max-width: 900px;
    margin: 40px auto;
    padding: 30px;
    border: 1px solid #4CAF50;
    border-radius: 10px;
    background-color: #ffffff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    font-family: 'Kosugi Maru', sans-serif;
}
.page-header {
    border-bottom: 3px solid #4CAF50;
    padding-bottom: 15px;
    margin-bottom: 25px;
}
.page-title {
    font-size: 2em;
    font-weight: bold;
    color: #333;
}
.notice-box {
    background-color: #fff3cd;
    border: 1px solid #ffc107;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 25px;
}
.notice-box h3 {
    color: #856404;
    margin-top: 0;
}
.form-group {
    margin-bottom: 20px;
}
.form-group label {
    display: block;
    font-weight: bold;
    color: #4CAF50;
    margin-bottom: 5px;
    font-size: 1.1em;
}
.form-group input[type="text"],
.form-group input[type="url"],
.form-group input[type="tel"],
.form-group input[type="number"],
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
    font-size: 1em;
}
.form-group textarea {
    resize: vertical;
    height: 100px;
}
.required {
    color: #F44336;
    font-weight: bold;
}
.button-section {
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #ddd;
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
.btn-submit {
    background-color: #4CAF50;
    color: white;
}
.btn-submit:hover {
    background-color: #45a049;
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
.edit-request-container {
	margin-top: 100px;
}
body{
	background-color: #e8f8e8;
}

</style>

<div class="edit-request-container">
    <div class="page-header">
        <h1 class="page-title">店舗情報編集リクエスト</h1>
    </div>

    <div class="notice-box">
        <h3>⚠️ ご注意</h3>
        <ul>
            <li>この編集リクエストは、管理者による承認が必要です。</li>
            <li>承認されるまで、現在の店舗情報は変更されません。</li>
            <li>承認/却下の結果は、登録メールアドレスに通知されます。</li>
        </ul>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/tabematch/shop/ShopEditRequest.action" method="post">
        <input type="hidden" name="mode" value="submit">

        <div class="form-group">
            <label for="shopName">店舗名 <span class="required">*</span></label>
            <input type="text" id="shopName" name="shopName" value="<%= shop.getShopName() %>" required maxlength="100">
        </div>

        <div class="form-group">
            <label for="shopAddress">住所 <span class="required">*</span></label>
            <input type="text" id="shopAddress" name="shopAddress" value="<%= shop.getShopAddress() %>" required maxlength="255">
        </div>

        <div class="form-group">
            <label for="shopTel">電話番号 <span class="required">*</span></label>
            <input type="tel" id="shopTel" name="shopTel" value="<%= shop.getShopTel() %>" required maxlength="20">
        </div>

        <div class="form-group">
            <label for="shopUrl">店舗URL</label>
            <input type="url" id="shopUrl" name="shopUrl" value="<%= shop.getShopUrl() != null ? shop.getShopUrl() : "" %>" maxlength="255">
        </div>

        <div class="form-group">
            <label for="shopGenre">ジャンル</label>
            <select id="shopGenre" name="shopGenre">
                <option value="">選択してください</option>
                <option value="和食" <%= "和食".equals(shop.getShopGenre()) ? "selected" : "" %>>和食</option>
                <option value="洋食" <%= "洋食".equals(shop.getShopGenre()) ? "selected" : "" %>>洋食</option>
                <option value="中華" <%= "中華".equals(shop.getShopGenre()) ? "selected" : "" %>>中華</option>
                <option value="イタリアン" <%= "イタリアン".equals(shop.getShopGenre()) ? "selected" : "" %>>イタリアン</option>
                <option value="フレンチ" <%= "フレンチ".equals(shop.getShopGenre()) ? "selected" : "" %>>フレンチ</option>
                <option value="カフェ" <%= "カフェ".equals(shop.getShopGenre()) ? "selected" : "" %>>カフェ</option>
                <option value="居酒屋" <%= "居酒屋".equals(shop.getShopGenre()) ? "selected" : "" %>>居酒屋</option>
                <option value="ラーメン" <%= "ラーメン".equals(shop.getShopGenre()) ? "selected" : "" %>>ラーメン</option>
                <option value="焼肉" <%= "焼肉".equals(shop.getShopGenre()) ? "selected" : "" %>>焼肉</option>
                <option value="その他" <%= "その他".equals(shop.getShopGenre()) ? "selected" : "" %>>その他</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopPrice">価格帯</label>
            <select id="shopPrice" name="shopPrice">
                <option value="">選択してください</option>
                <option value="1000円以下" <%= "1000円以下".equals(shop.getShopPrice()) ? "selected" : "" %>>1000円以下</option>
                <option value="1000円～2000円" <%= "1000円～2000円".equals(shop.getShopPrice()) ? "selected" : "" %>>1000円～2000円</option>
                <option value="2000円～3000円" <%= "2000円～3000円".equals(shop.getShopPrice()) ? "selected" : "" %>>2000円～3000円</option>
                <option value="3000円～5000円" <%= "3000円～5000円".equals(shop.getShopPrice()) ? "selected" : "" %>>3000円～5000円</option>
                <option value="5000円以上" <%= "5000円以上".equals(shop.getShopPrice()) ? "selected" : "" %>>5000円以上</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopPay">決済方法</label>
            <input type="text" id="shopPay" name="shopPay" value="<%= shop.getShopPay() != null ? shop.getShopPay() : "" %>" maxlength="100" placeholder="例: 現金、クレジットカード、電子マネー">
        </div>

        <div class="form-group">
            <label for="shopSeat">座席数</label>
            <input type="number" id="shopSeat" name="shopSeat" value="<%= shop.getShopSeat() != null ? shop.getShopSeat() : "" %>" min="0">
        </div>

        <div class="form-group">
            <label for="shopReserve">予約可否</label>
            <select id="shopReserve" name="shopReserve">
                <option value="可能" <%= "可能".equals(shop.getShopReserve()) ? "selected" : "" %>>可能</option>
                <option value="不可" <%= "不可".equals(shop.getShopReserve()) ? "selected" : "" %>>不可</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopAllergy">アレルギー対応</label>
            <textarea id="shopAllergy" name="shopAllergy" placeholder="対応可能なアレルギー情報を入力してください"><%= shop.getShopAllergy() != null ? shop.getShopAllergy() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="requestNote">変更理由・備考</label>
            <textarea id="requestNote" name="requestNote" placeholder="編集の理由や管理者への伝達事項があれば入力してください"></textarea>
        </div>

        <div class="button-section">
            <button type="submit" class="btn btn-submit">編集リクエストを送信</button>
            <a href="${pageContext.request.contextPath}/tabematch/shop/ShopProfile.action" class="btn btn-cancel">キャンセル</a>
        </div>
    </form>
</div>

<%@include file="../../footer.html" %>
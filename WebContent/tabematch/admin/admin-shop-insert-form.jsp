<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

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
.form-group input[type="password"],
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
</style>

<div class="edit-request-container">
    <div class="page-header">
        <!-- ★ タイトルを変更 -->
        <h1 class="page-title">店舗登録</h1>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <!-- ★ 管理者用 店舗登録フォーム -->
    <form action="<%= request.getContextPath() %>/tabematch/admin/AdminShopInsertExecute.action" method="post">

        <div class="form-group">
            <label for="shopId">店舗ID（ログインID）<span class="required">*</span></label>
            <input type="text" id="shopId" name="shopId" required maxlength="30">
        </div>

        <div class="form-group">
            <label for="password">パスワード <span class="required">*</span></label>
            <input type="password" id="password" name="password" required maxlength="50">
        </div>

        <div class="form-group">
            <label for="shopName">店舗名 <span class="required">*</span></label>
            <input type="text" id="shopName" name="shopName" required maxlength="100">
        </div>

        <div class="form-group">
            <label for="shopAddress">住所 <span class="required">*</span></label>
            <input type="text" id="shopAddress" name="shopAddress" required maxlength="255">
        </div>

        <div class="form-group">
            <label for="shopTel">電話番号 <span class="required">*</span></label>
            <input type="tel" id="shopTel" name="shopTel" required maxlength="20">
        </div>

        <div class="form-group">
            <label for="shopUrl">店舗URL</label>
            <input type="url" id="shopUrl" name="shopUrl" maxlength="255">
        </div>

        <div class="form-group">
            <label for="shopGenre">ジャンル</label>
            <select id="shopGenre" name="shopGenre">
                <option value="">選択してください</option>
                <option value="和食">和食</option>
                <option value="洋食">洋食</option>
                <option value="中華">中華</option>
                <option value="イタリアン">イタリアン</option>
                <option value="フレンチ">フレンチ</option>
                <option value="カフェ">カフェ</option>
                <option value="居酒屋">居酒屋</option>
                <option value="ラーメン">ラーメン</option>
                <option value="焼肉">焼肉</option>
                <option value="その他">その他</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopPrice">価格帯</label>
            <select id="shopPrice" name="shopPrice">
                <option value="">選択してください</option>
                <option value="1000円以下">1000円以下</option>
                <option value="1000円～2000円">1000円～2000円</option>
                <option value="2000円～3000円">2000円～3000円</option>
                <option value="3000円～5000円">3000円～5000円</option>
                <option value="5000円以上">5000円以上</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopPay">決済方法</label>
            <input type="text" id="shopPay" name="shopPay" maxlength="100" placeholder="例: 現金、クレジットカード、電子マネー">
        </div>

        <div class="form-group">
            <label for="shopSeat">座席数</label>
            <input type="number" id="shopSeat" name="shopSeat" min="0">
        </div>

        <div class="form-group">
            <label for="shopReserve">予約可否</label>
            <select id="shopReserve" name="shopReserve">
                <option value="可能">可能</option>
                <option value="不可">不可</option>
            </select>
        </div>

        <div class="form-group">
            <label for="shopAllergy">アレルギー対応</label>
            <textarea id="shopAllergy" name="shopAllergy" placeholder="対応可能なアレルギー情報を入力してください"></textarea>
        </div>

        <div class="button-section">
            <!-- ★ ボタンの文言変更 -->
            <button type="submit" class="btn btn-submit">登録</button>
            <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp" class="btn btn-cancel">キャンセル</a>
        </div>

    </form>
</div>

<%@include file="../../footer.html" %>

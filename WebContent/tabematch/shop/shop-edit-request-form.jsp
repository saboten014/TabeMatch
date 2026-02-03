<%@page pageEncoding="UTF-8" %>
<%@page import="bean.Shop, bean.Allergen, java.util.*"%>

<%@include file="../../header.html" %>
<%@include file="../main/shop_menu.jsp" %>

<%
    Shop shop = (Shop) request.getAttribute("shop");
    List<Allergen> allergenMaster = (List<Allergen>) request.getAttribute("allergenMaster");

    Set<String> currentAllergies = new HashSet<String>();
    if (shop != null && shop.getShopAllergy() != null) {
        String[] split = shop.getShopAllergy().replace("、", ",").split(",");
        for (String s : split) {
            if (!s.trim().isEmpty()) {
                currentAllergies.add(s.trim());
            }
        }
    }
%>

<style>
/* 全体の背景となじむように少し柔らかいフォントと色使いに */

body {
  background-color: #e8f8e8;
  }

.edit-container {
    width: 90%;
    max-width: 800px;
    margin: 120px auto 60px;
    padding: 40px;
    border: none;
    border-radius: 20px; /* 角を丸くしてかわいく */
    background: #ffffff;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05); /* ふわっとした影 */
    font-family: 'Hiragino Kaku Gothic ProN', 'Kosugi Maru', sans-serif;
}

h2 {
    color: #2e7d32;
    text-align: center;
    font-size: 1.8em;
    margin-bottom: 10px;
}

.sub-text {
    text-align: center;
    color: #666;
    font-size: 0.9em;
    margin-bottom: 40px;
}

.form-group { margin-bottom: 25px; }

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
    color: #4CAF50;
    font-size: 0.95em;
}

/* 入力フィールドを少し丸く、フォーカス時に色が変わるように */
.form-control {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #e8f5e9;
    border-radius: 12px;
    box-sizing: border-box;
    font-size: 1em;
    transition: border-color 0.3s;
    background-color: #fafafa;
}

.form-control:focus {
    outline: none;
    border-color: #4CAF50;
    background-color: #fff;
}

/* アレルギー選択エリアをカード風に */
.allergy-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
    gap: 12px;
    background: #f9fbf9;
    padding: 20px;
    border-radius: 15px;
    border: 1px dashed #c8e6c9; /* 点線にしてかわいさを演出 */
}

.allergy-item {
    display: flex;
    align-items: center;
    cursor: pointer;
    font-size: 0.9em;
    color: #444;
    padding: 5px;
    transition: transform 0.2s;
}

.allergy-item:hover {
    transform: scale(1.05); /* ホバー時に少し大きく */
}

.allergy-item input {
    margin-right: 10px;
    width: 18px;
    height: 18px;
    accent-color: #4CAF50; /* チェックボックスの色をテーマカラーに */
}

/* 価格帯のチェックボックスグリッド（アレルギーと同じスタイル） */
.price-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 12px;
    background: #f9fbf9;
    padding: 20px;
    border-radius: 15px;
    border: 1px dashed #c8e6c9;
}

.price-item {
    display: flex;
    align-items: center;
    cursor: pointer;
    font-size: 0.9em;
    color: #444;
    padding: 5px;
    transition: transform 0.2s;
}

.price-item:hover {
    transform: scale(1.05);
}

.price-item input {
    margin-right: 10px;
    width: 18px;
    height: 18px;
    accent-color: #4CAF50;
}

/* 送信ボタンをぷっくりしたデザインに */
.btn-submit {
    background: linear-gradient(135deg, #66bb6a, #43a047);
    color: white;
    padding: 15px 50px;
    border: none;
    border-radius: 30px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1.1em;
    box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
    transition: all 0.3s;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
}

.required {
    color: #ff5252;
    margin-left: 3px;
}

.cancel-link {
    display: inline-block;
    margin-top: 20px;
    color: #999;
    text-decoration: none;
    font-size: 0.9em;
}

.cancel-link:hover {
    text-decoration: underline;
}

/* 注意文ボックスのスタイル */
.alert-box {
    background-color: #fff9c4; /* 優しい黄色 */
    border-left: 5px solid #fbc02d; /* 左側のアクセントライン */
    padding: 20px;
    margin-bottom: 30px;
    border-radius: 10px;
    text-align: left;
}

.alert-title {
    font-weight: bold;
    color: #f57f17;
    margin-bottom: 10px;
    font-size: 1.1em;
}

.alert-list {
    margin: 0;
    padding-left: 20px;
    list-style-type: none; /* デフォルトの点を消す */
}

.alert-list li {
    color: #555;
    font-size: 0.95em;
    line-height: 1.6;
    position: relative;
    margin-bottom: 5px;
}

/* 箇条書きの点の代わりに「・」を擬似要素で配置 */
.alert-list li::before {
    content: "・";
    position: absolute;
    left: -15px;
    color: #fbc02d;
    font-weight: bold;
}
</style>

<div class="edit-container">
    <h2>店舗情報編集リクエスト</h2>
    <p class="sub-text">現在の内容を修正して送信してくださいね☘️</p>

    <div class="alert-box">
		<div class="alert-title">⚠️ ご確認ください</div>
		    <ul class="alert-list">
		        <li>この編集リクエストは、管理者による認証が必要です。</li>
		        <li>認証されるまで、現在の店舗情報は更新されません。</li>
		        <li>承認/却下の結果は、ご登録のメールに通知されます。</li>
		    </ul>
		</div>


    <form action="ShopEditRequest.action" method="post">
        <input type="hidden" name="mode" value="submit">

        <div class="form-group">
            <label>店舗名 <span class="required">*</span></label>
            <input type="text" name="shopName" class="form-control" value="<%= shop.getShopName() %>" placeholder="店名を入力" required>
        </div>

        <div class="form-group">
            <label>住所 <span class="required">*</span></label>
            <input type="text" name="shopAddress" class="form-control" value="<%= shop.getShopAddress() %>" placeholder="住所を入力" required>
        </div>

        <div class="form-group">
            <label>電話番号 <span class="required">*</span></label>
            <input type="tel" name="shopTel" class="form-control" value="<%= shop.getShopTel() %>" placeholder="00-0000-0000" required>
        </div>

        <div class="form-group">
            <label>対応食材項目（✅をチェック！）</label>
            <div class="allergy-grid">
                <% if (allergenMaster != null) {
                    for (Allergen a : allergenMaster) {
                        boolean isChecked = currentAllergies.contains(a.getAllergenName());
                %>
                    <label class="allergy-item">
                        <input type="checkbox" name="shopAllergies" value="<%= a.getAllergenName() %>" <%= isChecked ? "checked" : "" %>>
                        <%= a.getAllergenName() %>
                    </label>
                <% } } %>
            </div>
        </div>

        <div class="form-group">
            <label>店舗URL</label>
            <input type="url" name="shopUrl" class="form-control" value="<%= shop.getShopUrl() != null ? shop.getShopUrl() : "" %>" placeholder="https://example.com">
        </div>

        <div style="display: flex; gap: 20px;">
            <div class="form-group" style="flex: 1;">
                <label>ジャンル</label>
                <select name="shopGenre" class="form-control">
                    <% String[] genres = {"和食", "洋食", "中華", "イタリアン", "カフェ", "ラーメン", "居酒屋"};
                       for(String g : genres) { %>
                        <option value="<%= g %>" <%= g.equals(shop.getShopGenre()) ? "selected" : "" %>><%= g %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group" style="flex: 1;">
                <label>予約可否</label>
                <select name="shopReserve" class="form-control">
                    <option value="可能" <%= "可能".equals(shop.getShopReserve()) ? "selected" : "" %>>可能</option>
                    <option value="不可" <%= "不可".equals(shop.getShopReserve()) ? "selected" : "" %>>不可</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label>価格帯 <span class="required">*</span></label>
            <select name="shopPrice" class="form-control" required>
                <option value="">選択してください</option>
                <%
                String[] priceRanges = {"1000円以下", "1000円～2000円", "2000円～3000円", "3000円～5000円", "5000円以上"};
                String currentPrice = (shop != null && shop.getShopPrice() != null) ? shop.getShopPrice() : "";
                for (String price : priceRanges) {
                %>
                    <option value="<%= price %>" <%= price.equals(currentPrice) ? "selected" : "" %>><%= price %></option>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>決済方法 <span class="required">*</span></label>
            <input type="text" name="shopPay" class="form-control"
                   value="<%= shop.getShopPay() != null ? shop.getShopPay() : "" %>"
                   placeholder="例: 現金、クレジットカード、電子マネー" required>
            <small style="color: #666; font-size: 0.85em;">対応している決済方法を入力してください</small>
        </div>

        <div class="form-group">
            <label>座席数</label>
            <input type="number" name="shopSeat" class="form-control" value="<%= shop.getShopSeat() %>" min="0">
        </div>

        <div class="form-group">
            <label>修正理由記入欄</label>
            <textarea name="requestNote" class="form-control" rows="3" placeholder="変更したい理由などがあれば教えてくださいね。"></textarea>
        </div>

        <div style="text-align: center; margin-top: 40px;">
            <button type="submit" class="btn-submit">リクエストを送信する</button><br>
            <a href="ShopProfile.action" class="cancel-link">やっぱりやめる</a>
        </div>
    </form>
</div>

<%@include file="../../footer.html" %>

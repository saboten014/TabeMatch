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
body { background-color: #e8f8e8; }

.edit-container {
    width: 90%;
    max-width: 800px;
    margin: 120px auto 60px;
    padding: 40px;
    border-radius: 20px;
    background: #ffffff;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
    font-family: 'Hiragino Kaku Gothic ProN', 'Kosugi Maru', sans-serif;
}

h2 { color: #2e7d32; text-align: center; font-size: 1.8em; margin-bottom: 10px; }
.sub-text { text-align: center; color: #666; font-size: 0.9em; margin-bottom: 40px; }
.form-group { margin-bottom: 25px; }
.form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #4CAF50; font-size: 0.95em; }

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

.form-control:focus { outline: none; border-color: #4CAF50; background-color: #fff; }

.allergy-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
    gap: 12px;
    background: #f9fbf9;
    padding: 20px;
    border-radius: 15px;
    border: 1px dashed #c8e6c9;
}

.allergy-item { display: flex; align-items: center; cursor: pointer; font-size: 0.9em; color: #444; padding: 5px; transition: transform 0.2s; }
.allergy-item:hover { transform: scale(1.05); }
.allergy-item input { margin-right: 10px; width: 18px; height: 18px; accent-color: #4CAF50; }

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

.btn-submit:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4); }
.required { color: #ff5252; margin-left: 3px; }
.cancel-link { display: inline-block; margin-top: 20px; color: #999; text-decoration: none; font-size: 0.9em; }

.alert-box { background-color: #fff9c4; border-left: 5px solid #fbc02d; padding: 20px; margin-bottom: 30px; border-radius: 10px; }
.alert-title { font-weight: bold; color: #f57f17; margin-bottom: 10px; font-size: 1.1em; }
.alert-list { margin: 0; padding-left: 20px; list-style-type: none; }
.alert-list li::before { content: "・"; position: absolute; left: -15px; color: #fbc02d; font-weight: bold; }
.alert-list li { position: relative; color: #555; font-size: 0.95em; line-height: 1.6; }

.error-text { color: red; font-size: 0.8em; margin-top: 5px; display: none; }
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

    <form id="editForm" action="ShopEditRequest.action" method="post">
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
            <input type="tel" name="shopTel" id="shop_tel" class="form-control" value="<%= shop.getShopTel() %>" placeholder="00-0000-0000" maxlength="13" required>
            <div id="tel-error" class="error-text">※正しい電話番号の形式ではありません</div>
        </div>

        <div class="form-group">
            <label>定休日・営業時間</label>
            <input type="text" name="shopTime" class="form-control"
                   value="<%= shop.getShopTime() != null ? shop.getShopTime() : "" %>"
                   placeholder="例：定休日：火　営業時間：10:00～20:00">
            <small style="color: #666; font-size: 0.85em;">定休日や詳しい営業時間を入力してください☘️</small>
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
            <input type="text" name="shopUrl" id="shop_link" class="form-control" value="<%= shop.getShopUrl() != null ? shop.getShopUrl() : "" %>" placeholder="https://example.com">
            <div id="url-error" class="error-text">※有効なURL形式で入力してください</div>
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

<script>
document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("editForm");
    const telInput = document.getElementById("shop_tel");
    const telError = document.getElementById("tel-error");
    const urlInput = document.getElementById("shop_link");
    const urlError = document.getElementById("url-error");

    const urlPattern = /^https?:\/\/[\w/:%#\$&\?\(\)~\.=\+\-]+$/;

    // --- 電話番号の自動整形 & バリデーション ---
    if (telInput) {
        telInput.addEventListener("input", () => {
            let value = telInput.value.replace(/\D/g, "");
            let formatted = "";
            const len = value.length;

            if (len <= 3) {
                formatted = value;
            } else if (len <= 6) {
                formatted = value.substring(0, 2) + "-" + value.substring(2);
            } else if (len <= 10) {
                if (value.startsWith("03") || value.startsWith("06")) {
                    formatted = value.substring(0, 2) + "-" + value.substring(2, 6) + "-" + value.substring(6);
                } else {
                    formatted = value.substring(0, 3) + "-" + value.substring(3, 6) + "-" + value.substring(6);
                }
            } else {
                formatted = value.substring(0, 3) + "-" + value.substring(3, 7) + "-" + value.substring(7, 11);
            }
            telInput.value = formatted;

            if (telError) {
                if (len > 0 && len !== 10 && len !== 11) {
                    telError.style.display = "block";
                    telInput.style.borderColor = "red";
                } else {
                    telError.style.display = "none";
                    telInput.style.borderColor = (len === 0) ? "" : "#4CAF50";
                }
            }
        });
    }

    // --- URL バリデーション ---
    if (urlInput) {
        urlInput.addEventListener("input", () => {
            const value = urlInput.value;
            const hasFullWidth = /[^\x01-\x7E]/.test(value);

            if (value === "") {
                urlError.style.display = "none";
                urlInput.style.borderColor = "";
            } else if (hasFullWidth || !urlPattern.test(value)) {
                urlError.textContent = hasFullWidth ? "※全角文字は使用できません" : "※http:// または https:// から始まる形式で入力してください";
                urlError.style.display = "block";
                urlInput.style.borderColor = "red";
            } else {
                urlError.style.display = "none";
                urlInput.style.borderColor = "#4CAF50";
            }
        });
    }

    // --- 送信時最終チェック ---
    if (form) {
        form.addEventListener("submit", (e) => {
            // 電話番号チェック
            const telLen = telInput.value.replace(/\D/g, "").length;
            if (telLen > 0 && telLen !== 10 && telLen !== 11) {
                alert("電話番号を正しく入力してください（10桁または11桁）。");
                e.preventDefault();
                return;
            }

            // URLチェック
            if (urlInput && urlInput.value !== "") {
                const hasFullWidth = /[^\x01-\x7E]/.test(urlInput.value);
                if (hasFullWidth || !urlPattern.test(urlInput.value)) {
                    alert("店舗URLを正しく入力してください。");
                    e.preventDefault();
                    return;
                }
            }
        });
    }
});
</script>

<%@include file="../../footer.html" %>
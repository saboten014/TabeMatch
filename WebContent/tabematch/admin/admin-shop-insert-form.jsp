<%@page pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="dao.AllergenDAO" %>

<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_shop_insert.css">

<div style="height: 50px;"></div> <main class="container"> <h1>店舗登録（管理者用）</h1>

<div class="error-message">
<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
    <p><%= errorMessage %></p>
<%
    }
%>
</div>

<div class="form-container">
    <%-- 画像を扱うため enctype="multipart/form-data" を追加 --%>
    <form action="<%= request.getContextPath() %>/tabematch/admin/AdminShopInsertExecute.action"
          method="post"
          enctype="multipart/form-data">

        <table>
            <tr>
                <td>店名<span class="required">*</span></td>
                <td><input type="text" name="restaurantName" maxlength="100" required></td>
            </tr>

            <tr>
                <td>住所<span class="required">*</span></td>
                <td><input type="text" name="address" maxlength="255" required></td>
            </tr>

            <tr>
                <td>メールアドレス<span class="required">*</span></td>
                <td>
                    <input type="email" name="request_mail" id="request_mail" maxlength="100" required placeholder="example@mail.com">
                    <div id="email-error" class="error-text" style="color: red; font-size: 0.8em; display: none;"></div>
                </td>
            </tr>

            <tr>
                <td>パスワード<span class="required">*</span></td>
                <td>
                    <div style="display: flex; gap: 5px;">
                        <input type="password" name="password" id="admin_password" maxlength="50" required style="flex: 1;">
                        <button type="button" onclick="togglePassword('admin_password', this)" style="white-space: nowrap; font-size: 0.8em;">👁️ 表示</button>
                    </div>
                </td>
            </tr>

            <tr>
                <td>電話番号<span class="required">*</span></td>
                <td>
                    <input type="text" name="number" id="shop_tel" maxlength="13" required placeholder="09012345678">
                    <div id="tel-error" class="error-text" style="color: red; font-size: 0.8em; display: none;"></div>
                    <small>※ハイフンは自動で入力されます</small>
                </td>
            </tr>

            <tr>
                <td>営業日・営業時間<span class="required">*</span></td>
                <td>
                    <input type="text" name="businessHours" maxlength="50" required placeholder="例: 月〜金 11:00-22:00">
                </td>
            </tr>

            <tr>
                <td>HPへのリンク</td>
                <td>
                    <input type="text" name="link" id="shop_link" maxlength="255" placeholder="https://example.com">
                    <div id="url-error" class="error-text" style="color: red; font-size: 0.8em; display: none;"></div>
                </td>
            </tr>

            <tr>
                <td>お店のジャンル<span class="required">*</span></td>
                <td>
                    <select name="genre" required>
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
                </td>
            </tr>

            <tr>
                <td>価格帯</td>
                <td>
                    <select name="priceRange">
                        <option value="">選択してください</option>
                        <option value="1000円以下">1000円以下</option>
                        <option value="1000円〜2000円">1000円〜2000円</option>
                        <option value="2000円〜3000円">2000円〜3000円</option>
                        <option value="3000円〜5000円">3000円〜5000円</option>
                        <option value="5000円以上">5000円以上</option>
                    </select>
                </td>
            </tr>

            <tr>
                <td>決済方法<span class="required">*</span></td>
                <td>
                    <input type="text" name="payment" maxlength="50" required placeholder="例: 現金、クレジットカード">
                </td>
            </tr>

            <tr>
                <td>座席<span class="required">*</span></td>
                <td>
                    <input type="text" name="seat" maxlength="50" required placeholder="例: カウンター5席">
                </td>
            </tr>

            <tr>
                <td>予約の可否<span class="required">*</span></td>
                <td>
                    <input type="radio" name="reservation" value="1" id="res_yes" required>
                    <label for="res_yes">可能</label>
                    <input type="radio" name="reservation" value="2" id="res_no">
                    <label for="res_no">不可</label>
                </td>
            </tr>

            <tr>
                <td>店舗写真</td>
                <td>
                    <div class="file-upload">
                        <label class="file-label">
                            画像を選択
                            <input type="file" name="photo" accept="image/*" class="file-input" multiple>
                        </label>
                        <div id="preview-container" class="preview-area"></div>
                        <div class="file-info"><span class="file-count">未選択</span></div>
                    </div>
                </td>
            </tr>

            <tr>
                <td>アレルギー対応<span class="required">*</span></td>
                <td>
                    <div class="checkbox-grid">
                    <%
                        List<Allergen> allergenList = (List<Allergen>)request.getAttribute("allergenList");
                        if (allergenList == null) {
                            allergenList = new AllergenDAO().getAllAllergens(); // 保険策
                        }
                        for (Allergen allergen : allergenList) {
                    %>
                        <div class="checkbox-item">
                            <input type="checkbox" name="allergyInfo" value="<%= allergen.getAllergenId() %>" id="allergy_<%= allergen.getAllergenId() %>">
                            <label for="allergy_<%= allergen.getAllergenId() %>"><%= allergen.getAllergenName() %></label>
                        </div>
                    <% } %>
                    </div>
                </td>
            </tr>

            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="店舗を登録する" class="btn-submit">
                    <input type="reset" value="クリア" class="btn-reset">
                </td>
            </tr>
        </table>
    </form>
</div>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理画面に戻る</a>
</div>

<script>
// ここに「掲載リクエスト画面」と同じJavaScriptロジックを貼り付けます
document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form");
    const emailInput = document.getElementById("request_mail");
    const emailError = document.getElementById("email-error");
    const telInput = document.getElementById("shop_tel");
    const telError = document.getElementById("tel-error");
    const urlInput = document.getElementById("shop_link");
    const urlError = document.getElementById("url-error");
    const fileInput = document.querySelector(".file-input");
    const container = document.getElementById("preview-container");
    const countLabel = document.querySelector(".file-count");

    const emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    const urlPattern = /^https?:\/\/[\w/:%#\$&\?\(\)~\.=\+\-]+$/;

    // メール
    emailInput.addEventListener("input", () => {
        const hasFullWidth = /[^\x01-\x7E]/.test(emailInput.value);
        if (emailInput.value === "") {
            emailError.style.display = "none";
        } else if (hasFullWidth || !emailPattern.test(emailInput.value)) {
            emailError.textContent = hasFullWidth ? "※全角文字が含まれています" : "※形式が正しくありません";
            emailError.style.display = "block";
        } else {
            emailError.style.display = "none";
        }
    });

    // 電話番号整形
    telInput.addEventListener("input", () => {
        let value = telInput.value.replace(/\D/g, "");
        let formatted = "";
        const len = value.length;
        if (len <= 3) formatted = value;
        else if (len <= 7) formatted = value.substring(0, 3) + "-" + value.substring(3);
        else if (len <= 11) formatted = value.substring(0, 3) + "-" + value.substring(3, 7) + "-" + value.substring(7);
        telInput.value = formatted;
        telError.style.display = (len > 0 && len < 10) ? "block" : "none";
        telError.textContent = "※10桁または11桁で入力してください";
    });

    // 画像プレビュー
    fileInput.addEventListener("change", () => {
        container.innerHTML = "";
        countLabel.textContent = fileInput.files.length + " 枚選択中";
        Array.from(fileInput.files).forEach(file => {
            const reader = new FileReader();
            reader.onload = (e) => {
                const img = document.createElement("img");
                img.src = e.target.result;
                img.style = "width:80px; height:80px; object-fit:cover; margin:5px; border-radius:4px;";
                container.appendChild(img);
            };
            reader.readAsDataURL(file);
        });
    });

    // 送信前チェック
    form.addEventListener("submit", (e) => {
        if (!emailPattern.test(emailInput.value)) {
            alert("メールアドレスが正しくありません。");
            e.preventDefault();
        }
    });
});

function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);
    const isPass = input.type === "password";
    input.type = isPass ? "text" : "password";
    button.textContent = isPass ? "🔒 非表示" : "👁️ 表示";
}
</script>

<%@include file="../../footer.html" %>
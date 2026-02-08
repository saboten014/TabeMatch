<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="bean.Users" %>
<%@page import="dao.AllergenDAO" %>
<%@include file="../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/shop_request.css">

<h1>店舗掲載リクエスト</h1>

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

<p class="description">
    店舗情報を入力してください。承認後、登録したメールアドレスにログイン情報をお送りします。
</p>

<div class="form-container">

<form action="ShopRequestExecute.action"
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
            <td>対応可能食材<span class="required">*</span></td>
            <td>
<%
    AllergenDAO allergenDao = new AllergenDAO();
    List<Allergen> allergenList = allergenDao.getAllAllergens();
%>
                <div class="checkbox-grid">
<%
    for (Allergen allergen : allergenList) {
%>
                    <div class="checkbox-item">
                        <input type="checkbox"
                               name="allergyInfo"
                               value="<%= allergen.getAllergenId() %>"
                               id="allergy_<%= allergen.getAllergenId() %>">
                        <label for="allergy_<%= allergen.getAllergenId() %>">
                            <%= allergen.getAllergenName() %>
                        </label>
                    </div>
<%
    }
%>
                </div>
                <small>対応しているアレルゲンを選択してください</small>
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
            <td>営業日・営業時間<span class="required">*</span></td>
            <td>
                <input type="text" name="businessHours" maxlength="50" required>
                <small>例: 月～金 11:00-22:00、土日祝 10:00-23:00</small>
            </td>
        </tr>

        <tr>
            <td>決済方法<span class="required">*</span></td>
            <td>
                <input type="text" name="payment" maxlength="50" required>
                <small>例: 現金、クレジットカード、電子マネー</small>
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
  <td>店舗写真</td>
  <td>
    <div class="file-upload">
      <label class="file-label">
        画像を選択
        <input type="file" name="photo" accept="image/*" class="file-input" multiple>
      </label>

      <div id="preview-container" class="preview-area"></div>

      <div class="file-info">
        <span class="file-count">未選択</span>
      </div>
      <small>jpg / png などの画像ファイルを選択してください</small>
    </div>
  </td>
</tr>


        <tr>
            <td>価格帯</td>
            <td>
                <select name="priceRange">
                    <option value="">選択してください</option>
                    <option value="1000円以下">1000円以下</option>
                    <option value="1000円～2000円">1000円～2000円</option>
                    <option value="2000円～3000円">2000円～3000円</option>
                    <option value="3000円～5000円">3000円～5000円</option>
                    <option value="5000円以上">5000円以上</option>
                </select>
            </td>
        </tr>

        <tr>
            <td>座席<span class="required">*</span></td>
            <td>
                <input type="text" name="seat" maxlength="50" required>
                <small>例: カウンター5席、テーブル20席</small>
            </td>
        </tr>

        <tr>
            <td>HPへのリンク</td>
            <td><input type="text"
                       name="link"
                       id="shop_link"
                       maxlength="255"
                       placeholder="https://example.com">
                <div id="url-error" class="error-text" style="color: red; font-size: 0.8em; display: none;">
                    ※有効なURL形式（http://〜 または https://〜）で入力してください
                </div>
            </td>
        </tr>

        <tr>
            <td>電話番号<span class="required">*</span></td>
            <td>
                <input type="text"
                       name="number"
                       id="shop_tel"
                       maxlength="13"
                       required
                       placeholder="09012345678"
                       title="電話番号を入力してください">
                <div id="tel-error" class="error-text" style="color: red; font-size: 0.8em; display: none;">
                    ※正しい電話番号の形式ではありません
                </div>
                <small>※ハイフンは自動で入力されます</small>
            </td>
        </tr>
        <tr>
            <td>メールアドレス<span class="required">*</span></td>
            <td>
                <input type="text"
                       name="request_mail"
                       id="request_mail"
                       maxlength="100"
                       required
                       placeholder="example@mail.com"
                       pattern="^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                       title="正しいメールアドレスの形式で入力してください">
                <div id="email-error" class="error-text" style="color: red; font-size: 0.8em; display: none;">
                    ※無効なメールアドレス形式です
                </div>
                <small>※半角英数字で入力してください</small>
            </td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="リクエスト送信">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
</form>
</div>

<div class="back-link">
    <a href="Login.action">← ログイン画面に戻る</a>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
    // --- 1. 要素の取得 ---
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

    // --- 2. 共通パターン ---
    const emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    const urlPattern = /^https?:\/\/[\w/:%#\$&\?\(\)~\.=\+\-]+$/;

    // --- 3. メールアドレス・バリデーション ---
    if (emailInput && emailError) {
        emailInput.addEventListener("input", () => {
            const hasFullWidth = /[^\x01-\x7E]/.test(emailInput.value);
            if (emailInput.value === "") {
                emailError.style.display = "none";
                emailInput.style.borderColor = "";
            } else if (hasFullWidth || !emailPattern.test(emailInput.value)) {
                emailError.textContent = hasFullWidth ? "※全角文字が含まれています" : "※正しいメール形式で入力してください";
                emailError.style.display = "block";
                emailInput.style.borderColor = "red";
            } else {
                emailError.style.display = "none";
                emailInput.style.borderColor = "#99ccff";
            }
        });
    }

    // --- 4. 電話番号の自動整形 ---
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
                    telError.textContent = "※電話番号は10桁または11桁で入力してください";
                    telError.style.display = "block";
                    telInput.style.borderColor = "red";
                } else {
                    telError.style.display = "none";
                    telInput.style.borderColor = (len === 0) ? "" : "#99ccff";
                }
            }
        });
    }

    // --- 5. URL（HPリンク）バリデーション ---
    if (urlInput && urlError) {
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
                urlInput.style.borderColor = "#99ccff";
            }
        });
    }

    // --- 6. 画像プレビュー ---
    if (fileInput && container) {
        fileInput.addEventListener("change", () => {
            container.innerHTML = "";
            if (fileInput.files.length > 0) {
                if (countLabel) countLabel.textContent = fileInput.files.length + " 枚選択中";
                Array.from(fileInput.files).forEach(file => {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        const div = document.createElement("div");
                        div.className = "preview-item";
                        div.innerHTML = `<img src="${e.target.result}" style="width:100px; height:100px; object-fit:cover; margin:5px; border-radius:5px; border:1px solid #ddd;">`;
                        container.appendChild(div);
                    };
                    reader.readAsDataURL(file);
                });
            } else if (countLabel) {
                countLabel.textContent = "未選択";
            }
        });
    }

    // --- 7. 送信ボタン押下時の最終チェック ---
    if (form) {
        form.addEventListener("submit", (e) => {
            // メール
            if (emailInput && !emailPattern.test(emailInput.value)) {
                alert("メールアドレスを確認してください。");
                e.preventDefault(); return;
            }
            // 電話番号
            if (telInput) {
                const telLen = telInput.value.replace(/\D/g, "").length;
                if (telLen > 0 && telLen !== 10 && telLen !== 11) {
                    alert("電話番号を正しく入力してください（10桁または11桁）。");
                    e.preventDefault(); return;
                }
            }
            // URLチェック
            if (urlInput && urlInput.value !== "") {
                const hasFullWidth = /[^\x01-\x7E]/.test(urlInput.value);
                if (hasFullWidth || !urlPattern.test(urlInput.value)) {
                    alert("HPへのリンクを正しく入力してください。");
                    e.preventDefault(); return;
                }
            }
        });
    }
});

// パスワード表示切り替え（必要に応じて使用）
function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);
    if (!input) return;
    const isPass = input.type === "password";
    input.type = isPass ? "text" : "password";
    button.textContent = isPass ? "🔒 非表示" : "👁️ 表示";
}
</script>

<%@include file="../footer.html" %>
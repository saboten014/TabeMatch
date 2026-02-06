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
					           <%-- ★ここを Name から Id に変更！ --%>
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
            <td><input type="text" name="link" maxlength="255"></td>
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
    const passInput = document.getElementById("registerPassword");
    const confirmInput = document.getElementById("confirmPassword");
    const passError = document.getElementById("pass-error");
    const confirmError = document.getElementById("confirm-error");
    const telInput = document.getElementById("shop_tel"); // 店舗電話番号
    const telError = document.getElementById("tel-error");
    const fileInput = document.querySelector(".file-input");
    const container = document.getElementById("preview-container");
    const countLabel = document.querySelector(".file-count");

    // --- 2. 共通パターン ---
    const emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
    const passPattern = /^[a-zA-Z0-9]+$/;

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

    // --- 4. パスワード・バリデーション ---
    const checkMatch = () => {
        if (!confirmInput || !passInput) return;
        if (confirmInput.value === "") {
            confirmError.style.display = "none";
        } else if (passInput.value !== confirmInput.value) {
            confirmError.style.display = "block";
            confirmInput.style.borderColor = "red";
        } else {
            confirmError.style.display = "none";
            confirmInput.style.borderColor = "#99ccff";
        }
    };

    if (passInput && passError) {
        passInput.addEventListener("input", () => {
            if (passInput.value === "") {
                passError.style.display = "none";
            } else if (!passPattern.test(passInput.value) || passInput.value.length < 8) {
                passError.textContent = passInput.value.length < 8 ? "※8文字以上必要です" : "※英数字のみ使用可能です";
                passError.style.display = "block";
                passInput.style.borderColor = "red";
            } else {
                passError.style.display = "none";
                passInput.style.borderColor = "#99ccff";
            }
            checkMatch();
        });
    }
    if (confirmInput) confirmInput.addEventListener("input", checkMatch);

    // --- 5. 電話番号の自動整形（ここが修正ポイント！） ---
    if (telInput) {
        telInput.addEventListener("input", () => {
            // ① 数字以外をすべて除去
            let value = telInput.value.replace(/\D/g, "");
            let formatted = "";
            const len = value.length;

            // ② ハイフン挿入ロジック
            if (len <= 3) {
                formatted = value;
            } else if (len <= 6) {
                // 031234 -> 03-1234
                formatted = value.substring(0, 2) + "-" + value.substring(2);
            } else if (len <= 10) {
                // 固定電話（10桁）: 03-1234-5678 または 042-999-9999
                if (value.startsWith("03") || value.startsWith("06")) {
                    formatted = value.substring(0, 2) + "-" + value.substring(2, 6) + "-" + value.substring(6);
                } else {
                    formatted = value.substring(0, 3) + "-" + value.substring(3, 6) + "-" + value.substring(6);
                }
            } else {
                // 携帯電話（11桁）: 090-1234-5678
                formatted = value.substring(0, 3) + "-" + value.substring(3, 7) + "-" + value.substring(7, 11);
            }

            telInput.value = formatted;

            // ③ バリデーション
            if (telError) {
                if (len > 0 && len !== 10 && len !== 11) {
                    telError.textContent = "※電話番号は10桁（固定）または11桁（携帯）で入力してください";
                    telError.style.display = "block";
                    telInput.style.borderColor = "red";
                } else {
                    telError.style.display = "none";
                    telInput.style.borderColor = (len === 0) ? "" : "#99ccff";
                }
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
            // パスワード
            if (passInput && (passInput.value.length < 8 || !passPattern.test(passInput.value))) {
                alert("パスワードは英数字8文字以上で入力してください。");
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
            // パスワード一致
            if (passInput && confirmInput && passInput.value !== confirmInput.value) {
                alert("パスワードが一致しません。");
                e.preventDefault();
            }
        });
    }
});

function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);
    if (!input) return;
    const isPass = input.type === "password";
    input.type = isPass ? "text" : "password";
    button.textContent = isPass ? "🔒 非表示" : "👁️ 表示";
}
</script>

<%@include file="../footer.html" %>

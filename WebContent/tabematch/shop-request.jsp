<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>
<%@include file="/tabematch/login_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<style>
  body {
    background-color: #e8f8e8 !important;
    font-family: "Kosugi Maru", "Meiryo", sans-serif !important;
    margin: 0;
    padding: 0;
  }
  /* ===== メニューバーを横並びに強制 ===== */
  .header {
    display: flex !important;
    flex-direction: row !important;
    justify-content: space-between !important;
    align-items: center !important;
    flex-wrap: nowrap !important;
  }
  .nav-links {
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    flex-wrap: nowrap !important;
  }
  .nav-links a {
    display: inline-block !important;
    margin-left: 25px !important;
    white-space: nowrap !important;
  }
  /* ===== タイトル ===== */
  h1 {
    margin-top: 120px;
    font-size: 32px;
    text-align: center;
    color: #333;
    margin-bottom: 10px;
  }
  /* ===== 説明文 ===== */
  .description {
    text-align: center;
    color: #666;
    font-size: 16px;
    margin-bottom: 30px;
  }
  /* ===== フォーム部分 ===== */
  .form-container {
    text-align: center;
    margin-top: 30px;
  }
  form {
    display: inline-block;
    text-align: left;
  }
  table {
    border-collapse: collapse;
    margin: 0 auto;
  }
  td {
    padding: 15px 10px;
    font-size: 16px;
    vertical-align: middle;
  }
  td:first-child {
    text-align: right;
    padding-right: 20px;
    font-weight: 500;
    width: 180px;
  }
  input[type="text"],
  input[type="email"],
  select,
  textarea {
    font-size: 16px;
    padding: 10px 12px;
    width: 400px;
    border: 1px solid #aaa;
    border-radius: 6px;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    box-sizing: border-box;
    line-height: normal;
  }
  select {
    height: auto;
    min-height: 42px;
    appearance: auto;
  }
  textarea {
    resize: vertical;
    min-height: 80px;
  }
  small {
    color: #888;
    font-size: 13px;
    display: block;
    margin-top: 5px;
  }
  .required {
    color: #ff6b6b;
    font-weight: bold;
    margin-left: 3px;
  }
  input[type="radio"] {
    margin-right: 5px;
    margin-left: 15px;
  }
  input[type="radio"]:first-of-type {
    margin-left: 0;
  }
  label {
    margin-right: 10px;
    font-size: 16px;
  }
  input[type="submit"],
  input[type="reset"] {
    margin-top: 30px;
    font-size: 18px;
    padding: 14px 50px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    transition: all 0.3s ease;
  }
  input[type="submit"] {
    background-color: #ffcccc;
    color: #333;
    margin-right: 15px;
    border: 2px solid #ff9999;
  }
  input[type="submit"]:hover {
    background-color: #ff9999;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
  input[type="reset"] {
    background-color: #cce5ff;
    color: #333;
    border: 2px solid #99ccff;
  }
  input[type="reset"]:hover {
    background-color: #99ccff;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
  /* ===== エラーメッセージ ===== */
  .error-message {
    text-align: center;
    margin-top: 15px;
  }
  .error-message p {
    color: #d14;
    background-color: #ffe6e6;
    padding: 12px 20px;
    border-radius: 6px;
    display: inline-block;
    border: 1px solid #ffcccc;
  }
  /* ===== 戻るリンク ===== */
  .back-link {
    text-align: center;
    margin-top: 30px;
    margin-bottom: 50px;
  }
  .back-link a {
    display: inline-block;
    padding: 12px 30px;
    background-color: #ffcccc;
    border: 2px solid #ff9999;
    border-radius: 8px;
    color: #333;
    text-decoration: none;
    font-size: 16px;
    transition: all 0.3s ease;
  }
  .back-link a:hover {
    background-color: #ff9999;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  }
</style>

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

<p class="description">店舗情報を入力してください。承認後、登録したメールアドレスにログイン情報をお送りします。</p>

<div class="form-container">
<form action="ShopRequestExecute.action" method="post">
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
            <td>アレルギー対応<span class="required">*</span></td>
            <td>
                <textarea name="allergySupport" rows="3" maxlength="255" required></textarea>
                <small>対応しているアレルゲンを記入してください</small>
            </td>
        </tr>
        <tr>
            <td>予約の可否<span class="required">*</span></td>
            <td>
                <input type="radio" name="reservation" value="1" id="res_yes" required>
                <label for="res_yes">可能</label>
                <input type="radio" name="reservation" value="0" id="res_no">
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
            <td>写真URL</td>
            <td><input type="text" name="photo" maxlength="50"></td>
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
            <td><input type="text" name="number" maxlength="20" required></td>
        </tr>
        <tr>
            <td>メールアドレス<span class="required">*</span></td>
            <td><input type="email" name="request_mail" maxlength="100" required></td>
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

<%@include file="../footer.html" %>
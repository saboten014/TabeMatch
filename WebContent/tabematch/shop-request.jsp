<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>

<h1>店舗掲載リクエスト</h1>

<%
    String errorMessage = (String)request.getAttribute("errorMessage");
    if (errorMessage != null) {
%>
    <p style="color: red;"><%= errorMessage %></p>
<%
    }
%>

<p>店舗情報を入力してください。承認後、登録したメールアドレスにログイン情報をお送りします。</p>

<form action="ShopRequestExecute.action" method="post">
    <table>
        <tr>
            <td>店名<span style="color: red;">*</span>:</td>
            <td><input type="text" name="restaurantName" size="50" maxlength="100" required></td>
        </tr>
        <tr>
            <td>住所<span style="color: red;">*</span>:</td>
            <td><input type="text" name="address" size="50" maxlength="255" required></td>
        </tr>
        <tr>
            <td>アレルギー対応<span style="color: red;">*</span>:</td>
            <td>
                <textarea name="allergySupport" rows="3" cols="47" maxlength="255" required></textarea>
                <br><small>対応しているアレルゲンを記入してください</small>
            </td>
        </tr>
        <tr>
            <td>予約の可否<span style="color: red;">*</span>:</td>
            <td>
                <input type="radio" name="reservation" value="1" id="res_yes" required>
                <label for="res_yes">可能</label>
                <input type="radio" name="reservation" value="0" id="res_no">
                <label for="res_no">不可</label>
            </td>
        </tr>
        <tr>
            <td>営業日・営業時間<span style="color: red;">*</span>:</td>
            <td>
                <input type="text" name="businessHours" size="50" maxlength="50" required>
                <br><small>例: 月～金 11:00-22:00、土日祝 10:00-23:00</small>
            </td>
        </tr>
        <tr>
            <td>決済方法<span style="color: red;">*</span>:</td>
            <td>
                <input type="text" name="payment" size="50" maxlength="50" required>
                <br><small>例: 現金、クレジットカード、電子マネー</small>
            </td>
        </tr>
        <tr>
            <td>お店のジャンル<span style="color: red;">*</span>:</td>
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
            <td>写真URL:</td>
            <td><input type="text" name="photo" size="50" maxlength="50"></td>
        </tr>
        <tr>
            <td>価格帯:</td>
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
            <td>座席<span style="color: red;">*</span>:</td>
            <td>
                <input type="text" name="seat" size="50" maxlength="50" required>
                <br><small>例: カウンター5席、テーブル20席</small>
            </td>
        </tr>
        <tr>
            <td>HPへのリンク:</td>
            <td><input type="text" name="link" size="50" maxlength="255"></td>
        </tr>
        <tr>
            <td>電話番号<span style="color: red;">*</span>:</td>
            <td><input type="text" name="number" size="30" maxlength="20" required></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="リクエスト送信">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
    <div class="form-group">
        <label for="email">メールアドレス<span class="required">*</span></label>
        <input type="email" class="form-control" id="email" name="request_mail" required>
    </div>
</form>

<p><a href="Login.action">ログイン画面に戻る</a></p>

<%@include file="../footer.html" %>
<%@page pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>

<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/shop_request.css">

<h1>店舗登録</h1>

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

<form action="<%= request.getContextPath() %>/tabematch/admin/AdminShopInsertExecute.action" method="post">

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
            <td><input type="email" name="request_mail" maxlength="100" required></td>
        </tr>

        <tr>
            <td>パスワード<span class="required">*</span></td>
            <td><input type="password" name="password" maxlength="50" required></td>
        </tr>

        <tr>
            <td>電話番号<span class="required">*</span></td>
            <td><input type="text" name="number" maxlength="20" required></td>
        </tr>

        <tr>
            <td>HPへのリンク</td>
            <td><input type="text" name="link" maxlength="255"></td>
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
                <input type="text" name="payment" maxlength="50" required>
                <small>例: 現金、クレジットカード、電子マネー</small>
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
            <td>予約の可否<span class="required">*</span></td>
            <td>
                <input type="radio" name="reservation" value="1" id="res_yes" required>
                <label for="res_yes">可能</label>
                <input type="radio" name="reservation" value="2" id="res_no">
                <label for="res_no">不可</label>
            </td>
        </tr>

        <tr>
            <td>アレルギー対応<span class="required">*</span></td>
            <td>
                <div class="checkbox-grid">
<%
    List<Allergen> allergenList = (List<Allergen>)request.getAttribute("allergenList");
    if (allergenList != null && !allergenList.isEmpty()) {
        for (Allergen allergen : allergenList) {
%>
                    <div class="checkbox-item">
                        <input type="checkbox"
                               name="allergyInfo"
                               value="<%= allergen.getAllergenName() %>"
                               id="allergy_<%= allergen.getAllergenId() %>">
                        <label for="allergy_<%= allergen.getAllergenId() %>">
                            <%= allergen.getAllergenName() %>
                        </label>
                    </div>
<%
        }
    } else {
%>
                    <p style="color: #999;">アレルゲン情報が取得できませんでした。</p>
<%
    }
%>
                </div>
                <small>対応しているアレルゲンを選択してください</small>
            </td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="登録">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
</form>
</div>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理画面に戻る</a>
</div>

<%@include file="../../footer.html" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="bean.Users" %>
<%@page import="dao.AllergenDAO" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/search.css">

<h1>店舗検索</h1>

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

<%
    // ログインユーザーのアレルギー情報を取得
    String[] userAllergens = null;
    if (loginUser != null && loginUser.getAllergenId() != null && !loginUser.getAllergenId().isEmpty()) {
        userAllergens = loginUser.getAllergenId().split(",");
    }
%>

<div class="form-container">
<form action="Search.action" method="post">
    <table>
        <tr>
            <td>検索エリア</td>
            <td><input type="text" name="searchArea" placeholder="例: 東京都渋谷区"></td>
        </tr>
        <tr>
            <td>店名</td>
            <td><input type="text" name="shopName"></td>
        </tr>
        <tr>
            <td>ジャンル</td>
            <td>
                <select name="genre">
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
                    <option value="1000円～2000円">1000円～2000円</option>
                    <option value="2000円～3000円">2000円～3000円</option>
                    <option value="3000円～5000円">3000円～5000円</option>
                    <option value="5000円以上">5000円以上</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>営業時間</td>
            <td><input type="text" name="businessHours" placeholder="例: 11:00-22:00"></td>
        </tr>
        <tr>
            <td style="vertical-align: top; padding-top: 20px;">アレルギー情報</td>
            <td>
                <div class="checkbox-grid">
<%
    // アレルゲン一覧を取得
    AllergenDAO allergenDao = new AllergenDAO();
    List<Allergen> allergenList = allergenDao.getAllAllergens();

    for (Allergen allergen : allergenList) {
        // ログインユーザーのアレルゲンと一致する場合は自動チェック
        boolean isChecked = false;
        if (userAllergens != null) {
            for (String userAllergenId : userAllergens) {
                if (userAllergenId.trim().replace("{", "").replace("}", "").equals(allergen.getAllergenId())) {
                    isChecked = true;
                    break;
                }
            }
        }
%>
                    <div class="checkbox-item">
                        <input type="checkbox" name="allergyInfo" value="<%= allergen.getAllergenName() %>"
                               id="allergy_<%= allergen.getAllergenId() %>"
                               <%= isChecked ? "checked" : "" %>>
                        <label for="allergy_<%= allergen.getAllergenId() %>"><%= allergen.getAllergenName() %></label>
                    </div>
<%
    }
%>
                </div>
                <div class="other-allergy">
                    <label for="otherAllergy">その他のアレルギー:</label>
                    <input type="text" name="otherAllergy" id="otherAllergy" placeholder="例: とうもろこし、トマト">
                </div>
                <small>※対応しているアレルゲンを選択してください（あなたのアレルギー情報:
<%
    if (userAllergens != null && userAllergens.length > 0) {
        for (int i = 0; i < userAllergens.length; i++) {
            Allergen userAllergen = allergenDao.getAllergenById(userAllergens[i].trim());
            if (userAllergen != null) {
                out.print(userAllergen.getAllergenName());
                if (i < userAllergens.length - 1) out.print(", ");
            }
        }
    } else {
        out.print("未設定");
    }
%>
                ）</small>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;">
                <input type="submit" value="検索">
                <input type="reset" value="クリア">
            </td>
        </tr>
    </table>
</form>
</div>

<%@include file="../../footer.html" %>
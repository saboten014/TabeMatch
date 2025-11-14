<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Allergen" %>
<%@page import="bean.Users" %>
<%@page import="dao.AllergenDAO" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<style>
  body {
    background-color: #e8f8e8 !important;
    font-family: "Kosugi Maru", "Meiryo", sans-serif !important;
    margin: 0;
    padding: 0;
  }
  /* ===== タイトル ===== */
  h1 {
    margin-top: 120px;
    padding-top: 20px;
    font-size: 32px;
    text-align: center;
    color: #333;
    margin-bottom: 10px;
  }
  /* ===== フォーム部分 ===== */
  .form-container {
    text-align: center;
    margin-top: 30px;
    margin-bottom: 50px;
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
    font-size: 18px;
    vertical-align: middle;
  }
  td:first-child {
    text-align: right;
    padding-right: 20px;
    font-weight: 500;
    width: 180px;
    font-size: 18px;
  }
  input[type="text"],
  select {
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
  small {
    color: #888;
    font-size: 18px;
    display: block;
    margin-top: 5px;
  }
  /* ===== チェックボックスのグリッド ===== */
  .checkbox-grid {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 15px 20px;
    margin-bottom: 15px;
    width: 600px;
  }
  .checkbox-item {
    display: flex;
    align-items: center;
  }
  .checkbox-item input[type="checkbox"] {
    margin: 0;
    padding: 0;
    width: 16px;
    height: 16px;
    flex-shrink: 0;
  }
  .checkbox-item label {
    font-size: 18px;
    cursor: pointer;
    margin-left: 5px;
    white-space: nowrap;
  }
  /* ===== ボタン ===== */
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
  /* その他アレルギー入力欄 */
  .other-allergy {
    margin-top: 10px;
  }
  .other-allergy input[type="text"] {
    width: 400px;
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
</style>

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
                if (userAllergenId.trim().equals(allergen.getAllergenId())) {
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
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<html>
<head>
    <title>店舗詳細</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/shop-detail.css">
</head>
<body>
<div class="container mt-4">

    <h2>店舗詳細情報</h2>

    <button onclick="goBack()" class="goback">前のページに戻る</button>

    <script>
    function goBack() {
        window.history.back();
    }
    </script>

    <%-- メッセージ表示エリア --%>
    <%
        String requestErrorMessage = (String) request.getAttribute("errorMessage");
        if (requestErrorMessage != null) {
    %>
        <div class="dame" role="alert"><%= requestErrorMessage %></div>
    <%
        }
    %>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="sakusesu" role="alert">${sessionScope.successMessage}</div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="dame" role="alert">${sessionScope.errorMessage}</div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <%
        bean.Shop shop = (bean.Shop) request.getAttribute("shop");
        Boolean isFavorite = (Boolean) request.getAttribute("isFavorite");
        if (isFavorite == null) isFavorite = false;

        if (shop != null) {
    %>
    <div>
        <h2 class="shopname"><%= shop.getShopName() %></h2>
        <table border="0">
            <tr>
                <th>住所</th>
                <td><%= shop.getShopAddress() %></td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td><%= shop.getShopTel() %></td>
            </tr>
            <tr>
                <th>メールアドレス</th>
                <td><%= shop.getShopMail() %></td>
            </tr>
            <tr>
                <th>ジャンル</th>
                <td><%= shop.getShopGenre() %></td>
            </tr>
            <tr>
                <th>価格帯</th>
                <td><%= shop.getShopPrice() %></td>
            </tr>
            <tr>
                <th>支払い方法</th>
                <td><%= shop.getShopPay() %></td>
            </tr>
            <tr>
                <th>座席数</th>
                <td><%= shop.getShopSeat() %> 席</td>
            </tr>
            <tr>
                <th>アレルギー対応</th>
                <td><%= shop.getShopAllergy() != null ? shop.getShopAllergy() : "未登録" %></td>
            </tr>
            <tr>
                <th>予約可否</th>
                <td><%= shop.getShopReserve() %></td>
            </tr>
            <tr>
                <th>店舗URL</th>
                <td>
                    <% if (shop.getShopUrl() != null && !shop.getShopUrl().isEmpty()) { %>
                        <a href="<%= shop.getShopUrl() %>" target="_blank"><%= shop.getShopUrl() %></a>
                    <% } else { %>
                        登録なし
                    <% } %>
                </td>
            </tr>




<tr>
    <th>掲載画像</th>
    <td>
        <div class="shop-images-scroll">
            <%
                String pictureField = shop.getShopPicture();
                if (pictureField != null && !pictureField.isEmpty()) {
                    String[] pictures = pictureField.split(",");
                    for (String pic : pictures) {
            %>
                        <div class="image-item">
                            <img src="<%= request.getContextPath() %>/upload/<%= pic.trim() %>"
                                 alt="店舗画像">
                        </div>
            <%
                    }
                } else {
            %>
                画像なし
            <% } %>
        </div>
    </td>
</tr>



        </table>
    </div>

    <%-- ボタンエリア --%>
    <div class="shop-actions">
        <%
            Users loginUserDetail = (Users) session.getAttribute("user");
            String reserveFlag = shop.getShopReserve();
            boolean reservable = reserveFlag != null && (reserveFlag.contains("可") || "Y".equalsIgnoreCase(reserveFlag));

            if (loginUserDetail != null) {
        %>
            <%-- お気に入りボタン --%>
            <form action="FavoriteInsert.action" method="post" class="inline-form">
                <input type="hidden" name="shopId" value="<%= shop.getShopId() %>">
                <% if (isFavorite) { %>
                    <button type="submit" class="kaijo">★ お気に入り解除</button>
                <% } else { %>
                    <button type="submit" class="love">☆ お気に入り登録</button>
                <% } %>
            </form>

            <%-- 予約ボタン --%>
            <% if (reservable) { %>
                <a href="ReserveForm.action?shopId=<%= shop.getShopId() %>" class="yoyaku">この店舗を予約する</a>
            <% } %>

            <%-- 口コミボタン --%>
            <a href="<%= request.getContextPath() %>/tabematch/main/ReviewPostForm.action?shopId=<%= shop.getShopId() %>" class="kutikomisuru">口コミを投稿する</a>
            <a href="<%= request.getContextPath() %>/tabematch/main/ReviewList.action?shopId=<%= shop.getShopId() %>" class="kutikomiru">口コミを見る</a>

        <% } else { %>
            <div class="login-guide">
                <p>予約やお気に入り、口コミ機能を利用するにはログインが必要です。</p>
                <a href="../Login.action" class="yoyaku">ログインする</a>
            </div>
        <% } %>
    </div>

    <%
        } else {
    %>
        <div class="dame">店舗情報が見つかりません。</div>
    <%
        }
    %>

</div>
</body>
</html>
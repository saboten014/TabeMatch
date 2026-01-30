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
                <td><%= (shop.getShopAddress() != null && !shop.getShopAddress().isEmpty()) ? shop.getShopAddress() : "未登録" %></td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td><%= (shop.getShopTel() != null && !shop.getShopTel().isEmpty()) ? shop.getShopTel() : "未登録" %></td>
            </tr>
            <tr>
                <th>ジャンル</th>
                <td><%= (shop.getShopGenre() != null && !shop.getShopGenre().isEmpty()) ? shop.getShopGenre() : "未登録" %></td>
            </tr>
            <tr>
                <th>価格帯</th>
                <td><%= (shop.getShopPrice() != null && !shop.getShopPrice().isEmpty()) ? shop.getShopPrice() : "未登録" %></td>
            </tr>
            <tr>
                <th>支払い方法</th>
                <td><%= (shop.getShopPay() != null && !shop.getShopPay().isEmpty()) ? shop.getShopPay() : "未登録" %></td>
            </tr>
            <tr>
                <th>座席数</th>
                <td>
                    <% if (shop.getShopSeat() != null) { %>
                        <%= shop.getShopSeat() %> 席
                    <% } else { %>
                        未登録
                    <% } %>
                </td>
            </tr>
            <tr>
                <th>アレルギー対応</th>
                <td><%= (shop.getShopAllergy() != null && !shop.getShopAllergy().isEmpty()) ? shop.getShopAllergy() : "未登録" %></td>
            </tr>
            <tr>
                <th>予約可否</th>
                <td><%= (shop.getShopReserve() != null && !shop.getShopReserve().isEmpty()) ? shop.getShopReserve() : "未登録" %></td>
            </tr>
            <tr>
                <th>店舗URL</th>
                <td>
                    <% if (shop.getShopUrl() != null && !shop.getShopUrl().isEmpty()) { %>
                        <a href="<%= shop.getShopUrl() %>" target="_blank"><%= shop.getShopUrl() %></a>
                    <% } else { %>
                        未登録
                    <% } %>
                </td>
            </tr>
			<tr>
			    <th>掲載画像</th>
			    <td>
			        <%
			            String pictureField = shop.getShopPicture();
			            if (pictureField != null && !pictureField.isEmpty()) {
			        %>
			            <div class="shop-images-scroll">
			                <%
			                    String[] pictures = pictureField.split(",");
			                    for (String pic : pictures) {
			                %>
			                    <div class="image-item">
			                        <img src="<%= request.getContextPath() %>/upload/<%= pic.trim() %>"
			                             alt="店舗画像">
			                    </div>
			                <%
			                    }
			                %>
			            </div>
			        <%
			            } else {
			        %>
			            未登録
			        <%
			            }
			        %>
			    </td>
			</tr>
        </table>
    </div>

    <%-- ボタンエリア --%>
    <div class="shop-actions">
        <%
            Users loginUserDetail = (Users) session.getAttribute("user");
            String reserveFlag = shop.getShopReserve();
            // 修正: 「可能」の場合のみ予約可能とする（「不可」が含まれる場合は予約不可）
            boolean reservable = reserveFlag != null &&
                                 !reserveFlag.contains("不可") &&
                                 (reserveFlag.contains("可能") || reserveFlag.equals("可"));

            if (loginUserDetail != null) {
        %>
            <%-- お気に入りボタン --%>
            <form action="FavoriteInsert.action" method="post" class="inline-form">
                <input type="hidden" name="shopId" value="<%= shop.getShopId() %>">
                <% if (isFavorite) { %>
                    <button type="submit" class="kaijo">★ お気に入り登録済み</button>
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
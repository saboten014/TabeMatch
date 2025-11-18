<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<html>
<head>
    <title>店舗詳細</title>
    <!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/shop-detail.css">

</head>
<body>
<div class="container mt-4">

    <h2>店舗詳細情報</h2>

<a href="Search.action" class="backlist">← 一覧に戻る</a>

    <%-- リクエストスコープのエラーメッセージを表示 --%>
    <%
        String requestErrorMessage = (String) request.getAttribute("errorMessage");
        if (requestErrorMessage != null) {
    %>
        <div class="alert alert-danger" role="alert"><%= requestErrorMessage %></div>
    <%
        }
    %>

    <%-- セッションスコープの成功・エラーメッセージを表示し、削除する (FavoriteInsertActionの結果) --%>
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

        // ShopDetailActionでセットされたお気に入り状態を取得
        Boolean isFavorite = (Boolean) request.getAttribute("isFavorite");
        if (isFavorite == null) {
            isFavorite = false; // デフォルトは未登録
        }

        if (shop != null) {
    %>
    <div>
        <div>
            <h2 class="shopname"><%= shop.getShopName() %></h2>
        </div>
        <div>
            <table border="1" cellpadding="10" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                <tr>
                    <th style="width: 25%;">住所</th>
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
                        <% if (shop.getShopPicture() != null && !shop.getShopPicture().isEmpty()) { %>
                            <img src="<%= shop.getShopPicture() %>" alt="店舗画像" class="img-fluid rounded" style="max-width: 300px;">
                        <% } else { %>
                            画像なし
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div class="text-center mt-4">
        <%
            // ★修正箇所: loginUserという名前を避け、loginUserDetailに変更
            Users loginUserDetail = null;
            Object userObj = session.getAttribute("user");
            if (userObj instanceof Users) {
                 loginUserDetail = (Users) userObj;
            }

            String reserveFlag = shop.getShopReserve();
            boolean reservable = reserveFlag != null && (reserveFlag.contains("可") || "Y".equalsIgnoreCase(reserveFlag));

            if (loginUserDetail != null) { // ★修正: loginUserDetailを使用
                // お気に入りボタン（POSTフォーム）
        %>
        <div class="btn">
            <form action="FavoriteInsert.action" method="post">
                <input type="hidden" name="shopId" value="<%= shop.getShopId() %>">
                <% if (isFavorite) { %>
                    <%-- 登録済みの場合: 解除ボタン --%>
                    <button type="submit" class="kaijo">
                        <i ></i> ★ お気に入り解除
                    </button>
                <% } else { %>
                    <%-- 未登録の場合: 登録ボタン --%>
                    <button type="submit" class="love">
                        <i></i> ☆ お気に入り登録
                    </button>
                <% } %>
            </form>

        <%
            }

            if (reservable) {
        %>
            <a href="ReserveForm.action?shopId=<%= shop.getShopId() %>" class="yoyaku">この店舗を予約する</a>
        <%
            } else {
        %>
            <div class="alert">この店舗ではオンライン予約を受け付けていません。</div>
        <%
            }

            if (loginUserDetail == null) { // ★修正: loginUserDetailを使用
        %>
            <p>予約やお気に入り機能にはログインが必要です。<a href="../Login.action" class="loginB">ログインする</a></p>
        <%
            }
        %>



    <%
        } else {
    %>
        <div class="alert alert-warning text-center">
            店舗情報が見つかりません。
        </div>
    <%
        }
    %>


<!-- ★★★★★ 追加部分（ここから） ★★★★★ -->
<%
    bean.Users loginUserDetail = (bean.Users) session.getAttribute("user");
%>


    <% if (loginUserDetail != null) { %>
       <a href="../main/ReviewPostForm.action?shopId=<%= shop.getShopId() %>" class="kutikomisuru">
            口コミを投稿する
        </a>

        <a href="../main/ReviewList.action?shopId=<%= shop.getShopId() %>" class="kutikomiru">
		口コミを見る
        </a>
    <% } else { %>
        <p class="mt-3">
            口コミ機能を利用するにはログインが必要です。
            <a href="../Login.action" class="loginB">ログインする</a>
        </p>
    <% } %>

</div>

<!-- ★★★★★ 追加部分（ここまで） ★★★★★ -->


</body>
</html>
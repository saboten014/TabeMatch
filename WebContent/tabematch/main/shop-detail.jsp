<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ include file="../../header.html" %>

<html>
<head>
    <title>店舗詳細</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">

    <!-- タイトル -->
    <h2 class="mb-4 text-center">店舗詳細情報</h2>

    <!-- エラーメッセージ -->
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
    <%
        }
    %>

    <!-- 店舗情報 -->
    <%
        bean.Shop shop = (bean.Shop) request.getAttribute("shop");
        if (shop != null) {
    %>
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><%= shop.getShopName() %></h4>
        </div>
        <div class="card-body">
            <table class="table table-bordered">
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

    <!-- 予約ボタン -->
    <div class="text-center mt-4">
        <%
            Users loginUser = (Users) session.getAttribute("user");
            String reserveFlag = shop.getShopReserve();
            boolean reservable = reserveFlag != null && (reserveFlag.contains("可") || "1".equals(reserveFlag));
            if (reservable) {
        %>
            <a href="ReserveForm.action?shopId=<%= shop.getShopId() %>" class="btn btn-success me-2">この店舗を予約する</a>
        <%
            } else {
        %>
            <div class="alert alert-info">この店舗ではオンライン予約を受け付けていません。</div>
        <%
            }
            if (loginUser == null) {
        %>
            <p class="mt-3">予約にはログインが必要です。<a href="../login.jsp">ログインする</a></p>
        <%
            }
        %>
        <a href="Search.action" class="btn btn-secondary">一覧に戻る</a>
    </div>

    <%
        } else {
    %>
        <div class="alert alert-warning text-center">
            店舗情報が見つかりません。
        </div>
    <%
        }
    %>
</div>

</body>
</html>

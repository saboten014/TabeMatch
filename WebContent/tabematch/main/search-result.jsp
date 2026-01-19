<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/search_result.css">

<div class="result-container">
    <h1 class="result">検索結果</h1>

    <div class="navigation">
        <a href="search.jsp" class="back-link">← 検索画面に戻る</a>
    </div>

    <%-- 警告メッセージ表示 --%>
    <%
        String warningMessage = (String)request.getAttribute("warningMessage");
        if (warningMessage != null) {
    %>
        <div class="warning-box">
            <p><%= warningMessage %></p>
            <button class="ok-btn" onclick="this.parentElement.style.display='none';">OK</button>
        </div>
    <%
        }
    %>

    <%-- 店舗リスト表示 --%>
    <%
        List<Shop> shopList = (List<Shop>)request.getAttribute("shopList");

        if (shopList == null || shopList.isEmpty()) {
    %>
        <div class="no-result">
            <p>検索条件に一致する店舗が見つかりませんでした。</p>
        </div>
    <%
        } else {
    %>
        <p class="result-count">検索結果: <strong><%= shopList.size() %></strong> 件</p>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>店舗名</th>
                        <th>ジャンル</th>
                        <th>住所</th>
                        <th>価格帯</th>
                        <th>営業時間</th>
                        <th>詳細</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Shop shop : shopList) {
                %>
                    <tr>
                        <td class="shop-name-cell"><%= shop.getShopName() %></td>
                        <td><span class="genre-tag"><%= shop.getShopGenre() %></span></td>
                        <td><%= shop.getShopAddress() %></td>
                        <td><%= shop.getShopPrice() != null ? shop.getShopPrice() : "-" %></td>
                        <td><%= shop.getShopTime() != null ? shop.getShopTime() : "-" %></td>
                        <td>
                            <a href="ShopDetail.action?shopId=<%= shop.getShopId() %>" class="detail-btn">詳細を見る</a>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    <%
        }
    %>
</div>

<%@include file="../../footer.html" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/search_result.css">

<h1 class="result">検索結果</h1>

<p><a href="search.jsp">← 検索画面に戻る</a></p>

<%
    String warningMessage = (String)request.getAttribute("warningMessage");
    if (warningMessage != null) {
%>
    <div style="background-color: #fff3cd; border: 1px solid #ffc107; padding: 10px; margin: 10px 0;">
        <p style="color: #856404; margin: 0;"><%= warningMessage %></p>
        <button onclick="alert('OK');" style="margin-top: 5px;">OK</button>
    </div>
<%
    }
%>

<%
    List<Shop> shopList = (List<Shop>)request.getAttribute("shopList");

    if (shopList == null || shopList.isEmpty()) {
%>
    <p>検索条件に一致する店舗が見つかりませんでした。</p>
<%
    } else {
%>
    <p>検索結果: <%= shopList.size() %>件</p>

    <table border="1" cellpadding="10" cellspacing="0" style="width: 100%; border-collapse: collapse;">
        <tr style="background-color: #f0f0f0;">
            <th>店舗名</th>
            <th>ジャンル</th>
            <th>住所</th>
            <th>価格帯</th>
            <th>営業時間</th>
            <th>詳細</th>
        </tr>
<%
        for (Shop shop : shopList) {
%>
        <tr>
            <td><%= shop.getShopName() %></td>
            <td><%= shop.getShopGenre() %></td>
            <td><%= shop.getShopAddress() %></td>
            <td><%= shop.getShopPrice() != null ? shop.getShopPrice() : "-" %></td>
            <td><%= shop.getShopTime() != null ? shop.getShopTime() : "-" %></td>
            <td><a href="ShopDetail.action?shopId=<%= shop.getShopId() %>">詳細を見る</a></td>
        </tr>
<%
        }
%>
    </table>
<%
    }
%>

<%@include file="../../footer.html" %>
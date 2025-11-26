<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>店舗詳細</h2>

<%
Shop shop = (Shop) request.getAttribute("shop");
%>

<table>
    <tr><th>ID</th><td><%= shop.getShopId() %></td></tr>
    <tr><th>店舗名</th><td><%= shop.getShopName() %></td></tr>
    <tr><th>住所</th><td><%= shop.getShopAddress() %></td></tr>
    <tr><th>メール</th><td><%= shop.getShopMail() %></td></tr>
    <tr><th>公開状態</th><td><%= shop.getIsPublic() ? "公開" : "非公開" %></td></tr>
    <tr><th>登録日</th><td><%= shop.getShopDate() %></td></tr>
</table>

<div class="btn-area">
    <% if (shop.getIsPublic()) { %>
        <a href="AdminShopPrivate.action?shopId=<%=shop.getShopId()%>">非公開にする</a>
    <% } else { %>
        <a href="AdminShopPublic.action?shopId=<%=shop.getShopId()%>">公開する</a>
    <% } %>

    <a href="AdminShopDeleteConfirm.action?shopId=<%=shop.getShopId()%>" style="color:red;">
        削除する
    </a>
</div>

<%@include file="../../footer.html" %>
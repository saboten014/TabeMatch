<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-shop-d.css">

<h2>店舗詳細</h2>

<%
Shop shop = (Shop) request.getAttribute("shop");
%>

<table style="width: 70%; border-collapse: collapse;">
    <tr><th>ID</th><td><%= shop.getShopId() %></td></tr>
    <tr><th>店舗名</th><td><%= shop.getShopName() %></td></tr>
    <tr><th>住所</th><td><%= shop.getShopAddress() %></td></tr>
    <tr><th>メール</th><td><%= shop.getShopMail() %></td></tr>
    <tr><th>公開状態</th><td><%= shop.getIsPublic() ? "公開" : "非公開" %></td></tr>
    <tr><th>登録日</th><td><%= shop.getShopDate() %></td></tr>
</table>

<div class="btn-area">
    <% if (shop.getIsPublic()) { %>
        <div class="koukai"><a href="AdminShopPrivate.action?shopId=<%=shop.getShopId()%>">非公開にする</a></div>
    <% } else { %>
        <div class="koukai"><a href="AdminShopPublic.action?shopId=<%=shop.getShopId()%>">公開する</a>
        </div>
    <% } %>
	<div class="sakujo">
    <a href="AdminShopDeleteConfirm.action?shopId=<%=shop.getShopId()%>">
        削除する
    </a></div>
</div>

<%@include file="../../footer.html" %>
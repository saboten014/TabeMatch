<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>店舗削除確認</h2>

<%
Shop shop = (Shop)request.getAttribute("shop");
%>

<div class="confirm-box">
    <p>以下の店舗を削除します。よろしいですか？</p>

    <table>
        <tr><th>ID</th><td><%= shop.getShopId() %></td></tr>
        <tr><th>店舗名</th><td><%= shop.getShopName() %></td></tr>
        <tr><th>住所</th><td><%= shop.getShopAddress() %></td></tr>
        <tr><th>メール</th><td><%= shop.getShopMail() %></td></tr>
        <tr><th>公開状態</th><td><%= shop.getIsPublic() ? "公開" : "非公開" %></td></tr>
        <tr><th>登録日</th><td><%= shop.getShopDate() %></td></tr>
    </table>

    <div class="btn-area">
        <!-- 削除実行 -->
        <a href="AdminShopDelete.action?shopId=<%=shop.getShopId()%>" class="btn delete">
            はい（削除する）
        </a>

        <!-- 戻る -->
        <a href="AdminShopDetail.action?shopId=<%=shop.getShopId()%>" class="btn back">
            いいえ（戻る）
        </a>
    </div>

</div>

<%@include file="../../footer.html" %>

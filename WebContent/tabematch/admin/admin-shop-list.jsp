<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Shop" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>店舗一覧</h2>

<div class="table-container">
<%
List<Shop> list = (List<Shop>) request.getAttribute("shopList");
if (list != null && !list.isEmpty()) {
%>
<table>
    <tr>
        <th>店舗名</th>
        <th>ID</th>
        <th>住所</th>
        <th>メール</th>
        <th>公開状態</th>
        <th>登録日</th>
        <th>操作</th>
    </tr>
<%
for (Shop s : list) {
%>
<tr>
    <td><%= s.getShopName() %></td>
    <td><%= s.getShopId() %></td>
    <td><%= s.getShopAddress() %></td>
    <td><%= s.getShopMail() %></td>
    <td><%= s.getIsPublic() ? "公開" : "非公開" %></td>
    <td><%= s.getShopDate() %></td>
    <td>
        <a href="AdminShopDetail.action?shopId=<%=s.getShopId()%>">詳細</a>
    </td>
</tr>
<%
}
%>
</table>
<%
} else {
%>
<p>登録店舗がありません。</p>
<%
}
%>
</div>

<!-- ▼ フィルタ -->
<div class="filter-container">
    五十音：
    <a href="AdminShopList.action?kana=ア">ア</a>
    <a href="AdminShopList.action?kana=カ">カ</a>
    <a href="AdminShopList.action?kana=サ">サ</a>
    <a href="AdminShopList.action?kana=タ">タ</a>
    <a href="AdminShopList.action?kana=ナ">ナ</a>
    <a href="AdminShopList.action?kana=ハ">ハ</a>
    <a href="AdminShopList.action?kana=マ">マ</a>
    <a href="AdminShopList.action?kana=ヤ">ヤ</a>
    <a href="AdminShopList.action?kana=ラ">ラ</a>
    <a href="AdminShopList.action?kana=ワ">ワ</a>

    <br>A〜Z：
<%
for(char c='A'; c<='Z'; c++){
%>
    <a href="AdminShopList.action?kana=<%=c%>"><%=c%></a>
<%
}
%>

    <br><a href="AdminShopList.action?kana=ALL">すべて表示</a>
</div>

<%
int pageNum = (int)request.getAttribute("page");    // ← 修正
int maxPage = (int)request.getAttribute("maxPage");
String kana = (String)request.getAttribute("kana");
if (kana == null) kana = "ALL";
%>

<!-- ▼ ページネーション -->
<div class="pagination">
<% if (pageNum > 1) { %>
    <a href="AdminShopList.action?page=<%=pageNum-1%>&kana=<%=kana%>">← 前へ</a>
<% } %>

<span><%=pageNum%> / <%=maxPage%></span>

<% if (pageNum < maxPage) { %>
    <a href="AdminShopList.action?page=<%=pageNum+1%>&kana=<%=kana%>">次へ →</a>
<% } %>
</div>

<%@include file="../../footer.html" %>
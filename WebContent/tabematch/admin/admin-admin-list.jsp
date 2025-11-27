<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<h2>管理者一覧</h2>

<div class="table-container">
<%
    List<Users> list = (List<Users>) request.getAttribute("adminList");
    if (list != null && !list.isEmpty()) {
%>
    <table>
        <tr>
            <th>管理者名</th>
            <th>メールアドレス（ID）</th>
            <th>登録日</th>
            <th style="text-align: center;">操作</th>
        </tr>
<%
        for (Users u : list) {
%>
        <tr>
            <td><%= u.getUserName() %></td>
            <td><%= u.getUserId() %></td>
            <td><%= u.getCreatedAt() %></td>
            <td style="text-align: center;">
                <a href="AdminAdminDetail.action?userId=<%= u.getUserId() %>">詳細</a>
            </td>
        </tr>
<%
        }
%>
    </table>
<%
    } else {
%>
    <div class="no-data">
        <p>登録されている管理者がいません。</p>
    </div>
<%
    }
%>
</div>

<!-- フィルタ -->
<div class="filter-container">
    <div class="filter-group">
        <span>五十音：</span>
        <a href="AdminAdminList.action?kana=ア">ア</a>
        <a href="AdminAdminList.action?kana=カ">カ</a>
        <a href="AdminAdminList.action?kana=サ">サ</a>
        <a href="AdminAdminList.action?kana=タ">タ</a>
        <a href="AdminAdminList.action?kana=ナ">ナ</a>
        <a href="AdminAdminList.action?kana=ハ">ハ</a>
        <a href="AdminAdminList.action?kana=マ">マ</a>
        <a href="AdminAdminList.action?kana=ヤ">ヤ</a>
        <a href="AdminAdminList.action?kana=ラ">ラ</a>
        <a href="AdminAdminList.action?kana=ワ">ワ</a>
    </div>

    <div class="filter-group">
        <span>A〜Z：</span>
        <% for(char c='A'; c<='Z'; c++){ %>
            <a href="AdminAdminList.action?kana=<%=c%>"><%=c%></a>
        <% } %>
    </div>

    <div class="filter-group">
        <a href="AdminAdminList.action?kana=ALL" class="clear-btn">すべて表示</a>
    </div>
</div>

<%
    Integer pageNumObj = (Integer) request.getAttribute("pageNum");
    Integer maxPageObj = (Integer) request.getAttribute("maxPage");
    String kana = (String) request.getAttribute("kana");
    int pageNum = (pageNumObj == null) ? 1 : pageNumObj;
    int maxPage = (maxPageObj == null) ? 1 : maxPageObj;
    if (kana == null) kana = "ALL";
%>

<div class="pagination">
    <% if (pageNum > 1) { %>
        <a href="AdminAdminList.action?page=<%=pageNum-1%>&kana=<%=kana%>">← 前へ</a>
    <% } %>

    <span><%=pageNum%> / <%=maxPage%></span>

    <% if (pageNum < maxPage) { %>
        <a href="AdminAdminList.action?page=<%=pageNum+1%>&kana=<%=kana%>">次へ →</a>
    <% } %>
</div>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理者ホームに戻る</a>
</div>

<%@include file="../../footer.html" %>

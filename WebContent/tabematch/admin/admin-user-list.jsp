<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Users" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- CSS読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_user_list.css">

<h2>ユーザー一覧</h2>

<div class="table-container">
<%
List<Users> list = (List<Users>) request.getAttribute("userList");
if (list != null && !list.isEmpty()) {
%>
    <table>
        <tr>
            <th>ユーザー名</th>
            <th>メールアドレス（ID）</th>
            <th>登録日</th>
            <th style="text-align: center;">操作</th>
        </tr>
<%
    for (Users u : list) {
%>
        <tr>
            <td><%=u.getUserName()%></td>
            <td><%=u.getUserId()%></td>
            <td><%=u.getCreatedAt()%></td>
            <td style="text-align: center;">
                <a href="AdminUserDetail.action?userId=<%=u.getUserId()%>">詳細</a>
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
        <p>登録されているユーザーがいません。</p>
    </div>
<%
}
%>
</div>

<!-- ▼ フィルタボタン -->
<div class="filter-container">

    <!-- 五十音 -->
    <div class="filter-group">
        <span>五十音：</span>
        <a href="AdminUserList.action?kana=ア">ア</a>
        <a href="AdminUserList.action?kana=カ">カ</a>
        <a href="AdminUserList.action?kana=サ">サ</a>
        <a href="AdminUserList.action?kana=タ">タ</a>
        <a href="AdminUserList.action?kana=ナ">ナ</a>
        <a href="AdminUserList.action?kana=ハ">ハ</a>
        <a href="AdminUserList.action?kana=マ">マ</a>
        <a href="AdminUserList.action?kana=ヤ">ヤ</a>
        <a href="AdminUserList.action?kana=ラ">ラ</a>
        <a href="AdminUserList.action?kana=ワ">ワ</a>
    </div>

    <!-- A〜Z -->
    <div class="filter-group">
        <span>A〜Z：</span>
        <% for(char c='A'; c<='Z'; c++){ %>
            <a href="AdminUserList.action?kana=<%=c%>"><%=c%></a>
        <% } %>
    </div>

    <!-- クリア -->
    <div class="filter-group">
        <a href="AdminUserList.action?kana=ALL" class="clear-btn">すべて表示</a>
    </div>

</div>

<%
/* ▼ 修正済み：変数名 page → pageNum に変更（重複ローカル変数エラー対策） */
int pageNum = (int)request.getAttribute("page");
int maxPage = (int)request.getAttribute("maxPage");
String kana = (String)request.getAttribute("kana");
if (kana == null) kana = "ALL";
%>

<div class="pagination">
    <% if (pageNum > 1) { %>
        <a href="AdminUserList.action?page=<%=pageNum-1%>&kana=<%=kana%>">← 前へ</a>
    <% } %>

    <span><%=pageNum%> / <%=maxPage%></span>

    <% if (pageNum < maxPage) { %>
        <a href="AdminUserList.action?page=<%=pageNum+1%>&kana=<%=kana%>">次へ →</a>
    <% } %>
</div>

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理者ホームに戻る</a>
</div>

<%@include file="../../footer.html" %>

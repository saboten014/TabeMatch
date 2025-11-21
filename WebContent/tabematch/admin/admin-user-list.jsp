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

<div class="back-link">
    <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp">← 管理者ホームに戻る</a>
</div>

<%@include file="../../footer.html" %>
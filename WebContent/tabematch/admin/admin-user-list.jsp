<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Users" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<h2>ユーザー一覧</h2>

<table border="1" cellpadding="10" cellspacing="0">
<tr>
    <th>ユーザー名</th>
    <th>メールアドレス（ID）</th>
    <th>登録日</th>
    <th></th>
</tr>

<%
List<Users> list = (List<Users>) request.getAttribute("userList");

for (Users u : list) {
%>
<tr>
    <td><%=u.getUserName()%></td>
    <td><%=u.getUserId()%></td>
    <td><%=u.getCreatedAt()%></td>
    <td>
        <a href="AdminUserDetail.action?userId=<%=u.getUserId()%>">詳細</a>
    </td>
</tr>
<%
}
%>
</table>

<%@include file="../../footer.html" %>

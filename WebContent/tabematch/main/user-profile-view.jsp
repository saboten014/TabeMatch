<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Users" %>
<%@ page import="bean.Allergen" %>
<%@ page import="java.util.List" %>
<%@ include file="../../header.html" %>

<%
    Users loginUser = (Users) session.getAttribute("user");
    String userType = (loginUser != null && loginUser.getUsersTypeId() != null) ? loginUser.getUsersTypeId().trim() : "";
%>

<%-- メニューの動的切り替え --%>
<% if ("2".equals(userType)) { %>
    <jsp:include page="../../tabematch/main/shop_menu.jsp" />
<% } else { %>
    <jsp:include page="user_menu.jsp" />
<% } %>

<%--
  注意：<html><head>などはheader.htmlに含まれているため、ここでは書かないのが正解です。
  読み込ませたいCSSだけここに記述します。
--%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_prof_v.css?v=<%= System.currentTimeMillis() %>">

<div class="container">
    <h2 class="text-center">プロフィール確認</h2>

    <% String msg = (String) request.getAttribute("errorMessage"); %>
    <% if (msg != null) { %>
        <div class="alert alert-danger"><%= msg %></div>
    <% } %>

    <%
        Users user = (Users) request.getAttribute("user");
        if (user != null) {
            List<Allergen> aList = (List<Allergen>) request.getAttribute("allergenList");
    %>

    <div class="card">
        <div class="card-body">
            <table>
                <tr>
                    <th>ユーザー名</th>
                    <td><%= user.getUserName() %></td>
                </tr>
                <tr>
                    <th>メールアドレス</th>
                    <td><%= user.getUserId() %></td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>********</td>
                </tr>
                <tr>
                    <th>アレルギー</th>
                    <td>
                        <%
                            if (aList != null && !aList.isEmpty()) {
                                for (int i = 0; i < aList.size(); i++) {
                        %>
                                    <%= aList.get(i).getAllergenName() %><%= (i < aList.size() - 1) ? "・" : "" %>
                        <%
                                }
                            } else {
                        %>
                                アレルギーなし
                        <% } %>
                    </td>
                </tr>
            </table>

            <div class="btn">
                <a href="UserProfile.action" class="btn-hensyu">プロフィールを編集</a>
                <a href="search.jsp" class="btn-modoru">戻る</a>
            </div>
        </div>
    </div>

    <% } else { %>
        <div class="alert alert-warning">ユーザー情報が見つかりません。</div>
    <% } %>
</div>

<%@ include file="../../footer.html" %>
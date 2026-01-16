<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<html>
<head>
<title>プロフィール確認</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_prof_v.css">
</head>
<body>
<div class="container">
    <h2 class="text-center">プロフィール確認</h2>

    <% String msg = (String) request.getAttribute("errorMessage"); %>
    <% if (msg != null) { %>
        <div class="alert alert-danger"><%= msg %></div>
    <% } %>

    <%
        bean.Users user = (bean.Users) request.getAttribute("user");
        if (user != null) {
    %>

    <div class="card">
        <div class="card-body">
            <table>
                <tr>
                    <th style="width:30%;">ユーザー名</th>
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
                    <%
                        String allergen = user.getAllergenId();
                        if (allergen != null && !allergen.isEmpty()) {
                            String display = allergen
                                .replace("A01", "卵")
                                .replace("A02", "乳")
                                .replace("A03", "小麦")
                                .replace("A04", "えび")
                                .replace("A05", "かに")
                                .replace("A06", "そば");
                    %>
                        <td><%= display.replace(",", "・") %></td>
                    <%
                        } else {
                    %>
                        <td>なし</td>
                    <% } %>
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
</body>
</html>

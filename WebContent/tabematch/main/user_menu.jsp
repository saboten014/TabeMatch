<%@ page session="true" pageEncoding="UTF-8" import="bean.Users" %>
<%
  String contextPath = request.getContextPath();
  Users loginUser = (Users) session.getAttribute("user");
%>
<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_menu.css">

<div class="header">
    <div class="logo">たべまっち</div>
    <div class="nav-links">
      <%
        if (loginUser != null) {
          // ログイン済み
      %>
        <a href="<%= contextPath %>">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">店舗検索</a>
        <a href="<%= contextPath %>/tabematch/main/FavoriteList.action">お気に入り</a>
        <a href="<%= contextPath %>">プロフィール</a>
        <a href="<%= contextPath %>/tabematch/main/ReservationList.action">予約管理</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <%
        } else {
          // 非ログイン時
      %>
        <a href="<%= contextPath %>/tabematch/News.action">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">検索</a>
        <a href="<%= contextPath %>/tabematch/login.jsp">ログイン</a>
      <%
        }
      %>
    </div>
  </div>
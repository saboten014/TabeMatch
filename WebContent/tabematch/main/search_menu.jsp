<%@page pageEncoding="UTF-8" %>
<%@page import="bean.Users" %>
<%
  // コンテキストパスを取得
  String contextPath = request.getContextPath();
  // ログイン状態を確認
  Users loginUser = (Users)session.getAttribute("user");
  boolean isLoggedIn = (loginUser != null);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>店舗検索 | たべまっち</title>
<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<style>
  body {
    margin: 0;
    padding: 0;
    background-color: #e8f8e8; /* 全体の淡い緑 */
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
  }
  /* ヘッダー全体 */
  .header {
    background-color: #d2f0d0; /* 少し濃い緑 */
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 40px;
    border-bottom: 2px solid #b2d8b0;
  }
  /* 左側ロゴ */
  .logo {
    font-size: 36px;
    color: white;
    text-shadow:
      -2px -2px 0 #ff9966,
      2px -2px 0 #ff9966,
      -2px 2px 0 #ff9966,
      2px 2px 0 #ff9966; /* オレンジ縁取り */
  }
  /* 右側ナビゲーション */
  .nav-links {
    display: flex;
    flex-direction: row;
    align-items: center;
    flex-wrap: nowrap;
  }
  .nav-links a {
    margin-left: 25px;
    text-decoration: none;
    color: #333;
    font-weight: 500;
    font-size: 16px;
    white-space: nowrap;
  }
  .nav-links a:hover {
    text-decoration: underline;
  }
  hr {
    border: none;
    border-top: 1px solid #b2d8b0;
    margin: 0;
  }
</style>
</head>
<body>
  <div class="header">
    <div class="logo">たべまっち</div>
    <div class="nav-links">
      <% if (isLoggedIn) { %>
        <!-- ログイン時のメニュー -->
        <a href="<%= contextPath %>/tabematch/News.action">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">店舗検索</a>
        <a href="">お気に入り</a>
        <a href="">プロフィール</a>
        <a href="">予約管理</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <% } else { %>
        <!-- 非ログイン時のメニュー -->
        <a href="">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">店舗検索</a>
        <a href="<%= contextPath %>/tabematch/login.jsp">ログイン</a>
      <% } %>
    </div>
  </div>
  <hr>
</body>
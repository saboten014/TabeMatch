<%@ page session="true" pageEncoding="UTF-8" import="bean.Users" %>
<%
  String contextPath = request.getContextPath();
  Users loginUser = (Users) session.getAttribute("user");
%>
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
    background-color: #d2f0d0 !important;
    display: flex !important;
    justify-content: space-between !important;
    align-items: center !important;
    padding: 15px 40px !important;
    border-bottom: 2px solid #b2d8b0 !important;
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    width: 100% !important;
    box-sizing: border-box !important;
    z-index: 100 !important;
  }
  /* 左側ロゴ */
  .logo {
    font-size: 36px;
    color: white;
    text-shadow:
      -2px -2px 0 #ff9966,
       2px -2px 0 #ff9966,
      -2px  2px 0 #ff9966,
       2px  2px 0 #ff9966;
    white-space: nowrap;
  }
  /* 右側ナビゲーション - 横並び強制 */
  .nav-links {
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    flex-wrap: nowrap !important;
  }
  .nav-links a {
    display: inline-block !important;
    margin-left: 25px !important;
    text-decoration: none !important;
    color: #333 !important;
    font-weight: 500 !important;
    font-size: 16px !important;
    white-space: nowrap !important;
  }
  .nav-links a:hover {
    text-decoration: underline !important;
  }
  hr {
    border: none;
    border-top: 1px solid #b2d8b0;
    margin: 0;
  }
  /* 全ページ共通：h1がヘッダーに隠れないように */
  h1 {
    margin-top: 120px !important;
    padding-top: 20px !important;
  }
</style>
<div class="header">
    <div class="logo">たべまっち</div>
    <div class="nav-links">
      <%
        if (loginUser != null) {
          // ログイン済み
      %>
        <a href="<%= contextPath %>">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">店舗検索</a>
        <a href="<%= contextPath %>">お気に入り</a>
        <a href="<%= contextPath %>">プロフィール</a>
        <a href="<%= contextPath %>">予約管理</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <%
        } else {
          // 非ログイン時
      %>
        <a href="<%= contextPath %>">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">検索</a>
        <a href="<%= contextPath %>/tabematch/login.jsp">ログイン</a>
      <%
        }
      %>
    </div>
  </div>
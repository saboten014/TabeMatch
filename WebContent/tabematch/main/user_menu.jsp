<%@page pageEncoding="UTF-8" %>

<style>
  .header {
    display: flex;
    justify-content: space-between; /* 左右に分ける */
    align-items: center; /* 上下中央揃え */
    padding: 10px;
  }
  .nav-links a {
    margin-left: 15px;
    text-decoration: none;
  }
</style>

<div class="header">
  <div class="logo">たべまっち</div>
  <div class="nav-links">
    <a href="">お知らせ</a>
    <a href="search.jsp">店舗検索</a>
    <a href="">お気に入り</a>
    <a href="">プロフィール</a>
    <a href="">予約管理</a>
    <a href="Logout.action">ログアウト</a>
  </div>
</div>

<hr>
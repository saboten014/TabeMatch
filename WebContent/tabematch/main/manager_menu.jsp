<%@page pageEncoding="UTF-8" %>

<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
  /* ヘッダー部分だけ残す */
  .header {
    background-color: #d2f0d0; /* 少し濃い緑 */
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 40px;
    border-bottom: 2px solid #b2d8b0;
  }

  .logo {
    font-size: 36px;
    color: white;
    text-shadow:
      -2px -2px 0 #ff9966,
      2px -2px 0 #ff9966,
      -2px 2px 0 #ff9966,
      2px 2px 0 #ff9966;
  }

  .nav-links a {
    margin-left: 25px;
    text-decoration: none;
    color: #333;
    font-weight: 500;
    font-size: 16px;
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

<div class="header">
  <div class="logo">たべまっち 管理者ホーム</div>
  <div class="nav-links">
    <a href="Logout.action">ログアウト</a>
  </div>
</div>

<hr>

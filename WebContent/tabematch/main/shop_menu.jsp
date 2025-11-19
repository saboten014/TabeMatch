<%@page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>店舗メニュー | たべまっち</title>

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
      2px 2px 0 #ff9966;
  }

  /* 右側ナビゲーション */
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
</head>

<body>

  <div class="header">
    <div class="logo">たべまっち</div>
    <div class="nav-links">
      <a href="${pageContext.request.contextPath}/tabematch/News.action">お知らせ</a>
      <a href="${pageContext.request.contextPath}/tabematch.shop/">予約管理</a>
      <a href="${pageContext.request.contextPath}/tabematch.shop/ShopProfile.action">店舗プロフィール</a>
      <a href="${pageContext.request.contextPath}/tabematch/main/Logout.action">ログアウト</a>
    </div>
  </div>

  <hr>

</body>
</html>

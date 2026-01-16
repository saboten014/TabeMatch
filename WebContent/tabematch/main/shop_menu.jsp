<%@ page session="true" pageEncoding="UTF-8" import="bean.Users" %>
<%
  // contextPathの取得
  String contextPath = request.getContextPath();
  Users loginUser = (Users) session.getAttribute("user");

  // ユーザー種別 (usersTypeId) を取得するための変数
  String userType = null;

  if (loginUser != null) {
      // ★★★  usersTypeIdを文字列として取得 ★★★
      userType = loginUser.getUsersTypeId();
  }
  // else (loginUser == null) の場合、userTypeは初期値の null のまま

  // CSS切り替えのために、userTypeを整数値に変換（ここでは簡略化）
  int authorityForCss = 0;
  if (userType != null) {
    try {
        authorityForCss = Integer.parseInt(userType.trim());
    } catch (NumberFormatException e) {
        authorityForCss = 0;
    }
  }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>店舗メニュー | たべまっち</title>

<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>


  /* ヘッダー全体 */
  .header {
    background-color: #d2f0d0; /* 少し濃い緑 */
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 40px;
    border-bottom: 2px solid #b2d8b0;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    width: 100%;
    box-sizing: border-box;
    z-index: 100;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
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

    margin: 0;
  }
</style>
</head>

<body>

  <div class="header">
    <div class="logo">たべまっち</div>
    <% // ログイン時のみユーザー名を表示（userTypeがnullでない場合）
          if (userType != null) { %>
            <span class="user-name" style="display: inline-block; margin-left: 40px; font-size: 20px; color: #444; font-weight: 600; font-family: 'Kosugi Maru', 'Hiragino Kaku Gothic ProN', 'Meiryo', sans-serif; letter-spacing: 1px;"><%= loginUser.getUserName() %>さん</span>
          <% } %>
    <div class="nav-links">
	  <a href="${pageContext.request.contextPath}/tabematch.shop/ShopManagement.action">ホーム</a>
      <a href="${pageContext.request.contextPath}/tabematch/News.action">お知らせ</a>
      <a href="${pageContext.request.contextPath}/tabematch/shop/ShopReservationList.action">予約管理</a>
      <a href="${pageContext.request.contextPath}/tabematch.shop/ShopProfile.action">店舗プロフィール</a>
      <a href="${pageContext.request.contextPath}/tabematch/main/Logout.action">ログアウト</a>
    </div>
  </div>

  <hr>

</body>
</html>

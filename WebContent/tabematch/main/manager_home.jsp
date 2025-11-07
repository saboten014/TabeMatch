<%@page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>管理者ホーム | たべまっち</title>
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

  body {
    background-color: #e8f8e8;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    text-align: center;
  }

  /* ===== 共通ボタンスタイル ===== */
  button {
    font-family: inherit;
    cursor: pointer;
    border-radius: 14px;
    border: 2px solid #aaa;
    background-color: white;
    color: black;
    transition: background-color 0.3s, color 0.3s, transform 0.2s, border-color 0.3s;
  }

  button:hover {
    transform: scale(1.07);
  }

  /* ===== メインボタン ===== */
  .main-btn {
    padding: 25px 70px;
    font-size: 24px;
    margin: 20px;
  }

  /* ホバー時の色変化 */
  .user-btn:hover {
    background-color: #ff4d4d;
    color: white;
    border-color: #ff4d4d;
  }

  .store-btn:hover {
    background-color: #ffcc00;
    color: black;
    border-color: #ffcc00;
  }

  .admin-btn:hover {
    background-color: #3399ff;
    color: white;
    border-color: #3399ff;
  }

  /* ===== 機能ボタンエリア ===== */
  .feature-box {
    display: none;
    margin: 35px auto;
    padding: 35px;
    border-radius: 15px;
    width: 65%;
  }

  .user-box {
    border: 2px solid #ffb3b3;
    background-color: #ffe5e5;
  }

  .store-box {
    border: 2px solid #ffe680;
    background-color: #fff8cc;
  }

  .admin-box {
    border: 2px solid #99ccff;
    background-color: #e6f3ff;
  }

  /* ===== 機能ボタン ===== */
  .feature-btn {
    display: inline-block;
    margin: 20px;
    padding: 20px 50px;
    font-size: 20px;
  }

  /* 機能ボタンのホバー色統一 */
  .user-feature:hover {
    background-color: #ff4d4d;
    color: white;
    border-color: #ff4d4d;
  }

  .store-feature:hover {
    background-color: #ffcc00;
    color: black;
    border-color: #ffcc00;
  }

  .admin-feature:hover {
    background-color: #3399ff;
    color: white;
    border-color: #3399ff;
  }

</style>

<script>
function showMenu(type) {
  document.querySelectorAll('.feature-box').forEach(box => box.style.display = 'none');
  document.querySelector('.' + type + '-box').style.display = 'block';
}
</script>
</head>

<body>

<%@include file="manager_menu.jsp" %>

  <h2>管理者ホーム</h2>

  <!-- メインボタン -->
  <button class="main-btn user-btn" onclick="showMenu('user')">ユーザー</button>
  <button class="main-btn store-btn" onclick="showMenu('store')">店舗</button>
  <button class="main-btn admin-btn" onclick="showMenu('admin')">管理者</button>

  <!-- 機能ボタン枠 -->
  <div class="feature-box user-box">
    <button class="feature-btn user-feature">ユーザー管理</button>
  </div>

  <div class="feature-box store-box">
    <button class="feature-btn store-feature">掲載リクエスト承認</button>
    <button class="feature-btn store-feature">店舗管理</button>
  </div>

  <div class="feature-box admin-box">
    <button class="feature-btn admin-feature">管理者アカウント追加</button>
    <button class="feature-btn admin-feature">お知らせ配信</button>
  </div>

</body>
</html>

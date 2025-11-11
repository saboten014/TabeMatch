<%@page pageEncoding="UTF-8" %>
<%@include file="admin_menu.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>管理者ホーム | たべまっち</title>

<style>
  body {
    background-color: #e8f8e8;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    text-align: center;
    padding-top: 50px;
  }

  /* ===== 共通ボタンスタイル ===== */
  button, a.btn-link {
    font-family: inherit;
    cursor: pointer;
    border-radius: 14px;
    border: 2px solid #aaa;
    background-color: white;
    color: black;
    transition: background-color 0.3s, color 0.3s, transform 0.2s, border-color 0.3s;
    text-decoration: none;
    display: inline-block;
  }

  button:hover, a.btn-link:hover {
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

  .shop-btn:hover {
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

  .shop-box {
    border: 2px solid #ffe680;
    background-color: #fff8cc;
  }

  .admin-box {
    border: 2px solid #99ccff;
    background-color: #e6f3ff;
  }

  /* ===== 機能ボタン ===== */
  .feature-btn, a.btn-link {
    margin: 20px;
    padding: 20px 50px;
    font-size: 20px;
    border-radius: 10px;
    border: 2px solid #aaa;
  }

  /* ホバー色統一 */
  .user-feature:hover {
    background-color: #ff4d4d;
    color: white;
    border-color: #ff4d4d;
  }

  .shop-feature:hover {
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
  <h2>管理者ホーム</h2>

  <!-- メインボタン -->
  <button class="main-btn user-btn" onclick="showMenu('user')">ユーザー</button>
  <button class="main-btn shop-btn" onclick="showMenu('shop')">店舗</button>
  <button class="main-btn admin-btn" onclick="showMenu('admin')">管理者</button>

  <!-- 機能ボタン枠 -->
  <div class="feature-box user-box">
    <a href="" class="btn-link feature-btn user-feature">ユーザー管理</a>
  </div>

  <div class="feature-box shop-box">
    <a href="" class="btn-link feature-btn shop-feature">掲載リクエスト承認</a>
    <a href="" class="btn-link feature-btn shop-feature">店舗管理</a>
  </div>

  <div class="feature-box admin-box">
    <a href="" class="btn-link feature-btn admin-feature">管理者アカウント追加</a>
    <a href="" class="btn-link feature-btn admin-feature">お知らせ配信</a>
  </div>

</body>
</html>

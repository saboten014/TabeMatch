<%@page pageEncoding="UTF-8" %>

<!-- ヘッダー読込 -->
<%@include file="../../header.html" %>
<!-- 管理者メニューバー -->
<%@include file="user_menu.jsp" %>

<!-- 丸文字フォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_home.css">


<script>
function showMenu(type) {
  document.querySelectorAll('.feature-box').forEach(box => box.style.display = 'none');
  document.querySelector('.' + type + '-box').style.display = 'block';
}
</script>

<h2>管理者ホーム</h2>

<!-- メインボタン -->
<button class="main-btn user-btn" onclick="showMenu('user')">ユーザー</button>
<button class="main-btn shop-btn" onclick="showMenu('shop')">店舗</button>
<button class="main-btn admin-btn" onclick="showMenu('admin')">管理者</button>

<!-- ===== 機能ボタン枠 ===== -->
<!-- ユーザー系 -->
<div class="feature-box user-box">
  <a href="../admin/AdminUserList.action" class="btn-link feature-btn user-feature">ユーザー管理</a>
</div>

<!-- 店舗系 -->
<div class="feature-box shop-box">
  <a href="../admin/AdminRequestList.action" class="btn-link feature-btn shop-feature">掲載リクエスト承認</a>
  <a href="" class="btn-link feature-btn shop-feature">店舗管理</a>
</div>

<!-- 管理者系 -->
<div class="feature-box admin-box">
  <a href="../admin/AdminInsertForm.action" class="btn-link feature-btn admin-feature">管理者アカウント追加</a>
  <a href="<%= request.getContextPath() %>/tabematch/News.action" class="btn-link feature-btn admin-feature">お知らせ配信</a>
</div>

<!-- フッター -->
<%@include file="../../footer.html" %>

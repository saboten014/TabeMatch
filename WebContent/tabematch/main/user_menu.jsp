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
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_menu.css">


<div class="header">
    <div class="header-left" style="display: flex; align-items: center; flex-direction: row;">

      <%
        if ("3".equals(userType)) { // ★★★ 修正箇所2: 文字列 "3" と比較 ★★★
          // 管理者のロゴ/タイトル
      %>
          <div class="logo">たべまっち　管理者ホーム</div>
      <%
        } else {
          // 一般・店舗ユーザーのロゴ/タイトル
      %>
          <div class="logo" style="display: inline-block;">たべまっち</div>
          <% // ログイン時のみユーザー名を表示（userTypeがnullでない場合）
          if (userType != null) { %>
            <span class="user-name" style="display: inline-block; margin-left: 40px; font-size: 20px; color: #444; font-weight: 600; font-family: 'Kosugi Maru', 'Hiragino Kaku Gothic ProN', 'Meiryo', sans-serif; letter-spacing: 1px;"><%= loginUser.getUserName() %>さん</span>
          <% } %>
      <%
        }
      %>
    </div>

    <div class="nav-links">
      <%
        if ("3".equals(userType)) {
          // ===============================================
          // ★★★ 管理者向けメニュー (usersTypeId = "3") ★★★
          // ===============================================
      %>
        <a href="<%= contextPath %>/tabematch/main/admin_home.jsp">ホーム</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <%
        } else if ("2".equals(userType)) {
          // ===============================================
          // ★★★ 店舗管理者向けメニュー (usersTypeId = "2") ★★★
          // ===============================================
      %>
        <a href="<%= contextPath %>/tabematch/News.action">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/shop/ReserveManagement.action">予約管理</a>
        <a href="<%= contextPath %>/tabematch/shop/ShopProfile.action">店舗プロフィール</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <%
        } else if ("1".equals(userType)) {
          // ===============================================
          // ★★★ 一般ユーザー向けメニュー (usersTypeId = "1") ★★★
          // ===============================================
      %>
        <a href="<%= contextPath %>/tabematch/News.action">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">店舗検索</a>
        <a href="<%= contextPath %>/tabematch/main/FavoriteList.action">お気に入り</a>
        <a href="<%= contextPath %>/tabematch/main/ReservationList.action">予約管理</a>
        <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
      <%
        } else {
          // ===============================================
          // ★★★ 未ログイン時メニュー (userType = null またはその他) ★★★
          // ===============================================
      %>
        <a href="<%= contextPath %>/tabematch/News.action">お知らせ</a>
        <a href="<%= contextPath %>/tabematch/main/search.jsp">検索</a>
        <a href="<%= contextPath %>/tabematch/login.jsp">ログイン</a>
      <%
        }
      %>
    </div>
</div>

<hr class="header-line">
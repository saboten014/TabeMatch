<%@page pageEncoding="UTF-8" %>
<%
  String contextPath = request.getContextPath();
%>
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin_menu.css">


<div class="header">
  <div class="logo">たべまっち　管理者ホーム</div>
  <div class="nav-links">
    <a href="<%= contextPath %>/tabematch/main/Logout.action">ログアウト</a>
  </div>
</div>

<hr class="header-line">
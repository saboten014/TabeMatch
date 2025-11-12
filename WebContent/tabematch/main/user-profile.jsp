<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../../header.html" %>
<html>
<head>
<title>プロフィール編集</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
<h2 class="text-center mb-4">プロフィール編集</h2>

<% String error = (String) request.getAttribute("errorMessage"); %>
<% if (error != null) { %>
  <div class="alert alert-danger"><%= error %></div>
<% } %>

<%
    bean.Users user = (bean.Users) request.getAttribute("user");
    String[] allergenValues = user.getAllergenId() != null ? user.getAllergenId().split(",") : new String[]{};

    java.util.List<bean.Allergen> allergenList = (java.util.List<bean.Allergen>) request.getAttribute("allergenList");
%>

<form action="UserProfile.action?mode=update" method="post" class="card p-4 shadow-sm">
  <div class="mb-3">
    <label class="form-label">ユーザー名</label>
    <input type="text" class="form-control" name="userName" value="<%= user.getUserName() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">メールアドレス</label>
    <input type="email" class="form-control" name="userMail" value="<%= user.getUserId() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">パスワード</label>
    <input type="password" class="form-control" name="password" value="<%= user.getPassword() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">パスワード（確認）</label>
    <input type="password" class="form-control" name="confirmPassword" required>
  </div>

  <!-- ✅ アレルゲン情報をDBから動的にチェックボックス表示 -->
  <div class="mb-3">
    <label class="form-label">アレルギー</label><br>
    <%
      if (allergenList != null && !allergenList.isEmpty()) {
          for (bean.Allergen allergen : allergenList) {
              boolean checked = java.util.Arrays.asList(allergenValues).contains(allergen.getAllergenId());
    %>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="allergen"
                   value="<%= allergen.getAllergenId() %>" <%= checked ? "checked" : "" %>>
            <label class="form-check-label"><%= allergen.getAllergenName() %></label>
          </div>
    <%
          }
      } else {
    %>
      <p>アレルゲン情報を取得できませんでした。</p>
    <% } %>
  </div>

  <div class="text-center">
    <button type="submit" class="btn btn-primary">更新</button>
  </div>
</form>
</div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../../header.html" %>
<html>
<head>
<title>店舗情報編集</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
<h2 class="text-center mb-4">店舗情報編集</h2>

<% String error = (String) request.getAttribute("errorMessage"); %>
<% if (error != null) { %>
  <div class="alert alert-danger"><%= error %></div>
<% } %>

<%
    bean.Shop shop = (bean.Shop) request.getAttribute("shop");
%>

<form action="ShopProfile.action?mode=update" method="post" class="card p-4 shadow-sm">
  <div class="mb-3">
    <label class="form-label">店舗名</label>
    <input type="text" class="form-control" name="shopName" value="<%= shop.getShopName() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">住所</label>
    <input type="text" class="form-control" name="shopAddress" value="<%= shop.getShopAddress() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">電話番号</label>
    <input type="text" class="form-control" name="shopTel" value="<%= shop.getShopTel() %>" required>
  </div>

  <div class="mb-3">
    <label class="form-label">URL</label>
    <input type="text" class="form-control" name="shopUrl" value="<%= shop.getShopUrl() %>">
  </div>

  <div class="mb-3">
    <label class="form-label">対応可能食材</label>
    <input type="text" class="form-control" name="shopAllergy" value="<%= shop.getShopAllergy() %>">
  </div>

  <div class="text-center">
    <button type="submit" class="btn btn-primary">更新</button>
  </div>
</form>
</div>
</body>
</html>

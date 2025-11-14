<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Shop" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>
<%
    Shop shop = (Shop) request.getAttribute("shop");
    if (shop == null) {
%>
    <div class="container mt-4">
        <div class="alert alert-danger">店舗情報が取得できませんでした。</div>
        <a href="search.jsp">店舗検索に戻る</a>
    </div>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>予約フォーム | たべまっち</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">予約フォーム</h2>

    <div class="card mb-4">
        <div class="card-header bg-success text-white">
            予約店舗
        </div>
        <div class="card-body">
            <p class="mb-1"><strong>店舗名：</strong><%= shop.getShopName() %></p>
            <p class="mb-1"><strong>住所：</strong><%= shop.getShopAddress() %></p>
            <p class="mb-1"><strong>電話番号：</strong><%= shop.getShopTel() %></p>
            <p class="mb-0"><strong>予約可否：</strong><%= shop.getShopReserve() != null ? shop.getShopReserve() : "未登録" %></p>
        </div>
    </div>

    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div class="alert alert-danger"><%= errorMessage %></div>
    <%
        }
    %>

    <form method="post" action="ReserveExecute.action">
        <input type="hidden" name="shopId" value="<%= shop.getShopId() %>">
        <div class="mb-3">
            <label class="form-label">来店日<span class="text-danger">*</span></label>
            <input type="date" name="visitDate" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">来店時間<span class="text-danger">*</span></label>
            <input type="time" name="visitTime" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">人数<span class="text-danger">*</span></label>
            <input type="number" name="numOfPeople" min="1" class="form-control" placeholder="例：2" required>
        </div>
        <div class="mb-3">
            <label class="form-label">アレルギーに関するご要望</label>
            <textarea name="allergyNotes" class="form-control" rows="3" placeholder="避けたい食材や症状など"></textarea>
        </div>
        <div class="mb-4">
            <label class="form-label">その他のリクエスト</label>
            <textarea name="message" class="form-control" rows="3" placeholder="例：子ども椅子希望"></textarea>
        </div>
        <div class="d-flex gap-3">
            <a href="ShopDetail.action?shopId=<%= shop.getShopId() %>" class="btn btn-secondary">戻る</a>
            <button type="submit" class="btn btn-success">予約を送信する</button>
        </div>
    </form>
</div>
</body>
</html>
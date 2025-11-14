<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Reserve" %>
<%@ page import="bean.Shop" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>
<%
    Reserve reserve = (Reserve) request.getAttribute("reserve");
    Shop shop = (Shop) request.getAttribute("shop");
%>
<!DOCTYPE html>
<html>
<head>
    <title>予約完了 | たべまっち</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <div class="alert alert-success">
        予約を受け付けました。店舗からの連絡をお待ちください。
    </div>

    <div class="card">
        <div class="card-header bg-success text-white">予約内容</div>
        <div class="card-body">
            <p><strong>店舗名：</strong><%= shop != null ? shop.getShopName() : reserve.getShopName() %></p>
            <p><strong>来店日：</strong><%= reserve.getVisitDate() %></p>
            <p><strong>来店時間：</strong><%= reserve.getVisitTime() %></p>
            <p><strong>人数：</strong><%= reserve.getNumOfPeople() %> 名</p>
            <p><strong>アレルギー要望：</strong><%= reserve.getAllergyNotes() != null ? reserve.getAllergyNotes() : "なし" %></p>
            <p><strong>その他リクエスト：</strong><%= reserve.getMessage() != null ? reserve.getMessage() : "なし" %></p>
            <p><strong>ステータス：</strong><%= reserve.getStatus() %></p>
        </div>
    </div>

    <div class="mt-4">
        <a href="ReservationList.action" class="btn btn-primary me-2">予約一覧を確認</a>
        <a href="search.jsp" class="btn btn-outline-secondary">店舗検索に戻る</a>
    </div>
</div>
</body>
</html>
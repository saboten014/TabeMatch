<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Reserve" %>
<%@ page import="bean.Shop" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>
<%
    Reserve reserve = (Reserve) session.getAttribute("completedReserve");
    Shop shop = (Shop) session.getAttribute("completedShop");

    // 表示後は即座に削除（リロード対策）
    session.removeAttribute("completedReserve");
    session.removeAttribute("completedShop");

    // セッションにデータがない場合は検索画面にリダイレクト
    if (reserve == null || shop == null) {
        response.sendRedirect(request.getContextPath() + "/tabematch/main/search.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>予約完了 | たべまっち</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-comp.css">
</head>
<body>
<div class="container">
    <div class="success">
        予約を受け付けました。店舗からの連絡をお待ちください。
    </div>

   <div class="card">
    <div class="card-header">予約内容</div>
    <div class="card-body">
        <table style="width: 80%; border-collapse: collapse;">
            <tr>
                <th style="width: 30%; text-align: left;">店舗名</th>
                <td><%= shop != null ? shop.getShopName() : reserve.getShopName() %></td>
            </tr>
            <tr>
                <th>来店日</th>
                <td><%= reserve.getVisitDate() %></td>
            </tr>
            <tr>
                <th>来店時間</th>
                <td><%= reserve.getVisitTime() %></td>
            </tr>
            <tr>
                <th>人数</th>
                <td><%= reserve.getNumOfPeople() %> 名</td>
            </tr>
            <tr>
                <th>アレルギー要望</th>
                <td><%= reserve.getAllergyNotes() != null ? reserve.getAllergyNotes() : "なし" %></td>
            </tr>
            <tr>
                <th>その他リクエスト</th>
                <td><%= reserve.getMessage() != null ? reserve.getMessage() : "なし" %></td>
            </tr>
            <tr>
                <th>ステータス</th>
                <td><%= reserve.getStatus() %></td>
            </tr>
        </table>
    </div>
</div>

    <div class="btn">
        <a href="ReservationList.action" class="yoyaku_itiran">予約一覧を確認</a>
        <a href="search.jsp" class="modoru">店舗検索に戻る</a>
    </div>
</div>
</body>
</html>
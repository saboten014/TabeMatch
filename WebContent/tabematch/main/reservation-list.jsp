<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reserve" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>
<%
    List<Reserve> reservations = (List<Reserve>) request.getAttribute("reservations");
%>
<!DOCTYPE html>
<html>
<head>
    <title>予約一覧 | たべまっち</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">予約管理</h2>

    <% if (reservations == null || reservations.isEmpty()) { %>
        <div class="alert alert-info">現在登録されている予約はありません。</div>
        <a href="search.jsp" class="btn btn-outline-primary">店舗を探す</a>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>店舗名</th>
                        <th>来店日</th>
                        <th>来店時間</th>
                        <th>人数</th>
                        <th>ステータス</th>
                        <th>要望</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Reserve reserve : reservations) { %>
                    <tr>
                        <td><%= reserve.getShopName() != null ? reserve.getShopName() : reserve.getShopId() %></td>
                        <td><%= reserve.getVisitDate() %></td>
                        <td><%= reserve.getVisitTime() %></td>
                        <td><%= reserve.getNumOfPeople() %> 名</td>
                        <td><span class="badge bg-secondary"><%= reserve.getStatus() %></span></td>
                        <td>
                            <div><strong>アレルギー:</strong> <%= reserve.getAllergyNotes() != null ? reserve.getAllergyNotes() : "-" %></div>
                            <div><strong>その他:</strong> <%= reserve.getMessage() != null ? reserve.getMessage() : "-" %></div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>
</body>
</html>
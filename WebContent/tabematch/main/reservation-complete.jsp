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
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation-comp.css?v=<%= System.currentTimeMillis() %>">

<div class="comp-container">
    <div class="success-header">
        <div class="check-icon">🎉</div>
        <h1>予約を受け付けました！</h1>
        <p>お店からの承認をお待ちください。✨</p>
    </div>

    <div class="info-card">
        <div class="card-title">ご予約内容の確認</div>

        <div class="info-list">
            <div class="info-item">
                <span class="label">店舗名</span>
                <span class="value shop-name"><%= shop != null ? shop.getShopName() : reserve.getShopName() %></span>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <span class="label">来店日</span>
                    <span class="value">📅 <%= reserve.getVisitDate() %></span>
                </div>
                <div class="info-item">
                    <span class="label">来店時間</span>
                    <span class="value">⏰ <%= reserve.getVisitTime() %></span>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <span class="label">人数</span>
                    <span class="value">👥 <%= reserve.getNumOfPeople() %> 名様</span>
                </div>
                <div class="info-item tel-item">
                    <span class="label">ご連絡先</span>
                    <span class="value">📞 <%= (reserve.getReserveTel() != null && !reserve.getReserveTel().isEmpty()) ? reserve.getReserveTel() : "未登録" %></span>
                </div>
            </div>

            <div class="info-item">
                <span class="label">食材要望</span>
                <span class="value"><%= (reserve.getAllergyNotes() != null && !reserve.getAllergyNotes().isEmpty()) ? reserve.getAllergyNotes() : "特になし" %></span>
            </div>

            <div class="info-item">
                <span class="label">その他リクエスト</span>
                <span class="value"><%= (reserve.getMessage() != null && !reserve.getMessage().isEmpty()) ? reserve.getMessage() : "メッセージなし" %></span>
            </div>
        </div>
    </div>

    <div class="action-buttons">
        <a href="ReservationList.action" class="btn-list">予約一覧を確認する</a>
        <a href="search.jsp" class="btn-back">店舗検索に戻る</a>
    </div>
</div>

<%@ include file="../../footer.html" %>
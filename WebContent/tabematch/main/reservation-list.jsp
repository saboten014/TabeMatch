<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<jsp:include page="user_menu.jsp" />

<!DOCTYPE html>
<html>
<head>
    <title>予約一覧</title>
    <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-list.css">
</head>
<body>

<div class="reservation-container">
    <div class="page-header">
        <h1>🍴 予約マイリスト</h1>
        <p>予約状況をこちらから確認できます ✨</p>
    </div>

    <c:choose>
        <c:when test="${empty reserveList}">
            <div class="empty-state">
                <p>現在、予約はありません ☕</p>
                <div class="button-container">
                    <a href="search.jsp" class="back-btn">お店を探しにいく</a>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="reserve-grid">
                <c:forEach var="r" items="${reserveList}">
                    <div class="reserve-card">
                        <div class="status-section">
                            <c:choose>
                                <c:when test="${r.reserveStatus == 1}">
                                    <span class="status-badge status-waiting">⏳ 承認待ち</span>
                                </c:when>
                                <c:when test="${r.reserveStatus == 2}">
                                    <span class="status-badge status-success">✅ 予約確定</span>
                                </c:when>
                                <c:when test="${r.reserveStatus == 3}">
                                    <span class="status-badge status-error">❌ 拒否/キャンセル</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-unknown">❓ 不明</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-content">
                            <h2 class="shop-name">🏢 ${r.shopName}</h2>

                            <div class="info-row">
                                <span class="icon">📅</span>
                                <span class="text"><strong>来店日:</strong> ${r.visitDate}</span>
                            </div>
                            <div class="info-row">
                                <span class="icon">⏰</span>
                                <span class="text"><strong>時間:</strong> ${r.visitTime}〜</span>
                            </div>
                            <div class="info-row">
                                <span class="icon">👥</span>
                                <span class="text"><strong>人数:</strong> ${r.numOfPeople} 名様</span>
                            </div>

                            <div class="info-row tel-row">
                                <span class="icon">📞</span>
                                <span class="text"><strong>連絡先:</strong>
                                    <c:choose>
                                        <c:when test="${not empty r.reserveTel}">${r.reserveTel}</c:when>
                                        <c:otherwise><span class="no-data">未登録</span></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <c:if test="${not empty r.allergyNotes}">
                                <div class="allergy-box">
                                    <strong>⚠️ 要配慮食材情報</strong>
                                    <p>${r.allergyNotes}</p>
                                </div>
                            </c:if>

                            <c:if test="${not empty r.message}">
                                <div class="message-box">
                                    <strong>✉️ メッセージ</strong>
                                    <p>${r.message}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="button-container" style="margin-top: 40px;">
                <a href="search.jsp" class="back-btn">店舗検索ページに戻る</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
<%@ include file="../../footer.html" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<html>
<head>
<title>予約一覧</title>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-list.css">

</head>
<body>
<div>
  <h2>あなたの予約一覧</h2>

  <c:if test="${empty reserveList}">
    <div class="no-yoyaku">現在、予約はありません。</div>
  </c:if>

  <c:if test="${not empty reserveList}">
    <table>
      <thead>
        <tr>
          <th>店舗名</th>
          <th>来店日</th>
          <th>来店時間</th>
          <th>人数</th>
          <th>アレルギー</th>
          <th>備考</th>
          <th>予約状態</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${reserveList}">
          <tr>
            <td>${r.shopName}</td>
            <td>${r.visitDate}</td>
            <td>${r.visitTime}</td>
            <td>${r.numOfPeople}</td>
            <td>${r.allergyNotes}</td>
            <td>${r.message}</td>
            <td>
              <c:choose>
                <c:when test="${r.reserveStatus == 1}">
                  <span>承認待ち</span>
                </c:when>
                <c:when test="${r.reserveStatus == 2}">
                  <span>承認済み</span>
                </c:when>
                <c:when test="${r.reserveStatus == 3}">
                  <span>拒否</span>
                </c:when>
                <c:otherwise>
                  <span>不明</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>
</body>
</html>

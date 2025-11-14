<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../header.html" %>
<html>
<head>
<title>予約一覧</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <h2 class="text-center mb-4">あなたの予約一覧</h2>

  <c:if test="${empty reserveList}">
    <div class="alert alert-info">現在、予約はありません。</div>
  </c:if>

  <c:if test="${not empty reserveList}">
    <table class="table table-bordered table-striped align-middle">
      <thead class="table-light">
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
                  <span class="badge bg-warning text-dark">承認待ち</span>
                </c:when>
                <c:when test="${r.reserveStatus == 2}">
                  <span class="badge bg-success">承認済み</span>
                </c:when>
                <c:when test="${r.reserveStatus == 3}">
                  <span class="badge bg-danger">拒否</span>
                </c:when>
                <c:otherwise>
                  <span class="badge bg-secondary">不明</span>
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

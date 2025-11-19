<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<!-- Googleフォント -->
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/review_list.css">

<h2>口コミ一覧</h2>
<div class="zenbu">
<a href="ReviewPostForm.action?shopId=${shopId}" class="toko">口コミを投稿する</a>

<c:if test="${empty reviewList}">
    <p class="nai">まだ口コミがありません。</p>
</c:if>

<c:forEach var="r" items="${reviewList}">
    <div class="card mb-3">
        <div class="card-header">
            ★${r.rating}
        </div>
        <div class="card-body">
            <h5>${r.title}</h5>
            <p>${r.comment}</p>
            <small>投稿者: ${r.userIdString}</small><br>
            <small>投稿日: ${r.createdAt}</small>
        </div>
    </div>
</c:forEach>

<a href="Search.action" class="modoru">お店一覧に戻る</a>
</div>
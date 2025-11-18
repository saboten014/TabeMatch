<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>口コミ一覧</h2>

<a href="ReviewPostForm.action?shopId=${shopId}" class="btn btn-primary mb-3">口コミを投稿する</a>

<c:if test="${empty reviewList}">
    <p>まだ口コミがありません。</p>
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

<a href="Search.action" class="btn btn-secondary">お店一覧に戻る</a>

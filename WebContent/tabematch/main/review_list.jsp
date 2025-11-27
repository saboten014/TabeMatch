<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
body {
    background-color: #e8f8e8;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
}

.zenbu {
    max-width: 900px;
    margin: 40px auto;
    padding: 20px;
}

h2 {
    text-align: center;
    color: #4CAF50;
    margin-bottom: 30px;
    font-size: 2em;
}

/* 成功メッセージ */
.success-message {
    background-color: #d4edda;
    color: #155724;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    border: 1px solid #c3e6cb;
    text-align: center;
    font-weight: bold;
}

/* 投稿ボタン */
.toko {
    display: inline-block;
    padding: 12px 30px;
    background-color: #4CAF50;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: bold;
    margin-bottom: 30px;
    transition: all 0.3s;
}

.toko:hover {
    background-color: #45a049;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

/* 口コミなしメッセージ */
.nai {
    text-align: center;
    padding: 40px;
    color: #666;
    font-size: 1.2em;
}

/* 口コミカード */
.card {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    margin-bottom: 20px;
    overflow: hidden;
    transition: all 0.3s;
}

.card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    transform: translateY(-2px);
}

.card-header {
    background-color: #FFC107;
    color: #333;
    padding: 15px 20px;
    font-size: 1.3em;
    font-weight: bold;
    border-bottom: 2px solid #FFB300;
}

.card-body {
    padding: 20px;
}

.card-body h5 {
    color: #333;
    font-size: 1.3em;
    margin-bottom: 15px;
    font-weight: bold;
}

.card-body p {
    color: #555;
    line-height: 1.8;
    margin-bottom: 15px;
    font-size: 1.05em;
}

.card-body small {
    color: #888;
    font-size: 0.9em;
}

/* 戻るボタン */
.modoru {
    display: inline-block;
    padding: 12px 30px;
    background-color: #9E9E9E;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: bold;
    margin-top: 30px;
    transition: all 0.3s;
}

.modoru:hover {
    background-color: #757575;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.mb-3 {
    margin-bottom: 1rem;
}
</style>

<h2>口コミ一覧</h2>
<div class="zenbu">

<!-- 成功メッセージ表示 -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="success-message">
        ✅ ${sessionScope.successMessage}
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>

<a href="ReviewPostForm.action?shopId=${param.shopId}" class="toko">口コミを投稿する</a>

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
            <!-- ★修正: comment → body -->
            <p>${r.body}</p>
            <small>投稿者: ${r.userIdString}</small><br>
            <small>投稿日: ${r.createdAt}</small>
        </div>
    </div>
</c:forEach>

<a href="Search.action" class="modoru">お店一覧に戻る</a>
</div>

<%@include file="../../footer.html" %>
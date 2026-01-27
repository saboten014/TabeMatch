<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/review_list.css">
<title>口コミ閲覧</title>

<div class="container">
    <h2 class="title">口コミ一覧</h2>

    <div class="zenbu">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="sakusesu">
                ✅ ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <div class="action-bar">
            <%-- param.shopId を使って投稿フォームへ --%>
            <a href="ReviewPostForm.action?shopId=${param.shopId}" class="toko">口コミを投稿する</a>
        </div>

        <c:if test="${empty reviewList}">
            <p class="nai">現在、口コミはありません。</p>
        </c:if>

        <div class="review-grid">
            <c:forEach var="r" items="${reviewList}">
                <div class="card mb-3">
                    <div class="card-header">
                        <span class="star-rating">★ ${r.rating}</span>
                    </div>
                    <div class="card-body">
                        <h5>${r.title}</h5>
                        <p>${r.body}</p>
                        <div class="card-footer-info">
                            <%-- 修正点①：メールアドレスではなくユーザー名を表示 --%>
                            <span>投稿者: <strong>${r.userName}</strong></span>

                            <%-- 修正点②：投稿日を yyyy年MM月dd日 形式に変換 --%>
                            <span>投稿日:
                                <fmt:parseDate value="${r.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="yyyy年MM月dd日" />
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="navigation-footer">
          <button onclick="location.href='ShopDetail.action?shopId=${param.shopId}'"
          		class="modoru">
   						 店舗詳細に戻る
			</button>
        </div>
    </div>
</div>

<%@include file="../../footer.html" %>
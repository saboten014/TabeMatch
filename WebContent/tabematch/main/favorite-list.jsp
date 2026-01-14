<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@include file="../../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<!-- css読み込み -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/favorte-list.css">

<meta charset="UTF-8">
<title>お気に入り店舗一覧</title>


<div class="container">
    <h1>⭐ お気に入り店舗一覧</h1>
    <hr>

    <%-- エラーメッセージ表示 --%>
    <c:if test="${not empty errorMessage}">
        <p style="color: red; font-weight: bold;">⚠️ ${errorMessage}</p>
    </c:if>

    <%-- 成功メッセージ表示 --%>
    <c:if test="${not empty successMessage}">
        <p style="color: green; font-weight: bold;">✅ ${successMessage}</p>
        <%-- ★修正: successMessageをセッションから削除 (一度きりの表示のため) --%>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <%-- 1. リストが空でないかチェック --%>
    <c:choose>
        <c:when test="${empty favoriteShopList}">
            <div class="no-favorites-message">
                <p>現在、お気に入り登録されている店舗はありません。</p>
                <p><a href="SearchAction">店舗検索ページへ</a></p>
            </div>
        </c:when>

        <%-- 2. リストが存在する場合、テーブルで表示 --%>
        <c:otherwise>
            <p style="margin-bottom: 10px;">全 **${fn:length(favoriteShopList)}** 件のお気に入り店舗が見つかりました。</p>

            <table>
                <thead>
                    <tr>
                        <th style="width: 30%;">店舗名</th>
                        <th style="width: 15%;">ジャンル</th>
                        <th style="width: 15%;">価格帯</th>
                        <th style="width: 30%;">アレルギー情報</th>
                        <th style="width: 10%;">詳細</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- リストをループして各店舗を表示 --%>
                    <c:forEach var="shop" items="${favoriteShopList}">
                        <tr>
                            <td>
                                <%-- 店舗名自体を詳細へのリンクにするのが一般的です --%>
                                <a href="ShopDetail.action?shopId=${shop.shopId}">
                                    ${shop.shopName}
                                </a>
                            </td>

                            <td>${shop.shopGenre}</td>    <%-- (getShopGenre()を想定) --%>
							<td>${shop.shopPrice}</td>    <%-- (getShopPrice()を想定) --%>
							<td>${shop.shopAllergy}</td>  <%-- (getShopAllergy()を想定) --%>
                            <td>
                                <%-- 詳細リンクを強調 --%>
                                <a href="ShopDetail.action?shopId=${shop.shopId}">詳細を見る &gt;</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <%-- 戻るボタンは検索ページへ遷移させるのが適切 --%>
    <div class="button-container">
        <a href="search.jsp">店舗検索ページに戻る</a>
    </div>
</div>

<%@include file="../../footer.html" %>
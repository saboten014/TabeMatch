<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@include file="../../header.html" %>
<%@include file="/tabematch/main/user_menu.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<meta charset="UTF-8">
<title>お気に入り店舗一覧</title>

<style>
    /* 既存のスタイル */
    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
    }
    .container {
        width: 90%;
        margin: 0 auto;
        padding: 20px;
    }

    /* ★追加するスタイル: ボタン風リンクと右寄せコンテナ ★ */
    .button-container {
        margin-top: 20px;
        text-align: right; /* これで右寄せになる */
    }
    .button-container a {
        display: inline-block;
        padding: 10px 20px;
        background-color: #4CAF50; /* 緑色のボタン */
        color: white;
        text-decoration: none;
        border-radius: 5px;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .button-container a:hover {
        background-color: #45a049;
    }
</style>

<div class="container">
    <h1>⭐ お気に入り店舗一覧</h1>
    <hr>

    <%-- エラーメッセージ表示 --%>
    <c:if test="${not empty errorMessage}">
        <p style="color: red;">${errorMessage}</p>
    </c:if>

    <%-- 成功メッセージ表示 (FavoriteInsertActionからのリダイレクトなどで使用) --%>
    <c:if test="${not empty successMessage}">
        <p style="color: green;">${successMessage}</p>
        <% session.removeAttribute("successMessage"); %>
    </c:if>

    <%-- 1. リストが空でないかチェック --%>
    <c:choose>
        <c:when test="${empty favoriteShopList}">
            <p>現在、お気に入り登録されている店舗はありません。</p>
            <p><a href="Search.action">店舗検索ページへ</a></p>
        </c:when>

        <%-- 2. リストが存在する場合、テーブルで表示 --%>
        <c:otherwise>
            <p>全 ${fn:length(favoriteShopList)} 件のお気に入り店舗が見つかりました。</p>

            <table>
                <thead>
                    <tr>
                        <th>店舗名</th>
                        <th>ジャンル</th>
                        <th>価格帯</th>
                        <th>アレルギー情報</th>
                        <th>詳細</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- リストをループして各店舗を表示 --%>
                    <c:forEach var="shop" items="${favoriteShopList}">
                        <tr>
                            <td>${shop.shopName}</td>
                            <td>${shop.shopGenre}</td>
                            <td>${shop.shopPrice}</td>
                            <td>${shop.shopAllergy}</td>
                            <td>
                                <%-- 店舗IDをパラメータに付けて詳細アクションへ遷移 --%>
                                <a href="ShopDetail.action?shopId=${shop.shopId}">詳細を見る</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <%-- ★修正箇所: 右寄せのボタン風リンクに変更 ★ --%>
    <div class="button-container">
        <a href="search.jsp">トップページに戻る</a>
    </div>
</div>

<%@include file="../../footer.html" %>
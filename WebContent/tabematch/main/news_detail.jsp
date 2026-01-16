<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="bean.News" %>
<%@ page import="bean.Users" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. セッションからユーザー情報を取得
    Users loginUser = (Users) session.getAttribute("user");
    String userType = "";
    if (loginUser != null && loginUser.getUsersTypeId() != null) {
        userType = loginUser.getUsersTypeId().trim(); // 空白除去
    }

    String contextPath = request.getContextPath();

    // 2. NewsDetailActionから取得 ('news_detail'キー)
    News news = (News)request.getAttribute("news_detail");

    // 管理者ステータス取得
    Boolean isAdminObj = (Boolean)session.getAttribute("admin");
    boolean isAdmin = (isAdminObj != null) ? isAdminObj.booleanValue() : false;

    // データがない場合の処理
    if (news == null) {
        String errorMessage = (String)request.getAttribute("error_message");
%>
<%@ include file="../../header.html" %>
<div class="container" style="text-align: center; margin-top: 100px; font-family: 'Kosugi Maru', sans-serif;">
    <h2>エラー</h2>
    <p><%= errorMessage != null ? errorMessage : "指定されたお知らせは見つかりませんでした。" %></p>
    <p><a href="<%= contextPath %>/tabematch/News.action">お知らせ一覧へ戻る</a></p>
</div>
<%
        return;
    }

    // 日付フォーマット
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    String formattedDate = (news.getDeliveryDate() != null) ? sdf.format(news.getDeliveryDate()) : "";
%>

<%@ include file="../../header.html" %>

<%-- 3. ユーザー種別によってメニューを切り替え --%>
<% if ("2".equals(userType)) { %>
    <jsp:include page="../../tabematch/main/shop_menu.jsp" />
<% } else { %>
    <jsp:include page="user_menu.jsp" />
<% } %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
body {
	background-color:  #e8f8e8;
}
.detail-container {
    width: 70%;
    max-width: 900px;
    margin: 120px auto 40px; /* メニューにかぶらないよう少し広めに */
    padding: 30px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background-color: #ffffff;
    box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    font-family: 'Kosugi Maru', sans-serif;
}

.detail-header {
    border-bottom: 3px solid #4CAF50;
    padding-bottom: 10px;
    margin-bottom: 20px;
}

.detail-title {
    font-size: 2.2em;
    font-weight: bold;
    color: #333;
    margin: 0;
}

.detail-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.9em;
    color: #666;
    margin-top: 5px;
}

.detail-text {
    font-size: 1.1em;
    line-height: 1.8;
    color: #444;
    white-space: pre-wrap;
    min-height: 200px;
}

.edit-button {
    display: inline-block;
    padding: 8px 15px;
    background-color: #FFC107;
    color: #333;
    border-radius: 5px;
    text-decoration: none;
    font-weight: bold;
    transition: background-color 0.2s;
}
.edit-button:hover {
    background-color: #FFA000;
    color: #fff;
}

.back-link {
    display: inline-block;
    margin-top: 30px;
    padding: 10px 15px;
    background-color: #f8f9fa;
    border: 1px solid #ccc;
    border-radius: 5px;
    text-decoration: none;
    color: #4CAF50;
    transition: background-color 0.2s;
}

.back-link:hover {
    background-color: #e2e6ea;
}
</style>

<div class="detail-container">
    <div class="detail-header">
        <h1 class="detail-title"><%= news.getNewsTitle() %></h1>
        <div class="detail-meta">
            <span>投稿日時: <%= formattedDate %></span>

            <% if (isAdmin) { %>
                <a href="${pageContext.request.contextPath}/tabematch/NewsEdit.action?news_id=<%= news.getNewsId() %>" class="edit-button">
                    お知らせを編集
                </a>
            <% } %>
        </div>
    </div>


    	<p class="detail-text"><%= news.getNewsText() %></p>



    <a href="<%= contextPath %>/tabematch/News.action" class="back-link">← お知らせ一覧へ戻る</a>
</div>

<%@ include file="../../footer.html" %>
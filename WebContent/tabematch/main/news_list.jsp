<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="bean.News" %>
<%@ page import="bean.Users" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. セッションからユーザー情報を取得
    Users loginUser = (Users) session.getAttribute("user");
    String userType = "";
    if (loginUser != null && loginUser.getUsersTypeId() != null) {
        userType = loginUser.getUsersTypeId().trim(); // 空白を除去して取得
    }

    // 2. お知らせリストと管理者フラグを取得
    List<News> list = (List<News>) session.getAttribute("list");
    boolean isAdmin = false;
    if (session.getAttribute("admin") != null) {
        isAdmin = (Boolean) session.getAttribute("admin");
    }

    String contextPath = request.getContextPath();
%>

<%@ include file="../../header.html" %>

<%-- 3. ユーザー種別によってメニューを切り替え --%>
<% if ("2".equals(userType)) { %>
    <%-- 店舗ユーザーの場合 --%>
    <jsp:include page="../../tabematch/main/shop_menu.jsp" />
<% } else { %>
    <%-- 一般ユーザー・管理者の場合 --%>
    <jsp:include page="user_menu.jsp" />
<% } %>

<style>
/* お知らせ一覧のスタイル */
.news-container {
    width: 80%;
    margin: 20px auto;
    font-family: 'Kosugi Maru', sans-serif;
}
.news-link {
    text-decoration: none;
    color: inherit;
    display: block;
}
.news-item {
    border: 1px solid #e0e0e0;
    border-radius: 15px;
    padding: 15px;
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    background-color: #ffffff;
    box-shadow: 0 4px 8px rgba(0,0,0,0.08);
    transition: all 0.2s ease-in-out;
}
.news-item:hover {
    background-color: #f8f8f8;
    transform: translateY(-3px);
    box-shadow: 0 6px 12px rgba(0,0,0,0.12);
    cursor: pointer;
}
.news-content {
    flex-grow: 1;
}
.news-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
}
.news-title {
    font-size: 1.3em;
    font-weight: bold;
    color: #4CAF50;
}
.news-date {
    font-size: 0.85em;
    color: #888;
}
.news-text-preview {
    font-size: 0.95em;
    color: #555;
    margin-top: 5px;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
.admin-actions {
    margin-left: 20px;
    padding-top: 5px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}
.fixed-buttons-container {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 1000;
}
.admin-button {
    display: block;
    margin-bottom: 10px;
    padding: 12px 20px;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1.05em;
    box-shadow: 0 3px 5px rgba(0,0,0,0.1);
    text-decoration: none;
    text-align: center;
}
.post-button {
    background-color: #81C784;
    color: #FFFFFF;
    border: 1px solid #66BB6A;
}
.delete-button {
    background-color: #FFB74D;
    color: #FFFFFF;
    border: 1px solid #FFA726;
    margin-top: 5px;
}
h2 {
   margin-top: 100px;
}
</style>

<div class="news-container">
    <h2>📢 お知らせ一覧</h2>
    <% if (list == null || list.isEmpty()) { %>
        <p>現在、お知らせはありません。</p>
    <% } else { %>
        <% SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm"); %>
        <% for (News news : list) { %>
            <a href="${pageContext.request.contextPath}/tabematch/NewsDetail.action?news_id=<%= news.getNewsId() %>" class="news-link">
                <div class="news-item">
                    <div class="news-content">
                        <div class="news-header">
                            <span class="news-title"><%= news.getNewsTitle() %></span>
                            <span class="news-date">投稿日時: <%= sdf.format(news.getDeliveryDate()) %></span>
                        </div>
                        <div class="news-text-preview">
                            <%= news.getNewsText() %>
                        </div>
                    </div>

                    <%-- 管理者のみ削除ボタンを表示 --%>
                    <% if (isAdmin) { %>
                        <div class="admin-actions">
                            <form action="${pageContext.request.contextPath}/tabematch/NewsDelete.action" method="post" onsubmit="return confirm('このお知らせを削除してもよろしいですか？')">
                                <input type="hidden" name="newsId" value="<%= news.getNewsId() %>">
                                <button type="submit" class="delete-button" onclick="event.stopPropagation()">削除</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            </a>
        <% } %>
    <% } %>
</div>

<%-- 管理者用：新規投稿ボタン --%>
<% if (isAdmin) { %>
    <div class="fixed-buttons-container">
        <a href="${pageContext.request.contextPath}/tabematch/NewsPostForm.action" class="admin-button post-button">お知らせを投稿する</a>
    </div>
<% } %>

<%@ include file="../../footer.html" %>
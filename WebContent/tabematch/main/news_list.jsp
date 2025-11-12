<%@page import="bean.News"%>
<%@page import="java.util.List"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<%-- NewsActionからセッション属性を取得 --%>
<%
    // お知らせリストを取得
    List<News> list = (List<News>)session.getAttribute("list");
    // 管理者ステータスを取得
    boolean isAdmin = (Boolean)session.getAttribute("admin");
%>

<style>
/* CSSは後でいじるため、最小限の構造を定義 */
.news-container {
    width: 80%;
    margin: 20px auto;
    font-family: 'Kosugi Maru', sans-serif;
}
.news-item {
    border: 1px solid #ccc;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between; /* 左右に要素を配置 */
    align-items: flex-start;
    background-color: #f9f9f9;
}
.news-content {
    flex-grow: 1; /* コンテンツが幅を占める */
}
.news-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
}
.news-title {
    font-size: 1.2em;
    font-weight: bold;
    color: #333;
}
.news-date {
    font-size: 0.8em;
    color: #666;
}
.news-text-preview {
    font-size: 0.9em;
    color: #555;
    margin-top: 5px;
    /* 本文を少しだけ表示するためのスタイル */
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2; /* 表示行数を2行に制限 */
    -webkit-box-orient: vertical;
}
.admin-actions {
    margin-left: 20px;
    padding-top: 5px; /* タイトルと位置を合わせるため微調整 */
}
.fixed-buttons-container {
    position: fixed; /* 画面に対して固定 */
    bottom: 20px;    /* 画面下から20px */
    right: 20px;     /* 画面右から20px */
    z-index: 1000;   /* 他の要素より手前に表示 */
}
.admin-button {
    display: block; /* ボタンを縦に並べる */
    margin-bottom: 10px;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
}
.post-button {
    background-color: #007bff;
    color: white;
}
.delete-button {
    background-color: #dc3545;
    color: white;
    margin-top: 5px;
}
</style>

<div class="news-container">
    <h2>📢 お知らせ一覧</h2>
    <% if (list == null || list.isEmpty()) { %>
        <p>現在、お知らせはありません。</p>
    <% } else { %>
        <% for (News news : list) { %>
            <div class="news-item">
                <div class="news-content">
                    <div class="news-header">
                        <span class="news-title"><%= news.getNewsTitle() %></span>
                        <span class="news-date">投稿日時: <%= new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm").format(news.getDeliveryDate()) %></span>
                    </div>
                    <div class="news-text-preview">
                        <%-- 本文の冒頭を表示 --%>
                        <%= news.getNewsText() %>
                    </div>
                </div>

                <%-- 管理者機能の表示 --%>
                <% if (isAdmin) { %>
                    <div class="admin-actions">
                        <%-- 削除ボタン (アクションは仮です) --%>
                        <form action="NewsDelete.action" method="post" onsubmit="return confirm('このお知らせを削除してもよろしいですか？')">
                            <input type="hidden" name="newsId" value="<%= news.getNewsId() %>">
                            <button type="submit" class="delete-button">削除</button>
                        </form>
                    </div>
                <% } %>
            </div>
        <% } %>
    <% } %>
</div>

<%-- 管理者用の固定ボタン --%>
<% if (isAdmin) { %>
    <div class="fixed-buttons-container">
        <%-- 新規投稿ボタン (アクションは仮です) --%>
        <a href="NewsPostForm.action" class="admin-button post-button">お知らせを投稿する</a>
    </div>
<% } %>

<%@include file="../../footer.html" %>
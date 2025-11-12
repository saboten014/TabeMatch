<%@page import="bean.News"%>
<%@page import="java.util.List"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>

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
/* 新規CSS: <a> タグとして機能させるためのスタイル */
.news-link {
    text-decoration: none; /* リンクの下線を削除 */
    color: inherit;       /* テキストの色を親要素から継承 */
    display: block;       /* ブロック要素にして全体をクリック可能に */
}
.news-item {
    border: 1px solid #ccc;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    background-color: #f9f9f9;
    transition: background-color 0.2s; /* ホバーエフェクト用 */
}
.news-item:hover {
    background-color: #e0e0e0; /* ホバーで色を変えてクリック可能であることを示す */
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
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
/* 管理者アクションと固定ボタンのスタイルは変更なし */
.admin-actions {
    margin-left: 20px;
    padding-top: 5px;
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

            <%-- ▼ ここを <a> タグで囲み、詳細画面へ遷移させる ▼ --%>
            <a href="NewsDetail.action?news_id=<%= news.getNewsId() %>" class="news-link">
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
                    <%-- 削除ボタンは <a> の外側に出すか、別要素として実装する方が望ましいですが、
                         ここではシンプルに <a> の中から除外して、管理者時のみフォームを表示します。 --%>
                    <% if (isAdmin) { %>
                        <div class="admin-actions">
                            <%-- 削除ボタン (リンクの中にあると動作がおかしくなるため、別処理にします) --%>
                            <form action="NewsDelete.action" method="post" onsubmit="return confirm('このお知らせを削除してもよろしいですか？')">
                                <input type="hidden" name="newsId" value="<%= news.getNewsId() %>">
                                <button type="submit" class="delete-button" onclick="event.stopPropagation()">削除</button>
                                <%-- onclick="event.stopPropagation()" を追加することで、削除ボタンが押されたときに
                                     親の <a> タグのクリックイベント（詳細画面への遷移）が発生するのを防ぎます。--%>
                            </form>
                        </div>
                    <% } %>
                </div>
            </a>
            <%-- ▲ <a> タグの終わり ▲ --%>

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
<%@page import="bean.News"%>
<%@page import="java.util.List"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>


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
    border: 1px solid #e0e0e0; /* 薄いグレーのボーダー */
    border-radius: 15px;      /* 角を丸くする */
    padding: 15px;
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    background-color: #ffffff; /* 白を基調 */
    box-shadow: 0 4px 8px rgba(0,0,0,0.08); /* 柔らかい影 */
    transition: all 0.2s ease-in-out; /* ホバーエフェクト用 */
}
.news-item:hover {
    background-color: #f8f8f8; /* ホバーでごく薄いグレーに */
    transform: translateY(-3px); /* 少し上に浮き上がるアニメーション */
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
    color: #4CAF50; /* パステルグリーン */
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
/* 管理者アクションのスタイル */
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
/* ★★ 削除ボタンと投稿ボタンのスタイル ★★ */
.admin-button {
    display: block;
    margin-bottom: 10px;
    padding: 12px 20px;
    border: none;
    border-radius: 25px; /* 丸っこい形 */
    cursor: pointer;
    font-weight: bold;
    font-size: 1.05em;
    box-shadow: 0 3px 5px rgba(0,0,0,0.1); /* 柔らかい影 */
    transition: all 0.3s ease;
}
.admin-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 8px rgba(0,0,0,0.15);
}
.post-button {
    background-color: #81C784; /* パステルグリーン */
    color: #FFFFFF;           /* 白文字 */
    border: 1px solid #66BB6A; /* 少し濃い緑のボーダー */
}
.post-button:hover {
    background-color: #66BB6A; /* ホバーで少し濃い緑に */
}
.delete-button {
    background-color: #FFB74D; /* パステルオレンジ */
    color: #FFFFFF;           /* 白文字 */
    border: 1px solid #FFA726; /* 少し濃いオレンジのボーダー */
    margin-top: 5px;
}
.delete-button:hover {
    background-color: #FFA726; /* ホバーで少し濃いオレンジに */
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
        <% for (News news : list) { %>

            <%-- ▼ 詳細画面へのリンクを修正: news.getNewsId()をStringに変換 ▼ --%>
            <a href="${pageContext.request.contextPath}/tabematch/NewsDetail.action?news_id=<%= String.valueOf(news.getNewsId()) %>" class="news-link">
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
                            <%-- 削除ボタンのフォームアクションを修正: news.getNewsId()をStringに変換 --%>
                            <form action="${pageContext.request.contextPath}/tabematch/NewsDelete.action" method="post" onsubmit="return confirm('このお知らせを削除してもよろしいですか？')">
                                <input type="hidden" name="newsId" value="<%= String.valueOf(news.getNewsId()) %>">
                                <button type="submit" class="delete-button" onclick="event.stopPropagation()">削除</button>
                                <%-- onclick="event.stopPropagation()" でリンク遷移を防止 --%>
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
        <%-- 新規投稿ボタンのリンクを修正: ${pageContext.request.contextPath} に戻す --%>
        <a href="${pageContext.request.contextPath}/tabematch/NewsPostForm.action" class="admin-button post-button">お知らせを投稿する</a>
    </div>
<% } %>

<%@include file="../../footer.html" %>
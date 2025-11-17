<%@page import="bean.News"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%-- メニューの動的切り替えが必要な場合、NewsActionと同様のisAdminチェックをここに組み込む --%>
<%-- 一旦、user_menu.jspを読み込みますが、NewsActionからisAdminフラグを受け取っている前提とします。 --%>
<%@include file="user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<%-- NewsDetailActionからリクエスト属性を取得 --%>
<%
    // NewsDetailActionでセットしたデータ ('news_detail'というキーで格納されていると仮定)
    News news = (News)request.getAttribute("news_detail");

    // ★追加: 管理者ステータスをセッションから取得
    Boolean isAdminObj = (Boolean)session.getAttribute("admin");
    boolean isAdmin = (isAdminObj != null) ? isAdminObj.booleanValue() : false;

    // データがない場合の処理
    if (news == null) {
        // エラーメッセージがあれば表示
        String errorMessage = (String)request.getAttribute("error_message");
%>
<div class="container" style="text-align: center; margin-top: 50px;">
    <h2>エラー</h2>
    <p><%= errorMessage != null ? errorMessage : "指定されたお知らせは見つかりませんでした。" %></p>
    <%-- NewsActionへのリンクにコンテキストパスを追加 --%>
    <p><a href="<%= contextPath %>/tabematch/News.action">お知らせ一覧へ戻る</a></p>
</div>
<%
        return;
    }

    // NullPointerException対策のため、ここで日付フォーマッタを定義し、日付がnullでないか確認
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm");
    String formattedDate = "";
    if (news.getDeliveryDate() != null) {
        formattedDate = sdf.format(news.getDeliveryDate());
    }
%>

<style>
.detail-container {
    width: 70%;
    max-width: 900px;
    margin: 40px auto;
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
    align-items: center; /* 要素を垂直方向中央に揃える */
    font-size: 0.9em;
    color: #666;
    margin-top: 5px;
}

.detail-text {
    font-size: 1.1em;
    line-height: 1.8;
    color: #444;
    white-space: pre-wrap;
}

/* ★追加: 編集ボタンのスタイル */
.edit-button {
    display: inline-block;
    padding: 8px 15px;
    background-color: #FFC107; /* 目を引く黄色 */
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

            <%-- ★追加: 管理者のみに編集ボタンを表示 --%>
            <% if (isAdmin) { %>
                <a href="${pageContext.request.contextPath}/tabematch/NewsEdit.action?news_id=<%= news.getNewsId() %>" class="edit-button">
                    お知らせを編集
                </a>
            <% } %>

        </div>
    </div>

    <div class="detail-text">
        <%= news.getNewsText() %>
    </div>

    <%-- NewsActionへのリンクにコンテキストパスを追加 --%>
    <a href="${pageContext.request.contextPath}/News.action" class="back-link">← お知らせ一覧へ戻る</a>
</div>

<%@include file="../../footer.html" %>
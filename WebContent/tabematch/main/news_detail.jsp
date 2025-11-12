<%@page import="bean.News"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<%-- NewsDetailActionからリクエスト属性を取得 --%>
<%
    // NewsDetailActionでセットしたデータ ('news_detail'というキーで格納されている)
    News news = (News)request.getAttribute("news_detail");

    // データがない場合の処理（通常はAction側でエラー処理されるため不要だが、保険として）
    if (news == null) {
        // エラーメッセージがあれば表示
        String errorMessage = (String)request.getAttribute("error_message");
%>
<div class="container" style="text-align: center; margin-top: 50px;">
    <h2>エラー</h2>
    <p><%= errorMessage != null ? errorMessage : "指定されたお知らせは見つかりませんでした。" %></p>
    <p><a href="NewsAction.action">お知らせ一覧へ戻る</a></p>
</div>
<%
        // フッターに進む前に処理を終了
        return;
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
    border-bottom: 3px solid #007bff;
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
    font-size: 0.9em;
    color: #666;
    margin-top: 5px;
}

.detail-text {
    font-size: 1.1em;
    line-height: 1.8;
    color: #444;
    white-space: pre-wrap; /* 改行を反映させる */
}

.back-link {
    display: inline-block;
    margin-top: 30px;
    padding: 10px 15px;
    background-color: #f8f9fa;
    border: 1px solid #ccc;
    border-radius: 5px;
    text-decoration: none;
    color: #007bff;
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
            <span>投稿日時: <%= new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm").format(news.getDeliveryDate()) %></span>
        </div>
    </div>

    <div class="detail-text">
        <%= news.getNewsText() %>
    </div>

    <a href="News.action" class="back-link">← お知らせ一覧へ戻る</a>
</div>

<%@include file="../../footer.html" %>
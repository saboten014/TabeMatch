<%@page import="bean.News"%>
<%@page pageEncoding="UTF-8" %>

<%@include file="../../header.html" %>
<%-- 管理者用メニューをインクルード --%>
<%@include file="user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<%
    // NewsEditActionから渡されたNewsオブジェクトを取得
    News news = (News)request.getAttribute("news");

    // nullチェックはAction側で既に実施されていますが、念のため
    if (news == null) {
        // エラー処理やリダイレクトはAction側で行うべきですが、表示上の措置
        response.sendRedirect(request.getContextPath() + "/News.action");
        return;
    }

    // ロール選択肢を簡単に定義（実際の仕様に合わせて変更してください）
    String[] roles = {"general", "shop", "admin"};
%>

<style>
.edit-container {
    width: 80%;
    max-width: 800px;
    margin: 40px auto;
    padding: 30px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background-color: #f9f9f9;
    box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    font-family: 'Kosugi Maru', sans-serif;
}
.form-group {
    margin-bottom: 20px;
}
.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 5px;
    color: #4CAF50; /* テーマカラー */
}
.form-control, textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 1em;
}
textarea {
    resize: vertical;
    height: 150px;
}
.btn-update {
    display: block;
    width: 100%;
    padding: 12px;
    background-color: #4CAF50; /* テーマカラー */
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1.1em;
    transition: background-color 0.3s;
}
.btn-update:hover {
    background-color: #45a049;
}
.btn-back {
    display: block;
    width: 100%;
    text-align: center;
    margin-top: 10px;
    padding: 10px;
    background-color: #f0f0f0;
    color: #333;
    text-decoration: none;
    border-radius: 4px;
    border: 1px solid #ddd;
}
.btn-back:hover {
    background-color: #e0e0e0;
}
.form-title {
    color: #4CAF50;
    border-bottom: 2px solid #4CAF50;
    padding-bottom: 5px;
    margin-bottom: 30px;
}
</style>

<div class="edit-container">
    <h2 class="form-title">お知らせ編集 (ID: <%= news.getNewsId() %>)</h2>

    <%-- フォームの送信先は更新処理を実行するAction --%>
    <form action="${pageContext.request.contextPath}/tabematch/NewsUpdate.action" method="post">

        <%-- 必須: どの記事を更新するか特定するためのID。hiddenフィールドで渡す --%>
        <input type="hidden" name="news_id" value="<%= news.getNewsId() %>">

        <div class="form-group">
            <label for="news_title">タイトル</label>
            <%-- 既存のデータをvalueにセット --%>
            <input type="text" id="news_title" name="news_title" class="form-control" value="<%= news.getNewsTitle() %>" required>
        </div>

        <div class="form-group">
            <label for="news_text">本文</label>
            <%-- 既存のデータをtextarea内にセット --%>
            <textarea id="news_text" name="news_text" class="form-control" required><%= news.getNewsText() %></textarea>
        </div>


        <button type="submit" class="btn-update">更新する</button>

        <%-- 編集をキャンセルして一覧に戻るボタン --%>
        <a href="<%= contextPath %>/tabematch/News.action" class="btn-back">キャンセルして一覧に戻る</a>
    </form>
</div>

<%@include file="../../footer.html" %>
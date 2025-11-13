<%@page pageEncoding="UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
.form-container {
    width: 60%;
    margin: 40px auto;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    background-color: #ffffff;
    font-family: 'Kosugi Maru', sans-serif;
    border: 1px solid #e0e0e0;
}
.form-container h2 {
    color: #4CAF50; /* パステルグリーン */
    border-bottom: 3px solid #81C784;
    padding-bottom: 10px;
    margin-bottom: 30px;
    text-align: center;
}
.form-group {
    margin-bottom: 25px;
}
.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
    color: #333;
    font-size: 1.1em;
}
.form-group input[type="text"],
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #ccc;
    border-radius: 8px;
    box-sizing: border-box;
    font-size: 1em;
}
.form-group textarea {
    height: 250px;
    resize: vertical;
}
.error-message {
    color: #FFB74D; /* パステルオレンジ */
    font-weight: bold;
    margin-top: 15px;
    text-align: center;
}

/* 投稿ボタンのスタイル (前回定義した post-button に合わせる) */
.submit-button-container {
    text-align: center;
    margin-top: 40px;
}
.post-button {
    padding: 15px 30px;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    font-weight: bold;
    font-size: 1.1em;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: all 0.3s ease;

    /* パステルグリーンと白文字 */
    background-color: #81C784;
    color: #FFFFFF;
    border: 1px solid #66BB6A;
}
.post-button:hover {
    background-color: #66BB6A;
    transform: translateY(-2px);
    box-shadow: 0 6px 10px rgba(0,0,0,0.15);
}
</style>

<%
    // エラーメッセージがあれば取得（NewsPostFormActionからのフォワード時）
    String errorMessage = (String)request.getAttribute("errorMessage");
%>

<div class="form-container">
    <h2>📝 新しいお知らせを投稿</h2>

    <% if (errorMessage != null) { %>
        <p class="error-message"><%= errorMessage %></p>
    <% } %>

    <%--
        action: NewsPostFormActionに対してPOST送信
        FrontControllerのルーティングに合わせるため、パスに /tabematch/ を付与
    --%>
    <form action="${pageContext.request.contextPath}/tabematch/NewsPostForm.action" method="post">

        <div class="form-group">
            <label for="newsTitle">タイトル（必須）</label>
            <input type="text" id="newsTitle" name="newsTitle" required maxlength="100">
        </div>

        <div class="form-group">
            <label for="newsText">本文（必須）</label>
            <textarea id="newsText" name="newsText" required></textarea>
        </div>

        <div class="submit-button-container">
            <button type="submit" class="post-button">お知らせを登録する</button>
        </div>

    </form>
</div>

<%@include file="../../footer.html" %>
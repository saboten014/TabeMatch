<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/user_prof_v.css">

<div class="container">
    <div class="card" style="text-align: center; max-width: 500px; margin: 100px auto;">
        <div style="font-size: 50px; margin-bottom: 20px;">✨</div>
        <h2 style="margin-top: 0; color: #61b061;">更新が完了しました！</h2>

        <p style="color: #666; margin-bottom: 30px;">
            プロフィール情報を新しく書き換えました。<br>
            これからも「たべまっち」を楽しんでくださいね。
        </p>

        <div class="btn" style="justify-content: center;">
            <a href="UserProfileView.action" class="btn-hensyu">プロフィールを確認する</a>
        </div>
    </div>
</div>

<%@ include file="../../footer.html" %>
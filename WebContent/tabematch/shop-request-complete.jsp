<%@page contentType="text/html; charset=UTF-8" %>
<%@include file="../header.html" %>

<h1>リクエスト送信完了</h1>

<%
    String requestId = (String)request.getAttribute("requestId");
%>

<div style="background-color: #d4edda; border: 1px solid #c3e6cb; padding: 20px; margin: 20px 0; border-radius: 5px;">
    <h2 style="color: #155724; margin-top: 0;">リクエストを受け付けました</h2>
    <p style="color: #155724;">
        店舗掲載リクエストの送信が完了しました。<br>
        リクエストID: <strong><%= requestId %></strong>
    </p>
    <p style="color: #155724;">
        管理者による承認後、登録されたメールアドレス宛に<br>
        ログイン情報（ユーザーIDと仮パスワード）をお送りします。<br>
        承認までしばらくお待ちください。
    </p>
</div>

<p><a href="Login.action">ログイン画面に戻る</a></p>

<%@include file="../footer.html" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/review_post_form.css">
<title>口コミ投稿</title>

<div class="zenbu">
<h2>口コミ投稿</h2>

<%
    // ★重要: shopIdを取得して確認
    String shopId = request.getParameter("shopId");
    if (shopId == null || shopId.trim().isEmpty()) {
        // shopIdがない場合はエラー表示
        out.println("<p style='color:red;'>エラー: 店舗IDが取得できませんでした。</p>");
        out.println("<a href='Search.action'>店舗一覧に戻る</a>");
    } else {
%>

<form action="ReviewPostExecute.action" method="post">
    <!-- ★hiddenフィールドでshopIdを確実に送信 -->
    <input type="hidden" name="shopId" value="<%= shopId %>">

    <div class="mb-3">
        <label>タイトル</label>
        <input type="text" name="title" class="form-control" required>
    </div>

    <div class="mb-3">
        <label>コメント</label>
        <textarea name="body" class="form-control" required></textarea>
    </div>

    <div class="mb-3">
        <label>評価（1〜5）</label>
        <select name="rating" class="form-select">
            <option value="1">★1</option>
            <option value="2">★2</option>
            <option value="3">★3</option>
            <option value="4">★4</option>
            <option value="5">★5</option>
        </select>
    </div>

	<div class="btn">
		<a href="ShopDetail.action?shopId=<%= shopId %>" class="modoru">店舗詳細に戻る</a>
		<button type="submit" class="sousin">投稿する</button>
	</div>
</form>

<%
    } // shopIdのチェック終了
%>
</div>

<%@include file="../../footer.html" %>
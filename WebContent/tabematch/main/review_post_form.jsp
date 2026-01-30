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
	    <label for="title">タイトル</label>
	    <input type="text" name="title" id="title" maxlength="100" class="form-control" required>
	    <small class="text-muted">
	        <span id="title-count">0</span>/100文字
	    </small>
	</div>

	<div class="mb-3">
	    <label for="body">コメント</label>
	    <textarea name="body" id="body" class="form-control" rows="5" maxlength="1000" required></textarea>
	    <small class="text-muted">
	        <span id="body-count">0</span>/1000文字
	    </small>
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

<script>
	// リアルタイム文字数カウント
	document.getElementById('title').addEventListener('input', function() {
	    document.getElementById('title-count').textContent = this.value.length;
	});

	document.getElementById('body').addEventListener('input', function() {
	    document.getElementById('body-count').textContent = this.value.length;
	});
</script>

<%@include file="../../footer.html" %>
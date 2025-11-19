<%@ page contentType="text/html; charset=UTF-8" %>
<%@include file="../../header.html" %>
<%@include file="user_menu.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/review_post_form.css">


<div class="zenbu">
<h2>口コミ投稿</h2>


<form action="ReviewPostExecute.action" method="post">

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
		<a href="Search.action" class="modoru">お店一覧に戻る</a>
		<button type="submit" class="sousin">投稿する</button>
	</div>
</form>
</div>
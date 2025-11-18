<%@ page contentType="text/html; charset=UTF-8" %>

<h2>口コミ投稿</h2>

<form action="ReviewPostExecute.action" method="post">

    <input type="hidden" name="shopId" value="${shopId}">

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

    <button type="submit" class="btn btn-success">投稿する</button>
</form>

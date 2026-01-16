<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="bean.Shop" %>
<%@ include file="../../header.html" %>
<%@ include file="user_menu.jsp" %>
<%
    Shop shop = (Shop) request.getAttribute("shop");
    if (shop == null) {
%>
    <div>
        <div>店舗情報が取得できませんでした。</div>
        <a href="search.jsp">店舗検索に戻る</a>
    </div>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>予約フォーム | たべまっち</title>
	<!-- css読み込み -->
	<link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation-form.css">

</head>
<body>
<div class="zenbu">

    <h2>予約フォーム</h2>


       <div>
        <table style="width: 80%; border-collapse: collapse;">
            <tr>
                <th style="width: 30%;">店舗名</th>
                <td><%= shop.getShopName() %></td>
            </tr>
            <tr>
                <th>住所</th>
                <td><%= shop.getShopAddress() %></td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td><%= shop.getShopTel() %></td>
            </tr>
            <tr>
                <th>予約可否</th>
                <td><%= shop.getShopReserve() != null ? shop.getShopReserve() : "未登録" %></td>
            </tr>
        </table>
    </div>


    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
        <div><%= errorMessage %></div>
    <%
        }
    %>

    <form method="post" action="ReserveExecute.action">
        <input type="hidden" name="shopId" value="<%= shop.getShopId() %>">
        <div>
            <label class="day">来店日<span>*</span></label>
            <input type="date" id="visitDate" name="visitDate" required>
        </div>
        <div>
            <label class="time">来店時間<span>*</span></label>
            <input type="time" name="visitTime" required>
        </div>
        <div >
            <label>人数<span>*</span></label>
            <input type="number" name="numOfPeople" min="1" placeholder="例：2" required>
        </div>
        <div>
            <label>アレルギーに関するご要望</label>
            <textarea name="allergyNotes" rows="3" placeholder="避けたい食材や症状など"></textarea>
        </div>
        <div>
            <label>その他のリクエスト</label>
            <textarea name="message" rows="3" placeholder="例：子ども椅子希望"></textarea>
        </div>
        <div class="btn">
            <a href="ShopDetail.action?shopId=<%= shop.getShopId() %>" class="modoru">戻る</a>
            <button type="submit" class="sousin">予約を送信する</button>
        </div>
    </form>
</div>

<script>
    // 来店日の入力範囲を設定（今日から2年後まで）
    (function() {
        const dateInput = document.getElementById('visitDate');
        const today = new Date();

        // 今日の日付をmin値に設定
        const minDate = today.toISOString().split('T')[0];
        dateInput.setAttribute('min', minDate);

        // 2年後の日付をmax値に設定（1年後にしたい場合は getFullYear() + 1 に変更）
        const maxDate = new Date(today.getFullYear() + 2, today.getMonth(), today.getDate());
        dateInput.setAttribute('max', maxDate.toISOString().split('T')[0]);
    })();
</script>

</body>
</html>
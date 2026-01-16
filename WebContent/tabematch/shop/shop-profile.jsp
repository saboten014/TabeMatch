<%@page pageEncoding="UTF-8" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Time"%>
<%@page import="java.util.Date"%>
<%@page import="bean.Shop"%>

<!-- ヘッダー読込 -->
<%@include file="../../header.html" %>
<!-- 店舗メニューバー -->
<%@include file="../main/shop_menu.jsp" %>


<%
    // ShopProfileActionから渡されたShopオブジェクトを取得
    Shop shop = (Shop)request.getAttribute("shop_profile");

    // データがない場合（Action側で処理されるべきですが、保険として）
    if (shop == null) {
        response.sendRedirect(request.getContextPath() + "/tabematch/shop/ShopMenu.action");
        return;
    }

    // 日付フォーマットの準備
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    String formattedDate = (shop.getShopDate() != null) ? sdf.format(shop.getShopDate()) : "情報なし";

    // 営業時間の整形（java.sql.Timeを文字列化）
    String formattedTime = (shop.getShopTime() != null) ? shop.getShopTime().toString() : "情報なし";

    // 予約可否の表示変換
    String reserveStatus = "1".equals(shop.getShopReserve()) ? "予約不可" : "予約受付中";
%>

<style>
.profile-container {
    width: 90%;
    max-width: 900px;
    margin: 40px auto;
    padding: 30px;
    border: 1px solid #4CAF50; /* テーマカラーの枠線 */
    border-radius: 10px;
    background-color: #ffffff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    font-family: 'Kosugi Maru', sans-serif;
}
.profile-header {
    border-bottom: 3px solid #4CAF50;
    padding-bottom: 15px;
    margin-bottom: 25px;
}
.profile-title {
    font-size: 2em;
    font-weight: bold;
    color: #333;
}
.profile-detail {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}
.profile-item {
    width: 48%; /* 2列表示 */
    padding: 10px;
    border-bottom: 1px dashed #ccc;
}
.profile-item:nth-child(2n+1) {
    border-right: 1px solid #eee; /* 列の区切り線 */
}
.profile-item-label {
    font-weight: bold;
    color: #4CAF50;
    display: block;
    margin-bottom: 3px;
    font-size: 0.9em;
}
.profile-item-value {
    font-size: 1em;
    color: #555;
}
.button-section {
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #ddd;
    display: flex;
    justify-content: flex-start;
    gap: 15px;
}
.action-btn {
    padding: 10px 18px;
    border-radius: 5px;
    text-decoration: none;
    font-weight: bold;
    transition: opacity 0.2s;
}
.action-btn:hover {
    opacity: 0.8;
}
.btn-edit {
    background-color: #FFC107; /* 黄色 */
    color: #333;
}
.btn-password {
    background-color: #2196F3; /* 青色 */
    color: white;
}
.btn-delete {
    background-color: #F44336; /* 赤色 */
    color: white;
}
.profile-container{
	margin-top: 100px;
}
</style>

<div class="profile-container">
    <div class="profile-header">
        <h1 class="profile-title">店舗プロフィール: <%= shop.getShopName() %></h1>
        <p style="color: #999; margin-top: 5px;">店舗ID: <%= shop.getShopId() %></p>
    </div>

    <div class="profile-detail">
        <div class="profile-item">
            <span class="profile-item-label">店舗名</span>
            <span class="profile-item-value"><%= shop.getShopName() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">住所</span>
            <span class="profile-item-value"><%= shop.getShopAddress() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">電話番号</span>
            <span class="profile-item-value"><%= shop.getShopTel() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">メールアドレス</span>
            <span class="profile-item-value"><%= shop.getShopMail() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">営業時間</span>
            <span class="profile-item-value"><%= formattedTime %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">座席数</span>
            <span class="profile-item-value"><%= shop.getShopSeat() %> 席</span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">ジャンル</span>
            <span class="profile-item-value"><%= shop.getShopGenre() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">アレルギー対応情報</span>
            <span class="profile-item-value"><%= shop.getShopAllergy() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">価格帯</span>
            <span class="profile-item-value"><%= shop.getShopPrice() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">決済方法</span>
            <span class="profile-item-value"><%= shop.getShopPay() %></span>
        </div>
        <div class="profile-item">
            <span class="profile-item-label">予約ステータス</span>
            <span class="profile-item-value"><%= reserveStatus %></span>
        </div>
        <div class="profile-item" style="width: 100%;">
            <span class="profile-item-label">店舗URL</span>
            <span class="profile-item-value"><a href="<%= shop.getShopUrl() %>" target="_blank"><%= shop.getShopUrl() %></a></span>
        </div>
        <div class="profile-item" style="width: 100%;">
            <span class="profile-item-label">メイン画像ファイル名</span>
            <span class="profile-item-value"><%= shop.getShopPicture() %></span>
        </div>
    </div>

    <%-- アクションボタンセクション --%>
    <div class="button-section">
        <%-- ★修正: パスに /tabematch/shop/ を追加 --%>
        <a href="${pageContext.request.contextPath}/tabematch/shop/ShopEditRequest.action" class="action-btn btn-edit">
            店舗情報の編集をリクエスト
        </a>

        <a href="${pageContext.request.contextPath}/tabematch/UserPassUpdate.action" class="action-btn btn-password">
            パスワード変更
        </a>

        <a href="${pageContext.request.contextPath}/tabematch/shop/ShopDeleteRequest.action" class="action-btn btn-delete">
            店舗の削除をリクエスト
        </a>
    </div>
</div>

<!-- フッター -->
<%@include file="../../footer.html" %>
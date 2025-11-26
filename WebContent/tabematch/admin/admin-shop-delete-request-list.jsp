<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@include file="../../header.html" %>
<%@include file="../main/admin_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
body {
    background-color: #e8f8e8;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
}
.container {
    max-width: 1200px;
    margin: 30px auto;
    padding: 30px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
h1 {
    color: #F44336;
    text-align: center;
    margin-bottom: 30px;
}
.warning-banner {
    background-color: #fff3cd;
    border: 2px solid #ffc107;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 30px;
    text-align: center;
}
.warning-banner h3 {
    color: #856404;
    margin: 0;
}
.message {
    text-align: center;
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 5px;
}
.success-message {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}
.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}
.request-card {
    border: 2px solid #F44336;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    background-color: #fff5f5;
}
.request-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 2px solid #ddd;
}
.shop-name {
    font-size: 1.4em;
    font-weight: bold;
    color: #333;
}
.request-date {
    color: #666;
    font-size: 0.9em;
}
.shop-info {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 15px;
    margin-bottom: 15px;
}
.info-row {
    display: flex;
    padding: 8px 0;
    border-bottom: 1px dashed #eee;
}
.info-row:last-child {
    border-bottom: none;
}
.info-label {
    font-weight: bold;
    width: 120px;
    color: #555;
}
.info-value {
    flex: 1;
    color: #333;
}
.delete-reason {
    background-color: #ffebee;
    border: 2px solid #F44336;
    border-radius: 5px;
    padding: 15px;
    margin-bottom: 15px;
}
.delete-reason h4 {
    margin-top: 0;
    color: #D32F2F;
}
.action-buttons {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
}
.btn {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
    transition: all 0.3s;
}
.btn-approve {
    background-color: #F44336;
    color: white;
}
.btn-approve:hover {
    background-color: #d32f2f;
    transform: translateY(-2px);
}
.btn-reject {
    background-color: #9E9E9E;
    color: white;
}
.btn-reject:hover {
    background-color: #757575;
    transform: translateY(-2px);
}
.reject-form {
    background-color: #fff;
    border: 2px solid #9E9E9E;
    border-radius: 5px;
    padding: 15px;
    margin-top: 15px;
}
.reject-form textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    resize: vertical;
    min-height: 80px;
}
.no-requests {
    text-align: center;
    padding: 50px;
    color: #666;
}
</style>

<div class="container">
    <h1>🗑️ 店舗削除リクエスト一覧</h1>

    <div class="warning-banner">
        <h3>⚠️ 重要な注意</h3>
        <p>削除を承認すると、店舗情報、アカウント、関連する予約・お気に入りデータがすべて削除されます。</p>
    </div>

    <%
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        if (successMessage != null) {
    %>
        <div class="message success-message"><%= successMessage %></div>
    <%
            session.removeAttribute("successMessage");
        }

        if (errorMessage != null) {
    %>
        <div class="message error-message"><%= errorMessage %></div>
    <%
            session.removeAttribute("errorMessage");
        }

        List<Map<String, Object>> deleteRequestList = (List<Map<String, Object>>) request.getAttribute("deleteRequestList");

        if (deleteRequestList == null || deleteRequestList.isEmpty()) {
    %>
        <div class="no-requests">現在、承認待ちの削除リクエストはありません。</div>
    <%
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            for (Map<String, Object> req : deleteRequestList) {
    %>
        <div class="request-card">
            <div class="request-header">
                <div class="shop-name"><%= req.get("shopName") %></div>
                <div class="request-date">
                    申請日時: <%= sdf.format(req.get("createdAt")) %>
                </div>
            </div>

            <div class="shop-info">
                <h3 style="margin-top: 0; color: #333;">店舗情報</h3>

                <div class="info-row">
                    <div class="info-label">店舗ID:</div>
                    <div class="info-value"><%= req.get("shopId") %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">住所:</div>
                    <div class="info-value"><%= req.get("shopAddress") %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">電話番号:</div>
                    <div class="info-value"><%= req.get("shopTel") %></div>
                </div>

                <div class="info-row">
                    <div class="info-label">メールアドレス:</div>
                    <div class="info-value"><%= req.get("shopMail") %></div>
                </div>
            </div>

            <div class="delete-reason">
                <h4>🚨 削除理由</h4>
                <p style="margin: 0;"><%= req.get("deleteReason") %></p>
            </div>

            <div class="action-buttons">
                <button class="btn btn-approve" onclick="approveDeleteRequest('<%= req.get("requestId") %>', '<%= req.get("shopName") %>')">
                    ✓ 削除を承認
                </button>
                <button class="btn btn-reject" onclick="toggleRejectForm('<%= req.get("requestId") %>')">
                    ✕ 削除を却下
                </button>
            </div>

            <div id="reject_<%= req.get("requestId") %>" class="reject-form" style="display: none;">
                <h4>却下理由を入力してください</h4>
                <form action="<%= request.getContextPath() %>/tabematch/admin/AdminShopDeleteRequestReject.action" method="post">
                    <input type="hidden" name="requestId" value="<%= req.get("requestId") %>">
                    <textarea name="rejectReason" required placeholder="例: 削除理由が不明確なため、再度ご確認ください"></textarea>
                    <div style="margin-top: 10px; text-align: right;">
                        <button type="submit" class="btn btn-reject">却下を確定</button>
                        <button type="button" class="btn" style="background-color: #757575; color: white;" onclick="toggleRejectForm('<%= req.get("requestId") %>')">キャンセル</button>
                    </div>
                </form>
            </div>
        </div>
    <%
            }
        }
    %>

    <div style="text-align: center; margin-top: 30px;">
        <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp" style="color: #F44336; text-decoration: none; font-weight: bold;">
            ← 管理者ホームに戻る
        </a>
    </div>
</div>

<script>
function approveDeleteRequest(requestId, shopName) {
    var confirmMsg = '【警告】\n\n店舗「' + shopName + '」を完全に削除します。\n\n' +
                     '以下のデータがすべて削除されます：\n' +
                     '・店舗情報\n' +
                     '・店舗アカウント\n' +
                     '・予約データ\n' +
                     '・お気に入り登録\n' +
                     '・レビューデータ\n\n' +
                     'この操作は取り消すことができません。\n\n' +
                     '本当に削除しますか？';

    if (confirm(confirmMsg)) {
        window.location.href = '<%= request.getContextPath() %>/tabematch/admin/AdminShopDeleteRequestApprove.action?requestId=' + requestId;
    }
}

function toggleRejectForm(requestId) {
    var form = document.getElementById('reject_' + requestId);
    if (form.style.display === 'none') {
        form.style.display = 'block';
    } else {
        form.style.display = 'none';
    }
}
</script>

<%@include file="../../footer.html" %>
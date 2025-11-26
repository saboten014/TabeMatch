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
    color: #4CAF50;
    text-align: center;
    margin-bottom: 30px;
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
    border: 2px solid #4CAF50;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    background-color: #f9f9f9;
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
.change-summary {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 5px;
    padding: 15px;
    margin-bottom: 15px;
}
.change-item {
    display: flex;
    padding: 8px 0;
    border-bottom: 1px dashed #eee;
}
.change-item:last-child {
    border-bottom: none;
}
.change-label {
    font-weight: bold;
    width: 150px;
    color: #555;
}
.change-value {
    flex: 1;
}
.old-value {
    color: #999;
    text-decoration: line-through;
}
.new-value {
    color: #4CAF50;
    font-weight: bold;
}
.request-note {
    background-color: #fff3cd;
    border: 1px solid #ffc107;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;
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
    background-color: #4CAF50;
    color: white;
}
.btn-approve:hover {
    background-color: #45a049;
    transform: translateY(-2px);
}
.btn-reject {
    background-color: #F44336;
    color: white;
}
.btn-reject:hover {
    background-color: #d32f2f;
    transform: translateY(-2px);
}
.reject-form {
    background-color: #fff;
    border: 2px solid #F44336;
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
    <h1>📝 店舗編集リクエスト一覧</h1>

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

        List<Map<String, Object>> editRequestList = (List<Map<String, Object>>) request.getAttribute("editRequestList");

        if (editRequestList == null || editRequestList.isEmpty()) {
    %>
        <div class="no-requests">現在、承認待ちの編集リクエストはありません。</div>
    <%
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            for (Map<String, Object> req : editRequestList) {
    %>
        <div class="request-card">
            <div class="request-header">
                <div class="shop-name">
                    <%= req.get("currentShopName") %>
                    <% if (!req.get("currentShopName").equals(req.get("newShopName"))) { %>
                        → <%= req.get("newShopName") %>
                    <% } %>
                </div>
                <div class="request-date">
                    <%= sdf.format(req.get("createdAt")) %>
                </div>
            </div>

            <div class="change-summary">
                <h3 style="margin-top: 0; color: #4CAF50;">変更内容</h3>

                <% if (!req.get("currentShopName").equals(req.get("newShopName"))) { %>
                <div class="change-item">
                    <div class="change-label">店舗名:</div>
                    <div class="change-value">
                        <span class="old-value"><%= req.get("currentShopName") %></span>
                        → <span class="new-value"><%= req.get("newShopName") %></span>
                    </div>
                </div>
                <% } %>

                <div class="change-item">
                    <div class="change-label">住所:</div>
                    <div class="change-value"><%= req.get("shopAddress") %></div>
                </div>

                <div class="change-item">
                    <div class="change-label">電話番号:</div>
                    <div class="change-value"><%= req.get("shopTel") %></div>
                </div>

                <% if (req.get("shopUrl") != null && !req.get("shopUrl").toString().isEmpty()) { %>
                <div class="change-item">
                    <div class="change-label">URL:</div>
                    <div class="change-value"><%= req.get("shopUrl") %></div>
                </div>
                <% } %>

                <% if (req.get("shopGenre") != null) { %>
                <div class="change-item">
                    <div class="change-label">ジャンル:</div>
                    <div class="change-value"><%= req.get("shopGenre") %></div>
                </div>
                <% } %>

                <% if (req.get("shopAllergy") != null) { %>
                <div class="change-item">
                    <div class="change-label">アレルギー対応:</div>
                    <div class="change-value"><%= req.get("shopAllergy") %></div>
                </div>
                <% } %>
            </div>

            <% if (req.get("requestNote") != null && !req.get("requestNote").toString().isEmpty()) { %>
            <div class="request-note">
                <strong>📌 店舗からのメモ:</strong><br>
                <%= req.get("requestNote") %>
            </div>
            <% } %>

            <div class="action-buttons">
                <button class="btn btn-approve" onclick="approveRequest('<%= req.get("requestId") %>')">
                    ✓ 承認
                </button>
                <button class="btn btn-reject" onclick="toggleRejectForm('<%= req.get("requestId") %>')">
                    ✕ 却下
                </button>
            </div>

            <div id="reject_<%= req.get("requestId") %>" class="reject-form" style="display: none;">
                <h4>却下理由を入力してください</h4>
                <form action="<%= request.getContextPath() %>/tabematch/admin/AdminShopEditRequestReject.action" method="post">
                    <input type="hidden" name="requestId" value="<%= req.get("requestId") %>">
                    <textarea name="rejectReason" required placeholder="例: 提供された情報が不十分なため"></textarea>
                    <div style="margin-top: 10px; text-align: right;">
                        <button type="submit" class="btn btn-reject">却下を確定</button>
                        <button type="button" class="btn" style="background-color: #9E9E9E; color: white;" onclick="toggleRejectForm('<%= req.get("requestId") %>')">キャンセル</button>
                    </div>
                </form>
            </div>
        </div>
    <%
            }
        }
    %>

    <div style="text-align: center; margin-top: 30px;">
        <a href="<%= request.getContextPath() %>/tabematch/main/admin_home.jsp" style="color: #4CAF50; text-decoration: none; font-weight: bold;">
            ← 管理者ホームに戻る
        </a>
    </div>
</div>

<script>
function approveRequest(requestId) {
    if (confirm('この編集リクエストを承認しますか？')) {
        window.location.href = '<%= request.getContextPath() %>/tabematch/admin/AdminShopEditRequestApprove.action?requestId=' + requestId;
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
<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Request" %>
<%@include file="../main/user_menu.jsp" %>
<%@include file="../../header.html" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-request-list.css">

<body>
<div class="main-content">
    <h1>✨ 掲載リクエスト承認</h1>

    <%-- メッセージ表示 --%>
    <% String successMessage = (String)request.getAttribute("successMessage");
       String errorMessage = (String)request.getAttribute("errorMessage");
       if (successMessage != null) { %>
        <div class="msg-success">✅ <%= successMessage %></div>
    <% } if (errorMessage != null) { %>
        <div class="msg-error">🚨 <%= errorMessage %></div>
    <% } %>

    <a href="../main/admin_home.jsp" class="back-link">← 管理者トップに戻る</a>

    <%
        List<Request> pendingRequests = (List<Request>)request.getAttribute("pendingRequests");
        if (pendingRequests == null || pendingRequests.isEmpty()) {
    %>
        <div style="text-align: center; padding: 50px; color: #999;">
            <p style="font-size: 1.2em;">現在、承認待ちのリクエストはありません☘️</p>
        </div>
    <% } else { %>
        <p style="margin-bottom: 10px; color: #666;">
            現在の承認待ち: <b><%= pendingRequests.size() %></b> 件
        </p>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>店舗名</th>
                    <th>メールアドレス</th> <%-- 追加 --%>
                    <th>住所</th>
                    <th>ジャンル</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
            <% for (Request req : pendingRequests) { %>
                <tr>
                    <td><%= req.getRequestId() %></td>
                    <td><b><%= req.getRestaurantName() %></b></td>
                    <%-- Beanのメソッド名 getRequest_mail() に修正 --%>
                    <td style="font-size: 0.85em;"><a href="mailto:%= req.getRequest_mail() %>"><%= req.getRequest_mail() %></a></td>
                    <td style="font-size: 0.85em;"><%= req.getAddress() %></td>
                    <td><span style="background:#e8f5e9; padding:4px 10px; border-radius:10px;"><%= req.getGenre() %></span></td>
                    <td>
                        <button class="btn-detail" onclick="showDetails('<%= req.getRequestId() %>')">詳細</button>
                        <button class="btn-approve" onclick="approveRequest('<%= req.getRequestId() %>')">承認</button>
                        <button class="btn-reject" onclick="showRejectForm('<%= req.getRequestId() %>')">却下</button>
                    </td>
                </tr>

                <%-- 詳細パネル (colspan 6) --%>
                <tr id="details_<%= req.getRequestId() %>" style="display: none;">
                    <td colspan="6" class="detail-box">
                        <h3>📋 店舗の詳細情報</h3>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 0.9em;">
                            <%-- ここも getRequest_mail() に修正 --%>
                            <p><b>申請者メールアドレス:</b> <%= req.getRequest_mail() %></p>
                            <p><b>電話番号:</b> <%= req.getNumber() %></p>
                            <p><b>アレルギー対応:</b> <%= req.getAllergySupport() %></p>
                            <p><b>予約可否:</b> <%= req.getReservation() == 1 ? "可能" : "不可" %></p>
                            <p><b>営業時間:</b> <%= req.getBusinessHours() %></p>
                            <p><b>決済方法:</b> <%= req.getPayment() %></p>
                            <p><b>価格帯:</b> <%= req.getPriceRange() != null ? req.getPriceRange() : "未設定" %></p>
                            <p><b>座席:</b> <%= req.getSeat() %></p>
                            <p><b>HPリンク:</b> <%= req.getLink() != null ? req.getLink() : "未設定" %></p>
                        </div>
                    </td>
                </tr>

                <%-- 却下フォームパネル (colspan 6) --%>
                <tr id="reject_<%= req.getRequestId() %>" style="display: none;">
                    <td colspan="6" class="reject-box">
                        <h3>理由を教えてください</h3>
                        <form action="AdminRequestReject.action" method="post">
                            <input type="hidden" name="requestId" value="<%= req.getRequestId() %>">
                            <textarea name="reason" placeholder="店舗側に通知される却下理由を入力してください..." required></textarea>
                            <div style="text-align: right;">
                                <button type="button" onclick="hideRejectForm('<%= req.getRequestId() %>')">キャンセル</button>
                                <button type="submit" class="btn-reject">却下を確定する</button>
                            </div>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</div>

<script>
function showDetails(requestId) {
    var detailRow = document.getElementById('details_' + requestId);
    detailRow.style.display = (detailRow.style.display === 'none') ? 'table-row' : 'none';
}
function approveRequest(requestId) {
    if (confirm('このリクエストを承認して、お店を公開しますか？')) {
        window.location.href = 'AdminRequestApprove.action?requestId=' + requestId;
    }
}
function showRejectForm(requestId) {
    document.getElementById('reject_' + requestId).style.display = 'table-row';
}
function hideRejectForm(requestId) {
    document.getElementById('reject_' + requestId).style.display = 'none';
}
</script>
</body>

<%@include file="../../footer.html" %>
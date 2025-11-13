<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="bean.Request" %>
<%@include file="../../header.html" %>

<h1>掲載リクエスト承認画面</h1>

<%
    String successMessage = (String)request.getAttribute("successMessage");
    String errorMessage = (String)request.getAttribute("errorMessage");

    if (successMessage != null) {
%>
    <p style="color: green;"><%= successMessage %></p>
<%
    }

    if (errorMessage != null) {
%>
    <p style="color: red;"><%= errorMessage %></p>
<%
    }
%>

<p><a href="../main/admin_home.jsp">← 管理者トップに戻る</a></p>

<%
    List<Request> pendingRequests = (List<Request>)request.getAttribute("pendingRequests");

    if (pendingRequests == null || pendingRequests.isEmpty()) {
%>
    <p>現在、承認待ちのリクエストはありません。</p>
<%
    } else {
%>
    <p>承認待ちリクエスト: <%= pendingRequests.size() %>件</p>

    <table border="1" cellpadding="10" cellspacing="0" style="width: 100%; border-collapse: collapse;">
        <tr style="background-color: #f0f0f0;">
            <th>リクエストID</th>
            <th>店舗名</th>
            <th>住所</th>
            <th>ジャンル</th>
            <th>電話番号</th>
            <th>操作</th>
        </tr>
<%
        for (Request req : pendingRequests) {
%>
        <tr>
            <td><%= req.getRequestId() %></td>
            <td><%= req.getRestaurantName() %></td>
            <td><%= req.getAddress() %></td>
            <td><%= req.getGenre() %></td>
            <td><%= req.getNumber() %></td>
            <td>
                <button onclick="showDetails('<%= req.getRequestId() %>')">詳細</button>
                <button onclick="approveRequest('<%= req.getRequestId() %>')" style="background-color: #28a745; color: white;">承認</button>
                <button onclick="showRejectForm('<%= req.getRequestId() %>')" style="background-color: #dc3545; color: white;">却下</button>
            </td>
        </tr>
        <tr id="details_<%= req.getRequestId() %>" style="display: none;">
            <td colspan="6" style="background-color: #f9f9f9;">
                <h3>詳細情報</h3>
                <p><strong>アレルギー対応:</strong> <%= req.getAllergySupport() %></p>
                <p><strong>予約可否:</strong> <%= req.getReservation() == 1 ? "可能" : "不可" %></p>
                <p><strong>営業時間:</strong> <%= req.getBusinessHours() %></p>
                <p><strong>決済方法:</strong> <%= req.getPayment() %></p>
                <p><strong>価格帯:</strong> <%= req.getPriceRange() != null ? req.getPriceRange() : "未設定" %></p>
                <p><strong>座席:</strong> <%= req.getSeat() %></p>
                <p><strong>HPリンク:</strong> <%= req.getLink() != null ? req.getLink() : "未設定" %></p>
            </td>
        </tr>
        <tr id="reject_<%= req.getRequestId() %>" style="display: none;">
            <td colspan="6" style="background-color: #fff3cd;">
                <h3>却下理由を入力</h3>
                <form action="AdminRequestReject.action" method="post">
                    <input type="hidden" name="requestId" value="<%= req.getRequestId() %>">
                    <textarea name="reason" rows="4" cols="60" required></textarea><br>
                    <button type="submit" style="background-color: #dc3545; color: white;">却下確定</button>
                    <button type="button" onclick="hideRejectForm('<%= req.getRequestId() %>')">キャンセル</button>
                </form>
            </td>
        </tr>
<%
        }
%>
    </table>
<%
    }
%>

<script>
function showDetails(requestId) {
    var detailRow = document.getElementById('details_' + requestId);
    if (detailRow.style.display === 'none') {
        detailRow.style.display = 'table-row';
    } else {
        detailRow.style.display = 'none';
    }
}

function approveRequest(requestId) {
    if (confirm('このリクエストを承認しますか？')) {
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

<%@include file="../../header.html" %>
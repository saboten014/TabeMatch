<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reserve" %>
<%@ page import="bean.Shop" %>
<%@ include file="../../header.html" %>
<%@ include file="../main/shop_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
body {
    background-color: #e8f8e8;
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    padding-top: 80px;
}

.container {
    max-width: 1200px;
    margin: 20px auto;
    padding: 30px;
    background-color: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

h1 {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
    font-size: 28px;
}

.message {
    text-align: center;
    margin-bottom: 20px;
    padding: 15px;
    border-radius: 8px;
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

.filter-section {
    display: flex;
    gap: 15px;
    margin-bottom: 20px;
    padding: 15px;
    background-color: #f8f9fa;
    border-radius: 8px;
}

.filter-section label {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 16px;
}

.filter-section input[type="radio"] {
    cursor: pointer;
}

.reservation-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

.reservation-table th {
    background-color: #4CAF50;
    color: white;
    padding: 12px;
    text-align: left;
    font-weight: bold;
}

.reservation-table td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
}

.reservation-table tr:hover {
    background-color: #f5f5f5;
}

.status-badge {
    display: inline-block;
    padding: 5px 12px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: bold;
}

.status-pending {
    background-color: #fff3cd;
    color: #856404;
}

.status-approved {
    background-color: #d4edda;
    color: #155724;
}

.status-rejected {
    background-color: #f8d7da;
    color: #721c24;
}

.action-buttons {
    display: flex;
    gap: 10px;
}

.btn {
    padding: 8px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    font-weight: bold;
    transition: all 0.3s ease;
}

.btn-approve {
    background-color: #28a745;
    color: white;
}

.btn-approve:hover {
    background-color: #218838;
    transform: translateY(-2px);
}

.btn-reject {
    background-color: #dc3545;
    color: white;
}

.btn-reject:hover {
    background-color: #c82333;
    transform: translateY(-2px);
}

.btn-detail {
    background-color: #007bff;
    color: white;
}

.btn-detail:hover {
    background-color: #0056b3;
    transform: translateY(-2px);
}

.detail-row {
    background-color: #f9f9f9;
}

.detail-content {
    padding: 20px;
}

.detail-content h3 {
    color: #4CAF50;
    margin-bottom: 15px;
}

.detail-content p {
    margin: 8px 0;
    line-height: 1.6;
}

.no-reservations {
    text-align: center;
    padding: 40px;
    color: #666;
    font-size: 18px;
}
</style>

<div class="container">
    <h1>📅 予約管理</h1>

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

        Shop shop = (Shop) request.getAttribute("shop");
        List<Reserve> reservationList = (List<Reserve>) request.getAttribute("reservationList");

        if (reservationList == null || reservationList.isEmpty()) {
    %>
        <div class="no-reservations">現在、予約はありません。</div>
    <%
        } else {
    %>

    <!-- ステータスフィルター -->
    <div class="filter-section">
        <label><input type="radio" name="statusFilter" value="all" checked onchange="filterReservations('all')"> すべて</label>
        <label><input type="radio" name="statusFilter" value="1" onchange="filterReservations('1')"> 承認待ち</label>
        <label><input type="radio" name="statusFilter" value="2" onchange="filterReservations('2')"> 承認済み</label>
        <label><input type="radio" name="statusFilter" value="3" onchange="filterReservations('3')"> 拒否</label>
    </div>

    <table class="reservation-table">
        <thead>
            <tr>
                <th>予約日</th>
                <th>時間</th>
                <th>人数</th>
                <th>ステータス</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Reserve reserve : reservationList) {
                String statusClass = "";
                String statusText = "";

                // UUIDを取得（文字列ID）
                String reserveIdStr = reserve.getReserveIdString();

                switch (reserve.getReserveStatus()) {
                    case 1:
                        statusClass = "status-pending";
                        statusText = "承認待ち";
                        break;
                    case 2:
                        statusClass = "status-approved";
                        statusText = "承認済み";
                        break;
                    case 3:
                        statusClass = "status-rejected";
                        statusText = "拒否";
                        break;
                    default:
                        statusClass = "status-pending";
                        statusText = "不明";
                }
        %>
            <tr class="reservation-row" data-status="<%= reserve.getReserveStatus() %>">
                <td><%= reserve.getVisitDate() %></td>
                <td><%= reserve.getVisitTime() %></td>
                <td><%= reserve.getNumOfPeople() %>名</td>
                <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                <td>
                    <div class="action-buttons">
                        <button class="btn btn-detail" onclick="toggleDetail('detail_<%= reserve.getReserveId() %>')">詳細</button>
                        <% if (reserve.getReserveStatus() == 1) { %>
                            <button class="btn btn-approve" onclick="updateReservation('<%= reserveIdStr %>', 2)">承認</button>
                            <button class="btn btn-reject" onclick="updateReservation('<%= reserveIdStr %>', 3)">拒否</button>
                        <% } %>
                    </div>
                </td>
            </tr>
            <tr id="detail_<%= reserve.getReserveId() %>" class="detail-row" style="display: none;">
                <td colspan="5">
                    <div class="detail-content">
                        <h3>予約詳細情報</h3>
                        <p><strong>予約ID:</strong> <%= reserveIdStr %></p>
                        <p><strong>ユーザーID:</strong> <%= reserve.getUserId() %></p>
                        <p><strong>来店日:</strong> <%= reserve.getVisitDate() %></p>
                        <p><strong>来店時間:</strong> <%= reserve.getVisitTime() %></p>
                        <p><strong>人数:</strong> <%= reserve.getNumOfPeople() %>名</p>
                        <p><strong>アレルギー情報:</strong> <%= reserve.getAllergyNotes() != null && !reserve.getAllergyNotes().isEmpty() ? reserve.getAllergyNotes() : "なし" %></p>
                        <p><strong>その他リクエスト:</strong> <%= reserve.getMessage() != null && !reserve.getMessage().isEmpty() ? reserve.getMessage() : "なし" %></p>
                        <p><strong>予約受付日時:</strong> <%= reserve.getStatus() %></p>
                    </div>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        }
    %>
</div>

<script>
// 詳細表示の切り替え
function toggleDetail(detailId) {
    const detailRow = document.getElementById(detailId);
    if (detailRow.style.display === 'none') {
        detailRow.style.display = 'table-row';
    } else {
        detailRow.style.display = 'none';
    }
}

// 予約ステータスの更新
function updateReservation(reserveId, status) {
    const statusText = status === 2 ? '承認' : '拒否';
    if (confirm('この予約を' + statusText + 'しますか？')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'ShopReservationUpdate.action';

        const reserveIdInput = document.createElement('input');
        reserveIdInput.type = 'hidden';
        reserveIdInput.name = 'reserveId';
        reserveIdInput.value = reserveId;

        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'status';
        statusInput.value = status;

        form.appendChild(reserveIdInput);
        form.appendChild(statusInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// ステータスフィルター
function filterReservations(status) {
    const rows = document.querySelectorAll('.reservation-row');
    rows.forEach(row => {
        const detailRow = row.nextElementSibling;
        if (status === 'all') {
            row.style.display = '';
        } else {
            if (row.dataset.status === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
                if (detailRow && detailRow.classList.contains('detail-row')) {
                    detailRow.style.display = 'none';
                }
            }
        }
    });
}
</script>

<%@ include file="../../footer.html" %>
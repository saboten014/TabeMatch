<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Reserve" %>
<%@ page import="bean.Shop" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%@ include file="../../header.html" %>
<%@ include file="../main/shop_menu.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>予約管理 | たべまっち</title>
    <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shop-reservation.css">
</head>
<body>

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

        List<Reserve> reservationList = (List<Reserve>) request.getAttribute("reservationList");

        if (reservationList == null || reservationList.isEmpty()) {
    %>
        <div class="no-reservations">現在、予約はありません。</div>
    <%
        } else {
    %>

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
                <th>連絡先</th>
                <th>ステータス</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <%
            String[] dayOfWeeks = {"", "月", "火", "水", "木", "金", "土", "日"};

            for (Reserve reserve : reservationList) {
                String statusClass = "";
                String statusText = "";

                // --- メソッド名と型の修正 ---
                // reserve.getVisitDate() 等が Date 型を返すため、toString() で String に変換します。
                // もし null の可能性がある場合は String.valueOf() を使うのが安全です。
                String visitDateRaw = (reserve.getVisitDate() != null) ? reserve.getVisitDate().toString() : null;
                String visitTimeRaw = (reserve.getVisitTime() != null) ? reserve.getVisitTime().toString() : null;

                // 日付の整形 (yyyy-MM-dd -> M月d日(曜))
                String formattedDate = (visitDateRaw != null) ? visitDateRaw : "不明";
                try {
                    if (visitDateRaw != null) {
                        // Date.toString() の形式が yyyy-MM-dd であることを想定
                        LocalDate date = LocalDate.parse(visitDateRaw);
                        formattedDate = date.getMonthValue() + "月" + date.getDayOfMonth() + "日(" + dayOfWeeks[date.getDayOfWeek().getValue()] + ")";
                    }
                } catch (Exception e) {
                    formattedDate = (visitDateRaw != null) ? visitDateRaw : "不明";
                }

                // 時間の整形 (HH:mm:ss -> HH:mm)
                String formattedTime = (visitTimeRaw != null && visitTimeRaw.length() >= 5) ? visitTimeRaw.substring(0, 5) : "不明";

                switch (reserve.getReserveStatus()) {
                    case 1: statusClass = "status-pending"; statusText = "承認待ち"; break;
                    case 2: statusClass = "status-approved"; statusText = "承認済み"; break;
                    case 3: statusClass = "status-rejected"; statusText = "拒否"; break;
                    default: statusClass = "status-pending"; statusText = "不明";
                }
        %>
            <tr class="reservation-row" data-status="<%= reserve.getReserveStatus() %>">
                <td style="font-weight: bold;"><%= formattedDate %></td>
                <td><%= formattedTime %></td>
                <td><%= reserve.getNumOfPeople() %>名</td>
                <td style="color: #2d5a2e; font-weight: bold;">
                    <%= (reserve.getReserveTel() != null && !reserve.getReserveTel().isEmpty()) ? "📞 " + reserve.getReserveTel() : "-" %>
                </td>
                <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                <td>
                    <div class="action-buttons">
                        <button class="btn btn-detail" onclick="toggleDetail('detail_<%= reserve.getReserveId() %>')">詳細</button>
                        <% if (reserve.getReserveStatus() == 1) { %>
                            <button class="btn btn-approve" onclick="updateReservation('<%= reserve.getReserveIdString() %>', 2)">承認</button>
                            <button class="btn btn-reject" onclick="updateReservation('<%= reserve.getReserveIdString() %>', 3)">拒否</button>
                        <% } %>
                    </div>
                </td>
            </tr>
            <tr id="detail_<%= reserve.getReserveId() %>" class="detail-row" style="display: none;">
                <td colspan="6">
                    <div class="detail-content">
                        <h3>予約詳細情報</h3>
                        <p><strong>ご連絡先:</strong> <%= (reserve.getReserveTel() != null) ? reserve.getReserveTel() : "未登録" %></p>
                        <p><strong>予約ID:</strong> <%= reserve.getReserveIdString() %></p>
                        <p><strong>来店日時:</strong> <%= formattedDate %> <%= formattedTime %></p>
                        <p><strong>アレルギー情報:</strong> <%= (reserve.getAllergyNotes() != null && !reserve.getAllergyNotes().isEmpty()) ? reserve.getAllergyNotes() : "なし" %></p>
                        <p><strong>リクエスト:</strong> <%= (reserve.getMessage() != null && !reserve.getMessage().isEmpty()) ? reserve.getMessage() : "なし" %></p>
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
function toggleDetail(detailId) {
    const detailRow = document.getElementById(detailId);
    if(detailRow) {
        detailRow.style.display = (detailRow.style.display === 'none') ? 'table-row' : 'none';
    }
}

function updateReservation(reserveId, status) {
    const statusText = status === 2 ? '承認' : '拒否';
    if (confirm('この予約を' + statusText + 'しますか？')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'ShopReservationUpdate.action';
        const params = {reserveId: reserveId, status: status};
        for(let key in params) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = params[key];
            form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
    }
}

function filterReservations(status) {
    document.querySelectorAll('.reservation-row').forEach(row => {
        const isShow = (status === 'all' || row.dataset.status === status);
        row.style.display = isShow ? '' : 'none';
        const nextRow = row.nextElementSibling;
        if (nextRow && nextRow.classList.contains('detail-row')) {
            nextRow.style.display = 'none';
        }
    });
}
</script>

<%@ include file="../../footer.html" %>
</body>
</html>
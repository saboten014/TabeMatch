<%@page pageEncoding="UTF-8" %>
<%@page import="java.util.*, bean.Reserve, java.text.SimpleDateFormat, dao.ReserveDAO.ReservationDayStatus"%>
<%
    String contextPath = request.getContextPath();
    String actionPath = contextPath + "/tabematch/shop/ShopManagement.action";

    List<Reserve> todayReservations = (List<Reserve>) request.getAttribute("todayReservations");
    Map<Integer, ReservationDayStatus> reservationStatusMap = (Map<Integer, ReservationDayStatus>) request.getAttribute("reservationStatusMap");
    if (reservationStatusMap == null) { reservationStatusMap = new java.util.HashMap<>(); }

    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

    String currentMonthYear = (String) request.getAttribute("currentMonthYear");
    int currentYear = (request.getAttribute("currentYear") != null) ? (Integer) request.getAttribute("currentYear") : Calendar.getInstance().get(Calendar.YEAR);
    int currentMonth = (request.getAttribute("currentMonth") != null) ? (Integer) request.getAttribute("currentMonth") : Calendar.getInstance().get(Calendar.MONTH) + 1;

    String selectedDateString = (String) request.getAttribute("selectedDateString");
    if (selectedDateString == null) { selectedDateString = "今日"; }
    if (currentMonthYear == null) { currentMonthYear = currentYear + "年 " + currentMonth + "月"; }

    int prevMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
    int prevYear = (currentMonth == 1) ? currentYear - 1 : currentYear;
    int nextMonth = (currentMonth == 12) ? 1 : currentMonth + 1;
    int nextYear = (currentMonth == 12) ? currentYear + 1 : currentYear;

    Calendar cal = Calendar.getInstance();
    cal.set(currentYear, currentMonth - 1, 1);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    Calendar todayCal = Calendar.getInstance();
    int todayDay = -1;
    if (todayCal.get(Calendar.YEAR) == currentYear && todayCal.get(Calendar.MONTH) == currentMonth - 1) {
        todayDay = todayCal.get(Calendar.DAY_OF_MONTH);
    }
%>

<%@include file="../../header.html" %>
<jsp:include page="../../tabematch/main/shop_menu.jsp" />

<link rel="stylesheet" href="<%= contextPath %>/css/shop-management.css">
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<div class="zenbu">
    <div class="container">
        <div class="sidebar">
            <h2>🍀 <%= selectedDateString %>の予約</h2>
            <div class="reservation-list">
                <% if (todayReservations != null && !todayReservations.isEmpty()) { %>
                    <% for (Reserve reserve : todayReservations) {
                        int status = reserve.getReserveStatus();
                        String statusText = (status == 1) ? "承認待ち" : (status == 2) ? "承認済み" : (status == 3) ? "拒否" : "不明";
                        String statusColor = (status == 1) ? "#f59e0b" : (status == 2) ? "#5ab45e" : (status == 3) ? "#ef4444" : "#999";
                        String formattedTime = (reserve.getVisitTime() != null) ? timeFormat.format(reserve.getVisitTime()) : "--:--";
                        String uName = (reserve.getUserName() != null) ? reserve.getUserName() : "ゲスト";
                        String allergyParam = (reserve.getAllergyNotes() != null && !reserve.getAllergyNotes().isEmpty()) ? reserve.getAllergyNotes() : "なし";
                        String msgParam = (reserve.getMessage() != null && !reserve.getMessage().isEmpty()) ? reserve.getMessage() : "メッセージはありません";
                    %>
                        <div class="reservation-list-item" onclick="openDetailModal('<%= reserve.getReserveIdString() %>', '<%= uName %>', '<%= formattedTime %>', '<%= reserve.getNumOfPeople() %>', '<%= statusText %>', '<%= statusColor %>', '<%= allergyParam %>', '<%= msgParam %>')">
                            <div class="reservation-time">
                                <span class="time-badge"><%= formattedTime %></span>
                                <span style="color: <%= statusColor %>; font-size: 0.8rem; font-weight: bold;">● <%= statusText %></span>
                            </div>
                            <span class="user-name-label"><%= uName %> 様</span>
                            <div style="font-size: 0.85rem; color: #888;">👥 <%= reserve.getNumOfPeople() %> 名</div>
                            <% if (!"なし".equals(allergyParam)) { %>
                                <div style="color: #ff5e5e; font-size: 0.75rem; margin-top: 5px; font-weight: bold;">⚠️ アレルギーあり</div>
                            <% } %>
                        </div>
                    <% } %>
                <% } else { %>
                    <p style="text-align: center; color: #ccc; margin-top: 40px;">予約はないよ ☕</p>
                <% } %>
            </div>
        </div>

        <div class="main-content">
            <div class="calendar-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <a href="<%= actionPath %>?year=<%= prevYear %>&month=<%= prevMonth %>"><button>前月</button></a>
                <h2 style="margin: 0;"><%= currentMonthYear %></h2>
                <a href="<%= actionPath %>?year=<%= nextYear %>&month=<%= nextMonth %>"><button>次月</button></a>
            </div>

            <div class="calendar-grid">
                <div class="day-header" style="color: #ff8e8e;">日</div>
                <div class="day-header">月</div><div class="day-header">火</div><div class="day-header">水</div>
                <div class="day-header">木</div><div class="day-header">金</div>
                <div class="day-header" style="color: #8eb9ff;">土</div>

                <% for (int j = 1; j < firstDayOfWeek; j++) { %>
                    <div class="day-cell" style="border: none; background: transparent;"></div>
                <% } %>

                <% for (int i = 1; i <= daysInMonth; i++) {
                    ReservationDayStatus status = reservationStatusMap.get(i);
                    String cellClass = "day-cell" + (i == todayDay ? " today" : "");
                %>
                    <a class="<%= cellClass %>" href="<%= actionPath %>?year=<%= currentYear %>&month=<%= currentMonth %>&day=<%= i %>">
                        <span style="font-weight: bold; font-size: 1.1rem;"><%= i %></span>
                        <% if (status != null && status.getTotalCount() > 0) { %>
                            <span class="reserve-count"><%= status.getTotalCount() %>件</span>
                            <% if (status.hasPending()) { %>
                                <span style="color: #f59e0b; position: absolute; top: 10px; right: 10px;">●</span>
                            <% } %>
                        <% } %>
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>

<div id="reserveModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeDetailModal()">&times;</span>
        <h2 class="modal-title">予約をかくにん ✨</h2>

        <div class="modal-item">
            <span class="modal-label">おなまえ</span>
            <span id="m-name" class="modal-value"></span>
        </div>

        <div style="display: flex; gap: 15px;">
            <div class="modal-item" style="flex: 1;">
                <span class="modal-label">じかん</span>
                <span id="m-time" class="modal-value"></span>
            </div>
            <div class="modal-item" style="flex: 1;">
                <span class="modal-label">にんずう</span>
                <span id="m-people" class="modal-value"></span>
            </div>
        </div>

        <div class="modal-item">
            <span class="modal-label">じょうたい</span>
            <span id="m-status" class="modal-value"></span>
        </div>

        <div class="modal-item">
            <span class="modal-label">アレルギー</span>
            <div id="m-allergy" class="allergy-alert"></div>
        </div>

        <div class="modal-item" style="border: none; background: transparent;">
            <span class="modal-label">メッセージ</span>
            <div id="m-message" class="message-box"></div>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <button onclick="closeDetailModal()" style="padding: 12px 40px; border-radius: 15px; border: none; background: #5ab45e; color: white; font-weight: bold; cursor: pointer; box-shadow: 0 4px 10px rgba(90,180,94,0.3);">とじる</button>
        </div>
    </div>
</div>

<script>
function openDetailModal(id, name, time, people, status, color, allergy, message) {
    document.getElementById('m-name').innerText = name + " 様";
    document.getElementById('m-time').innerText = time;
    document.getElementById('m-people').innerText = people + " 名";
    document.getElementById('m-status').innerText = status;
    document.getElementById('m-status').style.color = color;
    document.getElementById('m-message').innerText = message;

    const allergyElem = document.getElementById('m-allergy');
    allergyElem.innerText = allergy;
    allergyElem.className = (allergy === 'なし') ? 'allergy-alert' : 'allergy-alert allergy-exist';

    document.getElementById('reserveModal').style.display = 'block';
}

function closeDetailModal() {
    document.getElementById('reserveModal').style.display = 'none';
}
</script>

<%@include file="../../footer.html" %>
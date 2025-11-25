<%@page pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="bean.Reserve"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="dao.ReserveDAO.ReservationDayStatus"%>
<%
    String contextPath = request.getContextPath();
    String actionPath = contextPath + "/tabematch/shop/ShopManagement.action";

    // Actionから渡された予約リストを取得 (左サイドバー用)
    List<Reserve> todayReservations = (List<Reserve>) request.getAttribute("todayReservations");

    // ★修正：reservationStatusMapを取得
    Map<Integer, ReservationDayStatus> reservationStatusMap =
        (Map<Integer, ReservationDayStatus>) request.getAttribute("reservationStatusMap");
    if (reservationStatusMap == null) {
        reservationStatusMap = new java.util.HashMap<>();
    }

    // 日時フォーマット用のオブジェクト
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

    // Actionからカレンダー情報を取得
    String currentMonthYear = (String) request.getAttribute("currentMonthYear");
    int currentYear = (request.getAttribute("currentYear") != null) ? (Integer) request.getAttribute("currentYear") : Calendar.getInstance().get(Calendar.YEAR);
    int currentMonth = (request.getAttribute("currentMonth") != null) ? (Integer) request.getAttribute("currentMonth") : Calendar.getInstance().get(Calendar.MONTH) + 1;

    String selectedDateString = (String) request.getAttribute("selectedDateString");
    if (selectedDateString == null) {
        selectedDateString = "今日";
    }

    if (currentMonthYear == null) {
        currentMonthYear = currentYear + "年 " + currentMonth + "月";
    }

    // カレンダーの月移動計算
    int prevMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
    int prevYear = (currentMonth == 1) ? currentYear - 1 : currentYear;

    int nextMonth = (currentMonth == 12) ? 1 : currentMonth + 1;
    int nextYear = (currentMonth == 12) ? currentYear + 1 : currentYear;

    // カレンダー動的生成のための計算
    Calendar cal = Calendar.getInstance();
    cal.set(currentYear, currentMonth - 1, 1);

    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    Calendar todayCal = Calendar.getInstance();
    int today = -1;
    if (todayCal.get(Calendar.YEAR) == currentYear && todayCal.get(Calendar.MONTH) == currentMonth - 1) {
        today = todayCal.get(Calendar.DAY_OF_MONTH);
    }
%>

<%@include file="../../header.html" %>
<%@include file="../../tabematch/main/shop_menu.jsp" %>

<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

<style>
.zenbu {
    margin-top: 100px;
}
body {
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    background-color: #e8f8e8;
    margin: 0;
    padding: 0;
}
.container {
    display: flex;
    width: 90%;
    max-width: 1200px;
    margin: 40px auto;
    gap: 20px;
}
.sidebar {
    flex: 3;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    border-left: 5px solid #4CAF50;
    min-height: 600px;
}
.sidebar h2 {
    border-bottom: 2px solid #ddd;
    padding-bottom: 10px;
    margin-bottom: 15px;
    color: #333;
    font-size: 1.5em;
}
.reservation-list-item {
    padding: 10px 0;
    border-bottom: 1px dashed #eee;
    font-size: 0.95em;
}
.reservation-time {
    font-weight: bold;
    color: #4CAF50;
}
.reservation-detail {
    margin-top: 3px;
    color: #555;
}
.main-content {
    flex: 7;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.calendar-header h2 {
    margin: 0;
    color: #4CAF50;
}
.calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 5px;
    text-align: center;
}
.day-header {
    font-weight: bold;
    padding: 10px 0;
    background-color: #d2f0d0;
    border-radius: 4px;
    color: #333;
}
.day-cell {
    padding: 10px 5px;
    background-color: #f9f9f9;
    border: 1px solid #eee;
    height: 70px;
    text-align: left;
    vertical-align: top;
    font-size: 1.1em;
    cursor: pointer;
    transition: background-color 0.2s;
    text-decoration: none;
    color: inherit;
    display: block;
    box-sizing: border-box;
    position: relative;
}
.day-cell:hover {
    background-color: #e6e6e6;
}
.today {
    border: 3px solid #F44336;
    font-weight: bold;
    background-color: #fff0f0;
}
.reserve-count {
    display: block;
    margin-top: 5px;
    font-size: 0.8em;
    color: #00796B;
    font-weight: 500;
}
/* ★追加：ステータスアイコン用のスタイル */
.status-icon {
    display: inline-block;
    margin-left: 5px;
    font-size: 1.2em;
    position: absolute;
    top: 5px;
    right: 5px;
}
.icon-pending {
    color: #FF9800; /* オレンジ：承認待ち */
}
.icon-approved {
    color: #4CAF50; /* 緑：すべて承認済み */
}
</style>

<div class="zenbu">
<div class="container">

    <div class="sidebar">
    <h2>📅 <%= selectedDateString %>の予約一覧</h2>

    <div class="reservation-list">
        <% if (todayReservations != null && !todayReservations.isEmpty()) { %>
            <% for (Reserve reserve : todayReservations) { %>
                <div class="reservation-list-item">
                    <div class="reservation-time">
                        <%= timeFormat.format(reserve.getVisitTime()) %> (<%= reserve.getNumOfPeople() %>名)
                    </div>
                    <div class="reservation-detail">
                        予約ID: <%= reserve.getReserveIdString() %>
                        <%-- ★修正：ステータスを正しく表示 --%>
                        <%
                            String statusText = "";
                            String statusColor = "";
                            int status = reserve.getReserveStatus();

                            if (status == 1) {
                                statusText = "承認待ち";
                                statusColor = "#FF9800"; // オレンジ
                            } else if (status == 2) {
                                statusText = "承認済み";
                                statusColor = "#4CAF50"; // 緑
                            } else if (status == 3) {
                                statusText = "拒否";
                                statusColor = "#F44336"; // 赤
                            } else {
                                statusText = "不明";
                                statusColor = "#999999"; // グレー
                            }
                        %>
                        <span style="color: <%= statusColor %>; font-weight: bold;">
                            [ステータス: <%= statusText %>]
                        </span>
                    </div>
                    <% if (reserve.getAllergyNotes() != null && !reserve.getAllergyNotes().isEmpty()) { %>
                        <div style="color: #D32F2F; font-size: 0.85em;">
                            ⚠️ アレルギー: <%= reserve.getAllergyNotes() %>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } else { %>
            <p style="color: #999; margin-top: 10px; text-align: center;">予約はありません。</p>
        <% } %>
    </div>
</div>

    <div class="main-content">
        <div class="calendar-header">
            <a href="<%= actionPath %>?year=<%= prevYear %>&month=<%= prevMonth %>">
                <button>&lt; 前の月</button>
            </a>

            <h2 style="margin: 0; color: #4CAF50;"><%= currentMonthYear %></h2>

            <a href="<%= actionPath %>?year=<%= nextYear %>&month=<%= nextMonth %>">
                <button>次の月 &gt;</button>
            </a>
        </div>

        <div class="calendar-grid">
            <div class="day-header">日</div>
            <div class="day-header">月</div>
            <div class="day-header">火</div>
            <div class="day-header">水</div>
            <div class="day-header">木</div>
            <div class="day-header">金</div>
            <div class="day-header">土</div>

            <%
            int startColumn = firstDayOfWeek;
            %>

            <%
            for (int j = 1; j < startColumn; j++) {
            %>
                <div class="day-cell" style="background-color: #f0f0f0; cursor: default;"></div>
            <%
            }
            %>

            <% for (int i = 1; i <= daysInMonth; i++) {
                String cellClass = "day-cell";

                if (i == today) {
                    cellClass += " today";
                }

                // ★修正：ステータス情報を取得
                ReservationDayStatus status = reservationStatusMap.get(i);
                String reserveCountText = "";
                String statusIcon = "";

                if (status != null) {
                    int totalCount = status.getTotalCount();
                    reserveCountText = "予約 " + totalCount + "件";

                    // ステータスに応じてアイコンを設定
                    if (status.hasPending()) {
                        // 承認待ちがある場合
                        statusIcon = "<span class='status-icon icon-pending'>！</span>";
                    } else if (status.isAllApproved()) {
                        // すべて承認済みの場合
                        statusIcon = "<span class='status-icon icon-approved'>☆</span>";
                    }
                }

                String clickUrl = actionPath + "?year=" + currentYear + "&month=" + currentMonth + "&day=" + i;
            %>
                <a class="<%= cellClass %>" href="<%= clickUrl %>">
                    <%= i %>
                    <%= statusIcon %> <%-- ★アイコン表示 --%>
                    <% if (!reserveCountText.isEmpty()) { %>
                        <span class="reserve-count"><%= reserveCountText %></span>
                    <% } %>
                </a>
            <% } %>
        </div>
    </div>

</div>
</div>

<%@include file="../../footer.html" %>
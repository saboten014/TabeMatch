<%@page pageEncoding="UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="bean.Reserve"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%
    // ===============================================
    // ★★★ 変数定義の追加 (contextPath, actionPath) ★★★
    // ===============================================
    String contextPath = request.getContextPath();
    // Actionのパスを定義
    String actionPath = contextPath + "/ShopManagementAction";

    // Actionから渡された予約リストを取得 (左サイドバー用)
    List<Reserve> todayReservations = (List<Reserve>) request.getAttribute("todayReservations");

    // Actionから渡されたカレンダーの日付ごとの予約件数マップを取得
    // Map<日付(int), 予約件数(int)>
    Map<Integer, Integer> reservationCounts = (Map<Integer, Integer>) request.getAttribute("reservationCounts");
    if (reservationCounts == null) {
        reservationCounts = new java.util.HashMap<>();
    }


    // 日時フォーマット用のオブジェクト
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

    // ===============================================
    // Actionからカレンダー情報を取得
    // ===============================================
    String currentMonthYear = (String) request.getAttribute("currentMonthYear");
    int currentYear = (request.getAttribute("currentYear") != null) ? (Integer) request.getAttribute("currentYear") : Calendar.getInstance().get(Calendar.YEAR);
    int currentMonth = (request.getAttribute("currentMonth") != null) ? (Integer) request.getAttribute("currentMonth") : Calendar.getInstance().get(Calendar.MONTH) + 1;

    // 現在表示している日付 (サイドバー表示用。Actionから設定された日付)
    // カレンダーセルクリック時に「todayReservations」の対象日が変わることを想定
    String selectedDateString = (String) request.getAttribute("selectedDateString");
    if (selectedDateString == null) {
        selectedDateString = "今日"; // 初期表示
    }

    if (currentMonthYear == null) {
        currentMonthYear = currentYear + "年 " + currentMonth + "月";
    }

    // カレンダーの月移動計算
    int prevMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
    int prevYear = (currentMonth == 1) ? currentYear - 1 : currentYear;

    int nextMonth = (currentMonth == 12) ? 1 : currentMonth + 1;
    int nextYear = (currentMonth == 12) ? currentYear + 1 : currentYear;

    // ===============================================
    // カレンダー動的生成のための計算
    // ===============================================
    Calendar cal = Calendar.getInstance();
    // 表示したい年/月に設定し、日付を1日目に設定
    cal.set(currentYear, currentMonth - 1, 1);

    // 今月の最初の日が何曜日か (1=日, 2=月, ..., 7=土)
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

    // 今月の日数
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    // 今日が何日かを取得（todayマーク用。表示月が現在月と一致する場合のみ）
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
/* -------------------- 全体スタイル -------------------- */
body {
    font-family: "Kosugi Maru", "Meiryo", sans-serif;
    background-color: #e8f8e8;
    margin: 0;
    padding: 0;
}

/* -------------------- メインコンテンツ (3:7レイアウト) -------------------- */
.container {
    display: flex; /* Flexboxで2列レイアウトを作成 */
    width: 90%;
    max-width: 1200px;
    margin: 40px auto;
    gap: 20px;
}

/* 予約一覧 (左側: 3割) */
.sidebar {
    flex: 3; /* 3割の幅 */
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    border-left: 5px solid #4CAF50; /* テーマカラー */
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

/* カレンダー (右側: 7割) */
.main-content {
    flex: 7; /* 7割の幅 */
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

/* カレンダーのグリッド雛形 */
.calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr); /* 曜日×7列 */
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
/* aタグにスタイルを適用 */
.day-cell {
    padding: 10px 5px;
    background-color: #f9f9f9;
    border: 1px solid #eee;
    height: 70px; /* カレンダーのセルの高さを確保 */
    text-align: left;
    vertical-align: top;
    font-size: 1.1em;
    cursor: pointer;
    transition: background-color 0.2s;

    /* aタグとしてスタイルをリセット */
    text-decoration: none;
    color: inherit;
    display: block; /* aタグをdivと同じブロック要素にする */
    box-sizing: border-box;
}

.day-cell:hover {
    background-color: #e6e6e6;
}
.today {
    border: 3px solid #F44336; /* 今日の日付を強調 */
    font-weight: bold;
    background-color: #fff0f0; /* 今日は薄い赤背景 */
}

.reserve-count {
    display: block;
    margin-top: 5px;
    font-size: 0.8em;
    color: #00796B;
    font-weight: 500;
}
</style>
<div class="zenbu">
<div class="container">

    <div class="sidebar">
        <%-- サイドバーのタイトルに選択日を表示 --%>
        <h2>📅 <%= selectedDateString %>の予約一覧</h2>

        <div class="reservation-list">

            <%-- 予約リストの動的表示 --%>
            <% if (todayReservations != null && !todayReservations.isEmpty()) { %>
                <% for (Reserve reserve : todayReservations) { %>
                    <div class="reservation-list-item">

                        <div class="reservation-time">
                            <%= timeFormat.format(reserve.getVisitTime()) %> (<%= reserve.getNumOfPeople() %>名)
                        </div>

                        <div class="reservation-detail">
                            予約ID: <%= reserve.getReserveIdString() %>
                            <span style="color: #FF9800; font-weight: bold;">
                                [ステータス: <%= reserve.getReserveStatus() == 1 ? "承認待ち" : "その他" %>]
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

            <%-- 前の月ボタン（Action呼び出し） --%>
            <a href="<%= actionPath %>?year=<%= prevYear %>&month=<%= prevMonth %>">
                <button>&lt; 前の月</button>
            </a>

            <%-- 月表示（Actionから取得した値） --%>
            <h2 style="margin: 0; color: #4CAF50;"><%= currentMonthYear %></h2>

            <%-- 次の月ボタン（Action呼び出し） --%>
            <a href="<%= actionPath %>?year=<%= nextYear %>&month=<%= nextMonth %>">
                <button>次の月 &gt;</button>
            </a>

        </div>

        <div class="calendar-grid">
            <%-- 曜日のヘッダー --%>
            <div class="day-header">日</div>
            <div class="day-header">月</div>
            <div class="day-header">火</div>
            <div class="day-header">水</div>
            <div class="day-header">木</div>
            <div class="day-header">金</div>
            <div class="day-header">土</div>

            <%-- ★★★ 日付セルの動的生成 ★★★ --%>
            <%
            // 月初めのセルの位置計算 (1=日, 2=月, ..., 7=土)
            int startColumn = firstDayOfWeek;
            %>

            <%-- 月の初日までの空セルを挿入 --%>
            <%
            for (int j = 1; j < startColumn; j++) {
            %>
                <div class="day-cell" style="background-color: #f0f0f0; cursor: default;"></div>
            <%
            }
            %>

            <% for (int i = 1; i <= daysInMonth; i++) {
                String cellClass = "day-cell";

                // todayクラスの判定
                if (i == today) {
                    cellClass += " today";
                }

                // マップから予約件数を取得
                int count = reservationCounts.getOrDefault(i, 0);
                String reserveCountText = "";
                if (count > 0) {
                    reserveCountText = "予約 " + count + "件";
                }

                // クリック可能なaタグに変更
                String clickUrl = actionPath + "?year=" + currentYear + "&month=" + currentMonth + "&day=" + i;
            %>
                <a class="<%= cellClass %>" href="<%= clickUrl %>">
                    <%= i %>
                    <% if (!reserveCountText.isEmpty()) { %>
                        <span class="reserve-count"><%= reserveCountText %></span>
                    <% } %>
                </a>
            <% } %>
            <%-- ★★★ 日付セルの動的生成 終了 ★★★ --%>

        </div>
    </div>

</div>
</div>

<%@include file="../../footer.html" %>
package tabematch.shop;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Reserve;
import bean.Shop;
import bean.Users;
import dao.ReserveDAO;
import dao.ReserveDAO.ReservationDayStatus;
import dao.ShopDAO;
import tool.Action;

public class ShopManagementAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        String url = "/tabematch/shop/shop-management.jsp";

        // 1. ログインチェックと権限チェック
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"2".equals(user.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗管理者としてログインしてください。");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        // メールアドレスから実際の店舗IDを取得
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopByMail(user.getUserId());

        if (shop == null) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("/error.jsp").forward(req, res);
            return;
        }

        String shopId = shop.getShopId();

        System.out.println("=== ShopManagementAction デバッグ開始 ===");
        System.out.println("実際の店舗ID: " + shopId);

        // 2. カレンダー表示対象の年/月の決定ロジック
        Calendar currentCal = Calendar.getInstance();

        String yearParam = req.getParameter("year");
        String monthParam = req.getParameter("month");
        String dayParam = req.getParameter("day"); // ★追加：日付パラメータ

        if (yearParam != null && monthParam != null) {
            try {
                int year = Integer.parseInt(yearParam);
                int month = Integer.parseInt(monthParam) - 1;
                currentCal.set(Calendar.YEAR, year);
                currentCal.set(Calendar.MONTH, month);
                currentCal.set(Calendar.DAY_OF_MONTH, 1);
            } catch (NumberFormatException e) {
                // パラメータが不正な場合は無視
            }
        }

        SimpleDateFormat headerFormat = new SimpleDateFormat("yyyy年 M月");
        String currentMonthYear = headerFormat.format(currentCal.getTime());

        int displayYear = currentCal.get(Calendar.YEAR);
        int displayMonth = currentCal.get(Calendar.MONTH) + 1;

        System.out.println("表示対象: " + displayYear + "年 " + displayMonth + "月");

        req.setAttribute("currentMonthYear", currentMonthYear);
        req.setAttribute("currentYear", displayYear);
        req.setAttribute("currentMonth", displayMonth);

        // 3. DAOを使い、予約情報を取得
        ReserveDAO reserveDAO = new ReserveDAO();

        try {
            List<Reserve> displayReservations; // 表示する予約リスト
            String selectedDateString; // サイドバーのタイトル

            // ★追加：日付パラメータがあれば、その日の予約を取得
            if (dayParam != null && !dayParam.isEmpty()) {
                try {
                    int selectedDay = Integer.parseInt(dayParam);
                    displayReservations = reserveDAO.getReservationsByDate(
                        shopId, displayYear, displayMonth, selectedDay
                    );
                    selectedDateString = displayYear + "年" + displayMonth + "月" + selectedDay + "日";
                    System.out.println("選択日の予約件数: " + displayReservations.size());
                } catch (NumberFormatException e) {
                    // 日付が不正な場合は今日の予約を表示
                    displayReservations = reserveDAO.getTodayReservations(shopId);
                    selectedDateString = "今日";
                }
            } else {
                // 日付パラメータがない場合は今日の予約を表示
                displayReservations = reserveDAO.getTodayReservations(shopId);
                selectedDateString = "今日";
            }

            req.setAttribute("todayReservations", displayReservations);
            req.setAttribute("selectedDateString", selectedDateString);

            System.out.println("表示予約件数: " + displayReservations.size());

            // カレンダー用：指定月の日付ごとの予約ステータス
            Map<Integer, ReservationDayStatus> reservationStatusMap = reserveDAO.getReservationStatusByMonth(
                shopId,
                displayYear,
                displayMonth
            );

            System.out.println("予約ステータスマップ: " + reservationStatusMap);
            if (reservationStatusMap != null && !reservationStatusMap.isEmpty()) {
                for (Map.Entry<Integer, ReservationDayStatus> entry : reservationStatusMap.entrySet()) {
                    System.out.println("  日付: " + entry.getKey() +
                                     ", 総数: " + entry.getValue().getTotalCount() +
                                     ", 承認待ち: " + entry.getValue().getPendingCount() +
                                     ", 承認済み: " + entry.getValue().getApprovedCount());
                }
            } else {
                System.out.println("  ※マップが空、またはnull");
            }

            req.setAttribute("reservationStatusMap", reservationStatusMap);

        } catch (Exception e) {
            System.err.println("エラー発生: " + e.getMessage());
            e.printStackTrace();

            req.setAttribute("errorMessage", "予約情報の取得中にエラーが発生しました：" + e.getMessage());
            url = "/error.jsp";
        }

        System.out.println("=== ShopManagementAction デバッグ終了 ===");

        // 5. JSPへフォワード
        req.getRequestDispatcher(url).forward(req, res);
    }
}
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

        // ★修正：メールアドレスから実際の店舗IDを取得
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopByMail(user.getUserId());

        if (shop == null) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("/error.jsp").forward(req, res);
            return;
        }

        String shopId = shop.getShopId(); // ★これが実際の店舗ID（SHOP...形式）

        // ★デバッグ：店舗IDを確認
        System.out.println("=== ShopManagementAction デバッグ開始 ===");
        System.out.println("ログインメールアドレス: " + user.getUserId());
        System.out.println("実際の店舗ID: " + shopId);

        // 2. カレンダー表示対象の年/月の決定ロジック
        Calendar currentCal = Calendar.getInstance();

        String yearParam = req.getParameter("year");
        String monthParam = req.getParameter("month");

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

        // ★デバッグ：表示対象の年月を確認
        System.out.println("表示対象: " + displayYear + "年 " + displayMonth + "月");

        req.setAttribute("currentMonthYear", currentMonthYear);
        req.setAttribute("currentYear", displayYear);
        req.setAttribute("currentMonth", displayMonth);

        // 3. DAOを使い、今日の予約一覧とステータス情報を取得
        ReserveDAO reserveDAO = new ReserveDAO();

        try {
            // 今日の予約一覧
            List<Reserve> todayReservations = reserveDAO.getTodayReservations(shopId);
            req.setAttribute("todayReservations", todayReservations);

            // ★デバッグ：今日の予約件数
            System.out.println("今日の予約件数: " + (todayReservations != null ? todayReservations.size() : 0));

            // カレンダー用：指定月の日付ごとの予約ステータス
            Map<Integer, ReservationDayStatus> reservationStatusMap = reserveDAO.getReservationStatusByMonth(
                shopId,
                displayYear,
                displayMonth
            );

            // ★デバッグ：取得したマップの内容を出力
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
            // ★デバッグ：エラー詳細を出力
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
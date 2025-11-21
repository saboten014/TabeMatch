package tabematch.shop;

import java.text.SimpleDateFormat; // ★追加
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Reserve;
import bean.Users;
import dao.ReserveDAO;
import tool.Action;

public class ShopManagementAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        String url = "/tabematch/shop/shop-management.jsp";

        // 1. ログインチェックと権限チェック (省略なし)
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"2".equals(user.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗管理者としてログインしてください。");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }
        String shopId = user.getUserId();


        // ★★★ 2. カレンダー表示対象の年/月の決定ロジック ★★★
        Calendar currentCal = Calendar.getInstance();

        // パラメータから年と月を取得
        String yearParam = req.getParameter("year");
        String monthParam = req.getParameter("month");

        if (yearParam != null && monthParam != null) {
            try {
                int year = Integer.parseInt(yearParam);
                // 月は 0 (1月) から始まるため、ユーザー入力 (1-12) から 1 を引く
                int month = Integer.parseInt(monthParam) - 1;

                // カレンダーインスタンスに設定
                currentCal.set(Calendar.YEAR, year);
                currentCal.set(Calendar.MONTH, month);
                currentCal.set(Calendar.DAY_OF_MONTH, 1); // 日付を1日にリセット
            } catch (NumberFormatException e) {
                // パラメータが不正な場合は無視し、現在の日付を使用する
            }
        }

        // カレンダーヘッダー用の表示文字列を作成
        SimpleDateFormat headerFormat = new SimpleDateFormat("yyyy年 M月");
        String currentMonthYear = headerFormat.format(currentCal.getTime());

        // 決定した年/月の値をJSPに渡す
        req.setAttribute("currentMonthYear", currentMonthYear);
        req.setAttribute("currentYear", currentCal.get(Calendar.YEAR));
        req.setAttribute("currentMonth", currentCal.get(Calendar.MONTH) + 1); // 1-12月の値に戻して渡す


        // 3. DAOを使い、今日の予約一覧を取得 (ロジックは変更なし)
        ReserveDAO reserveDAO = new ReserveDAO();
        List<Reserve> todayReservations;

        try {
            todayReservations = reserveDAO.getTodayReservations(shopId);
            req.setAttribute("todayReservations", todayReservations);

        } catch (Exception e) {
            req.setAttribute("errorMessage", "予約情報の取得中にエラーが発生しました：" + e.getMessage());
            e.printStackTrace();
            url = "/error.jsp";
        }

        // 5. JSPへフォワード
        req.getRequestDispatcher(url).forward(req, res);
    }
}
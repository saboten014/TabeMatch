package tabematch.main;

import java.sql.Date;
import java.sql.Time;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Reserve;
import bean.Shop;
import bean.Users;
import dao.ReserveDAO;
import dao.ShopDAO;
import tool.Action;

public class ReserveExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // 1. セッション・ログインチェック
        HttpSession session = req.getSession(false);
        Users loginUser = session != null ? (Users) session.getAttribute("user") : null;
        if (loginUser == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        // 2. パラメータの取得
        String shopId = req.getParameter("shopId");
        String visitDateParam = req.getParameter("visitDate");
        String visitTimeParam = req.getParameter("visitTime");
        String peopleParam = req.getParameter("numOfPeople");
        // ★追加：電話番号の取得
        String telParam = req.getParameter("reserve_tel");

        // チェックボックスの値を取得 (配列)
        String[] selectedAllergies = req.getParameterValues("allergy");
        String allergyNotes = req.getParameter("allergyNotes");
        String message = req.getParameter("message");

        // 3. バリデーション（電話番号 telParam もチェックに追加）
        if (isBlank(shopId) || isBlank(visitDateParam) || isBlank(visitTimeParam) || isBlank(peopleParam) || isBlank(telParam)) {
            setErrorAndReturn(req, res, shopId, "必要な項目が入力されていません。");
            return;
        }

        int numOfPeople;
        try {
            numOfPeople = Integer.parseInt(peopleParam);
        } catch (NumberFormatException e) {
            setErrorAndReturn(req, res, shopId, "人数は数値で入力してください。");
            return;
        }

        Date visitDate;
        Time visitTime;
        try {
            visitDate = Date.valueOf(visitDateParam);
            visitTime = Time.valueOf(formatTime(visitTimeParam));
        } catch (IllegalArgumentException e) {
            setErrorAndReturn(req, res, shopId, "来店日時の形式が正しくありません。");
            return;
        }

        // 選択されたアレルギーと自由入力を合体させる
        StringBuilder fullAllergyInfo = new StringBuilder();
        if (selectedAllergies != null && selectedAllergies.length > 0) {
            fullAllergyInfo.append("【選択項目】: ");
            fullAllergyInfo.append(String.join(", ", selectedAllergies));
        }
        if (!isBlank(allergyNotes)) {
            if (fullAllergyInfo.length() > 0) fullAllergyInfo.append(" / ");
            fullAllergyInfo.append("【詳細】: ").append(allergyNotes);
        }

        // 4. Reserveオブジェクトの作成とデータセット
        Reserve reserve = new Reserve();
        reserve.setUserId(loginUser.getUserId());
        reserve.setShopId(shopId);
        reserve.setVisitDate(visitDate);
        reserve.setVisitTime(visitTime);
        reserve.setNumOfPeople(numOfPeople);
        reserve.setAllergyNotes(fullAllergyInfo.toString());
        reserve.setMessage(message);
        reserve.setStatus("受付中");
        // ★追加：電話番号をBeanにセット
        reserve.setReserveTel(telParam);

        // 5. データベース登録
        ReserveDAO reserveDao = new ReserveDAO();
        boolean success = reserveDao.createReservation(reserve);
        if (!success) {
            setErrorAndReturn(req, res, shopId, "予約の登録に失敗しました。時間をおいて再度お試しください。");
            return;
        }

        // 6. 完了画面への準備
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopById(shopId);
        reserve.setShopName(shop != null ? shop.getShopName() : "");

        session.setAttribute("completedReserve", reserve);
        session.setAttribute("completedShop", shop);
        res.sendRedirect(req.getContextPath() + "/tabematch/main/reservation-complete.jsp");
    }

    private void setErrorAndReturn(HttpServletRequest req, HttpServletResponse res, String shopId, String message) throws Exception {
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopById(shopId);

        if (shop != null) {
            req.setAttribute("allAllergens", shopDao.getAllAllergens());
            req.setAttribute("shopAllergenNames", shopDao.getShopAllergenNames(shopId));

            req.setAttribute("shop", shop);
            req.setAttribute("errorMessage", message);
            req.getRequestDispatcher("reservation-form.jsp").forward(req, res);
        } else {
            req.setAttribute("errorMessage", message + " 店舗検索画面から再度操作してください。");
            req.getRequestDispatcher("search.jsp").forward(req, res);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String formatTime(String value) {
        return value.length() == 5 ? value + ":00" : value;
    }
}
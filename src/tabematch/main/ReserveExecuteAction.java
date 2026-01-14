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
        HttpSession session = req.getSession(false);
        Users loginUser = session != null ? (Users) session.getAttribute("user") : null;
        if (loginUser == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        String shopId = req.getParameter("shopId");
        String visitDateParam = req.getParameter("visitDate");
        String visitTimeParam = req.getParameter("visitTime");
        String peopleParam = req.getParameter("numOfPeople");
        String allergyNotes = req.getParameter("allergyNotes");
        String message = req.getParameter("message");

        if (isBlank(shopId) || isBlank(visitDateParam) || isBlank(visitTimeParam) || isBlank(peopleParam)) {
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
        if (numOfPeople <= 0) {
            setErrorAndReturn(req, res, shopId, "人数は1以上で入力してください。");
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

        Reserve reserve = new Reserve();
        reserve.setUserId(loginUser.getUserId());
        reserve.setShopId(shopId);
        reserve.setVisitDate(visitDate);
        reserve.setVisitTime(visitTime);
        reserve.setNumOfPeople(numOfPeople);
        reserve.setAllergyNotes(allergyNotes);
        reserve.setMessage(message);
        reserve.setStatus("受付中");

        ReserveDAO reserveDao = new ReserveDAO();
        boolean success = reserveDao.createReservation(reserve);
        if (!success) {
            setErrorAndReturn(req, res, shopId, "予約の登録に失敗しました。時間をおいて再度お試しください。");
            return;
        }

        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopById(shopId);
        reserve.setShopName(shop != null ? shop.getShopName() : "");


        session.setAttribute("completedReserve", reserve);
        session.setAttribute("completedShop", shop);
        res.sendRedirect(req.getContextPath() + "/tabematch/main/reservation-complete.jsp");
    }

    private void setErrorAndReturn(HttpServletRequest req, HttpServletResponse res, String shopId, String message) throws Exception {
        Shop shop = null;
        if (shopId != null && !shopId.trim().isEmpty()) {
            ShopDAO shopDao = new ShopDAO();
            shop = shopDao.getShopById(shopId);
        }
        req.setAttribute("errorMessage", message);
        if (shop != null) {
            req.setAttribute("shop", shop);
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
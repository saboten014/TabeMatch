package tabematch.shop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.ReserveDAO;
import dao.ShopDAO;
import tool.Action;

public class ShopReservationUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");

        // 店舗アカウントでログインしているか確認
        if (loginUser == null || !"2".equals(loginUser.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗アカウントでログインしてください。");
            req.getRequestDispatcher("../login.jsp").forward(req, res);
            return;
        }

        // リクエストパラメータを取得
        String reserveId = req.getParameter("reserveId");
        String statusParam = req.getParameter("status");

        // バリデーション
        if (reserveId == null || reserveId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "予約IDが指定されていません。");
            res.sendRedirect("ShopReservationList.action");
            return;
        }

        if (statusParam == null || statusParam.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ステータスが指定されていません。");
            res.sendRedirect("ShopReservationList.action");
            return;
        }

        int status;
        try {
            status = Integer.parseInt(statusParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "不正なステータスが指定されました。");
            res.sendRedirect("ShopReservationList.action");
            return;
        }

        // ステータスは2（承認）または3（拒否）のみ許可
        if (status != 2 && status != 3) {
            session.setAttribute("errorMessage", "不正なステータスが指定されました。");
            res.sendRedirect("ShopReservationList.action");
            return;
        }

        // 店舗情報を取得して権限確認
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopByMail(loginUser.getUserId());

        if (shop == null) {
            session.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            res.sendRedirect("ShopReservationList.action");
            return;
        }

        // 予約ステータスを更新
        ReserveDAO reserveDao = new ReserveDAO();
        boolean success = reserveDao.updateReserveStatus(reserveId, status);

        if (success) {
            String message = status == 2 ? "予約を承認しました。" : "予約を拒否しました。";
            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", "予約ステータスの更新に失敗しました。");
        }

        // 予約一覧画面にリダイレクト
        res.sendRedirect("ShopReservationList.action");
    }
}
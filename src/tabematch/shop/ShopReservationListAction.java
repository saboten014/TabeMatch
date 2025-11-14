package tabematch.shop;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Reserve;
import bean.Shop;
import bean.Users;
import dao.ReserveDAO;
import dao.ShopDAO;
import tool.Action;

public class ShopReservationListAction extends Action {

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

        // ログイン中の店舗情報を取得
        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopByMail(loginUser.getUserId());

        if (shop == null) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("../error.jsp").forward(req, res);
            return;
        }

        // 店舗に対する予約一覧を取得
        ReserveDAO reserveDao = new ReserveDAO();
        List<Reserve> reservationList = reserveDao.findByShop(shop.getShopId());

        // リクエストスコープに設定
        req.setAttribute("reservationList", reservationList);
        req.setAttribute("shop", shop);

        // JSPへフォワード
        req.getRequestDispatcher("shop-reservation-list.jsp").forward(req, res);
    }
}
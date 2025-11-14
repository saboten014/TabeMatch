package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ReserveFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        HttpSession session = req.getSession(false);
        Users loginUser = session != null ? (Users) session.getAttribute("user") : null;
        if (loginUser == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        String shopId = req.getParameter("shopId");
        if (shopId == null || shopId.trim().isEmpty()) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("search.jsp").forward(req, res);
            return;
        }

        ShopDAO shopDao = new ShopDAO();
        Shop shop = shopDao.getShopById(shopId);
        if (shop == null) {
            req.setAttribute("errorMessage", "指定された店舗が見つかりませんでした。");
            req.getRequestDispatcher("search.jsp").forward(req, res);
            return;
        }

        req.setAttribute("shop", shop);
        req.getRequestDispatcher("reservation-form.jsp").forward(req, res);
    }
}
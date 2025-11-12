package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ShopProfileAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");

        if (loginUser == null || !"2".equals(loginUser.getUsersTypeId())) {
            req.setAttribute("errorMessage", "店舗アカウントでログインしてください。");
            req.getRequestDispatcher("../login.jsp").forward(req, res);
            return;
        }

        String mode = req.getParameter("mode");
        ShopDAO dao = new ShopDAO();

        if (mode == null) {
            // 店舗情報取得
            Shop shop = dao.getShopByMail(loginUser.getUserId());
            req.setAttribute("shop", shop);
            req.getRequestDispatcher("shop-profile.jsp").forward(req, res);
        } else if (mode.equals("update")) {
            String shopName = req.getParameter("shopName");
            String address = req.getParameter("shopAddress");
            String tel = req.getParameter("shopTel");
            String url = req.getParameter("shopUrl");
            String allergy = req.getParameter("shopAllergy");

            Shop shop = dao.getShopByMail(loginUser.getUserId());
            shop.setShopName(shopName);
            shop.setShopAddress(address);
            shop.setShopTel(tel);
            shop.setShopUrl(url);
            shop.setShopAllergy(allergy);

            boolean result = dao.updateShop(shop);

            if (result) {
                req.setAttribute("successMessage", "店舗情報を更新しました。");
                req.getRequestDispatcher("profile-complete.jsp").forward(req, res);
            } else {
                req.setAttribute("errorMessage", "更新に失敗しました。");
                req.getRequestDispatcher("shop-profile.jsp").forward(req, res);
            }
        }
    }
}

package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import dao.ShopDAO;
import tool.Action;

public class AdminShopDeleteConfirmAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String shopId = req.getParameter("shopId");

        ShopDAO dao = new ShopDAO();
        Shop shop = dao.getShopDetail(shopId);

        req.setAttribute("shop", shop);

        req.getRequestDispatcher("/tabematch/admin/admin-shop-delete-confirm.jsp").forward(req, res);
    }
}
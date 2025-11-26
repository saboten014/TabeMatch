package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ShopDAO;
import tool.Action;

public class AdminShopPrivateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String shopId = req.getParameter("shopId");

        ShopDAO dao = new ShopDAO();
        dao.updateShopPublic(shopId, false);

        res.sendRedirect("AdminShopDetail.action?shopId=" + shopId);
    }
}
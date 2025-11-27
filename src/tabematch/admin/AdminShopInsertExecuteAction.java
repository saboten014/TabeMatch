package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import dao.ShopDAO;
import tool.Action;

public class AdminShopInsertExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        req.setCharacterEncoding("UTF-8");

        String shopId = req.getParameter("shopId");
        String password = req.getParameter("password");
        String shopName = req.getParameter("shopName");
        String shopAddress = req.getParameter("shopAddress");
        String shopMail = req.getParameter("shopMail");
        String shopTel = req.getParameter("shopTel");
        String shopGenre = req.getParameter("shopGenre");
        String shopReserve = req.getParameter("shopReserve");

        // 入力値からShopオブジェクト作成
        Shop shop = new Shop();
        shop.setShopId(shopId);
        shop.setPassword(password);
        shop.setShopName(shopName);
        shop.setShopAddress(shopAddress);
        shop.setShopMail(shopMail);
        shop.setShopTel(shopTel);
        shop.setShopGenre(shopGenre);
        shop.setShopReserve(shopReserve);

        // is_public = TRUE（管理者登録は無条件で公開）
        shop.setIsPublic(true);

        // DAO 呼び出し
        ShopDAO dao = new ShopDAO();
        boolean result = dao.insertShopForAdmin(shop);

        if (result) {
            req.setAttribute("successMessage", "店舗を登録しました。");
        } else {
            req.setAttribute("errorMessage", "店舗の登録に失敗しました。");
        }

        req.getRequestDispatcher("/tabematch/admin/admin-shop-insert-complete.jsp").forward(req, res);
    }
}

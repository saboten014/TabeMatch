package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import dao.ShopDAO;
import tool.Action;

public class AdminShopListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        ShopDAO dao = new ShopDAO();

        // ★フィルタ（ア・カ・A など）
        String kana = req.getParameter("kana");
        if (kana != null && kana.equals("ALL")) {
            kana = null;
        }

        // ★ページ番号
        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Integer.parseInt(p); }
            catch (NumberFormatException e) { page = 1; }
        }

        int limit = 20;
        int offset = (page - 1) * limit;

        // ★総件数
        int total = dao.getShopCount(kana);
        int maxPage = (int) Math.ceil((double) total / limit);

        // ★一覧
        List<Shop> list = dao.getShopList(kana, offset, limit);

        req.setAttribute("shopList", list);
        req.setAttribute("page", page);
        req.setAttribute("maxPage", maxPage);
        req.setAttribute("kana", kana);

        req.getRequestDispatcher("/tabematch/admin/admin-shop-list.jsp").forward(req, res);
    }
}
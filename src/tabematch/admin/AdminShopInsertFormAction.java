package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Allergen;
import dao.ShopDAO;
import tool.Action;

public class AdminShopInsertFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        // ★アレルゲン一覧を取得
        ShopDAO dao = new ShopDAO();
        List<Allergen> allergenList = dao.getAllAllergens();

        req.setAttribute("allergenList", allergenList);

        req.getRequestDispatcher("/tabematch/admin/admin-shop-insert-form.jsp").forward(req, res);
    }

}
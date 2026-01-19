package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Allergen;
import bean.Shop;
import bean.Users;
import dao.ShopDAO;
import tool.Action;

public class ReserveFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {
        // 1. セッション・ログインチェック
        HttpSession session = req.getSession(false);
        Users loginUser = session != null ? (Users) session.getAttribute("user") : null;
        if (loginUser == null) {
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        // 2. 店舗IDの取得とバリデーション
        String shopId = req.getParameter("shopId");
        if (shopId == null || shopId.trim().isEmpty()) {
            req.setAttribute("errorMessage", "店舗情報が取得できませんでした。");
            req.getRequestDispatcher("search.jsp").forward(req, res);
            return;
        }

        ShopDAO shopDao = new ShopDAO();

        // 3. 必要な情報の取得
        Shop shop = shopDao.getShopById(shopId);
        if (shop == null) {
            req.setAttribute("errorMessage", "指定された店舗が見つかりませんでした。");
            req.getRequestDispatcher("search.jsp").forward(req, res);
            return;
        }

        // --- 修正ポイント ---
        // アレルゲンマスター全件取得 (A01:卵, A02:乳...)
        List<Allergen> allAllergens = shopDao.getAllAllergens();

        // 店舗が対応しているアレルゲン「名」のリストを取得
        // メソッド名を getShopAllergenNames に変える（※ShopDAOも修正してください）
        List<String> shopAllergenNames = shopDao.getShopAllergenNames(shopId);
        // ------------------

        // 4. リクエスト属性にセットしてフォワード
        req.setAttribute("shop", shop);
        req.setAttribute("allAllergens", allAllergens);
        // JSP側でも shopAllergenNames を使うように合わせる
        req.setAttribute("shopAllergenNames", shopAllergenNames);

        req.getRequestDispatcher("reservation-form.jsp").forward(req, res);
    }
}
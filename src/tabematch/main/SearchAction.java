package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import dao.ShopDAO;
import tool.Action;

public class SearchAction extends Action {

	@Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        String url = "search-result.jsp"; // 基本は結果画面へ
        ShopDAO shopDao = new ShopDAO();
        List<Shop> shopList = null;

        // リクエストパラメータの取得
        String searchArea = req.getParameter("searchArea");
        String shopName = req.getParameter("shopName");
        String genre = req.getParameter("genre");
        String priceRange = req.getParameter("priceRange");
        String businessHours = req.getParameter("businessHours");
        String[] allergyInfo = req.getParameterValues("allergyInfo");

        // --- 判定ロジックの修正版 ---

        // 1. 【全件検索】すべての項目が未入力、かつアレルギーも未選択の場合
        if (isEmpty(searchArea) && isEmpty(shopName) && isEmpty(genre) &&
            isEmpty(priceRange) && isEmpty(businessHours) &&
            (allergyInfo == null || allergyInfo.length == 0)) {

            shopList = shopDao.getAllShops();
        }
        // 2. 【アレルギーなし検索】他の項目は何かしら入っているが、アレルギーだけ未選択の場合
        else if (allergyInfo == null || allergyInfo.length == 0) {

            shopList = shopDao.searchFlexibleWithoutAllergy(searchArea, shopName, genre, priceRange, businessHours);
        }
        // 3. 【通常検索】アレルギー情報も含めて検索
        else {

            shopList = shopDao.searchFlexible(searchArea, shopName, genre, priceRange, businessHours, allergyInfo);
        }

        // 結果をセットしてフォワード
        req.setAttribute("shopList", shopList);
        req.getRequestDispatcher(url).forward(req, res);
    }

    /**
     * 単一の文字列が空かどうかをチェックする（修正版）
     */
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
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
		// ローカル変数の宣言 1
		String url = "";
		ShopDAO shopDao = new ShopDAO();
		List<Shop> shopList = null;

		// リクエストパラメータ―の取得 2
		String searchArea = req.getParameter("searchArea");
		String shopName = req.getParameter("shopName");
		String genre = req.getParameter("genre");
		String priceRange = req.getParameter("priceRange");
		String businessHours = req.getParameter("businessHours");
		String[] allergyInfo = req.getParameterValues("allergyInfo");

		// DBからデータ取得 3
		// ビジネスロジック 4

		// 検索エリアが入力されなかった場合（他入力済み）
		if (isEmpty(searchArea) && !isEmpty(shopName, genre, priceRange, businessHours) && allergyInfo != null && allergyInfo.length > 0) {
			// 代替フロー①へ
			req.setAttribute("errorMessage", "検索エリアを入力してください。");
			url = "search.jsp";
		}
		// アレルギー情報が選択がすべて外されている場合
		else if ((allergyInfo == null || allergyInfo.length == 0) && !isEmpty(searchArea, shopName, genre, priceRange, businessHours)) {
			// 代替フロー⑦へ
			req.setAttribute("warningMessage", "アレルギー情報が設定されていません。");
			shopList = shopDao.searchWithoutAllergy(searchArea, shopName, genre, priceRange, businessHours);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 何も入力されなかった場合（アレルギー情報も未選択）
		else if (isEmpty(searchArea, shopName, genre, priceRange, businessHours) && (allergyInfo == null || allergyInfo.length == 0)) {
			// 代替フロー⑥へ
			shopList = shopDao.getAllShops();
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 店名が入力されなかった場合（他入力済み）
		else if (isEmpty(shopName) && !isEmpty(searchArea, genre, priceRange, businessHours) && allergyInfo != null && allergyInfo.length > 0) {
			// 代替フロー②へ
			shopList = shopDao.searchByArea(searchArea, genre, priceRange, businessHours, allergyInfo);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// ジャンルが入力されなかった場合（他入力済み）
		else if (isEmpty(genre) && !isEmpty(searchArea, shopName, priceRange, businessHours) && allergyInfo != null && allergyInfo.length > 0) {
			// 代替フロー③へ
			shopList = shopDao.searchByAreaAndName(searchArea, shopName, priceRange, businessHours, allergyInfo);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 価格帯が入力されなかった場合（他入力済み）
		else if (isEmpty(priceRange) && !isEmpty(searchArea, shopName, genre, businessHours) && allergyInfo != null && allergyInfo.length > 0) {
			// 代替フロー④へ
			shopList = shopDao.searchByAreaNameGenre(searchArea, shopName, genre, businessHours, allergyInfo);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 営業時間が入力されなかった場合（他入力済み）
		else if (isEmpty(businessHours) && !isEmpty(searchArea, shopName, genre, priceRange) && allergyInfo != null && allergyInfo.length > 0) {
			// 代替フロー⑤へ
			shopList = shopDao.searchByAreaNameGenrePrice(searchArea, shopName, genre, priceRange, allergyInfo);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// すべて入力された場合（基本フロー）
		else if (!isEmpty(searchArea, shopName, genre, priceRange, businessHours) && allergyInfo != null && allergyInfo.length > 0) {
			// 基本フロー
			shopList = shopDao.searchAll(searchArea, shopName, genre, priceRange, businessHours, allergyInfo);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// その他の組み合わせ（部分的に入力されている場合）
		else {
			// 入力されている項目で検索
			if (allergyInfo != null && allergyInfo.length > 0) {
				shopList = shopDao.searchFlexible(searchArea, shopName, genre, priceRange, businessHours, allergyInfo);
			} else {
				req.setAttribute("warningMessage", "アレルギー情報が設定されていません。");
				shopList = shopDao.searchFlexibleWithoutAllergy(searchArea, shopName, genre, priceRange, businessHours);
			}
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}

		// DBへデータ保存 5
		// なし

		// レスポンス値をセット 6
		// 上記で設定済み

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}

	// 文字列が空かどうかをチェックするヘルパーメソッド
	private boolean isEmpty(String... values) {
		for (String value : values) {
			if (value != null && !value.trim().isEmpty()) {
				return false;
			}
		}
		return true;
	}
}
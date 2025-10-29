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

		// DBからデータ取得 3
		// ビジネスロジック 4

		// 検索エリアが入力されなかった場合（他入力済み）
		if (isEmpty(searchArea) && !isEmpty(shopName, genre, priceRange, businessHours)) {
			// 代替フロー①へ
			req.setAttribute("errorMessage", "検索エリアを入力してください。");
			url = "search.jsp";
		}
		// 店名が入力されなかった場合（他入力済み）
		else if (isEmpty(shopName) && !isEmpty(searchArea, genre, priceRange, businessHours)) {
			// 代替フロー②へ
			shopList = shopDao.searchByArea(searchArea, genre, priceRange, businessHours);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// ジャンルが入力されなかった場合（他入力済み）
		else if (isEmpty(genre) && !isEmpty(searchArea, shopName, priceRange, businessHours)) {
			// 代替フロー③へ
			shopList = shopDao.searchByAreaAndName(searchArea, shopName, priceRange, businessHours);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 価格帯が入力されなかった場合（他入力済み）
		else if (isEmpty(priceRange) && !isEmpty(searchArea, shopName, genre, businessHours)) {
			// 代替フロー④へ
			shopList = shopDao.searchByAreaNameGenre(searchArea, shopName, genre, businessHours);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 営業時間が入力されなかった場合（他入力済み）
		else if (isEmpty(businessHours) && !isEmpty(searchArea, shopName, genre, priceRange)) {
			// 代替フロー⑤へ
			shopList = shopDao.searchByAreaNameGenrePrice(searchArea, shopName, genre, priceRange);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// 何も入力されなかった場合
		else if (isEmpty(searchArea, shopName, genre, priceRange, businessHours)) {
			// 代替フロー⑥へ
			req.setAttribute("errorMessage", "検索条件を入力してください。");
			url = "search.jsp";
		}
		// すべて入力された場合（基本フロー）
		else if (!isEmpty(searchArea, shopName, genre, priceRange, businessHours)) {
			// 基本フロー
			shopList = shopDao.searchAll(searchArea, shopName, genre, priceRange, businessHours);
			req.setAttribute("shopList", shopList);
			url = "search-result.jsp";
		}
		// バリデーションエラー（一部項目が未入力の複雑なパターン）
		else {
			// 代替フロー⑦へ
			req.setAttribute("errorMessage", "入力項目に不足があります。");
			url = "search.jsp";
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
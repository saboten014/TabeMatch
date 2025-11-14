package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.FavoriteDAO;
import dao.ShopDAO;
import tool.Action;

public class ShopDetailAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {

		HttpSession session = req.getSession();

		// ローカル変数の宣言 1
		String url = "";
		ShopDAO shopDao = new ShopDAO();
		Shop shop = null;

		// リクエストパラメータ―の取得 2
		String shopIdStr = req.getParameter("shopId");


		// IDが指定されていない、または不正な場合
		if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
			req.setAttribute("errorMessage", "店舗IDが指定されていません。");
			req.getRequestDispatcher("../../error.jsp").forward(req, res);
			return;
		}

		// オプション: IDのフォーマットチェック
		if (!shopIdStr.startsWith("SHOP")) {
			// 例: IDが "SHOP" で始まらない場合は不正なIDとして扱う
			req.setAttribute("errorMessage", "不正な店舗IDが指定されました。");
			req.getRequestDispatcher("../../error.jsp").forward(req, res);
			return;
		}


		// DBからデータ取得 3
		// ShopDAOのgetShopById(String)メソッドを呼び出し
		shop = shopDao.getShopById(shopIdStr);

		// ビジネスロジック 4
		if (shop != null) {
			// ユーザーは店舗の詳細情報を確認する
			req.setAttribute("shop", shop);


			Users loginUser = (Users) session.getAttribute("user");

			if (loginUser != null) {
				FavoriteDAO favDao = new FavoriteDAO();

				// ユーザーID（メールアドレス）を String のまま取得・保持する
				String userId = loginUser.getUserId();

				// 修正後のDAOメソッド（checkFavorite(String userId, String shopId)）に合わせて呼び出す
				boolean isFavorite = favDao.checkFavorite(userId, shopIdStr);

				// JSPで利用するため結果をセット
				req.setAttribute("isFavorite", isFavorite);
			}

			url = "shop-detail.jsp";
		} else {
			// 店舗が見つからない場合
			req.setAttribute("errorMessage", "店舗情報が見つかりませんでした。");
			url = "../../error.jsp";
		}

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
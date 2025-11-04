package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Shop;
import dao.ShopDAO;
import tool.Action;

public class ShopDetailAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		ShopDAO shopDao = new ShopDAO();
		Shop shop = null;

		// リクエストパラメータ―の取得 2
		String shopId = req.getParameter("shopId");

		// DBからデータ取得 3
		// ビジネスロジック 4

		// ユーザーは閲覧したい店舗を選択する
		if (shopId != null && !shopId.trim().isEmpty()) {
			// システムは選択された店舗の詳細情報を表示する
			shop = shopDao.getShopById(shopId);

			if (shop != null) {
				// ユーザーは店舗の詳細情報を確認する
				req.setAttribute("shop", shop);
				url = "shop-detail.jsp";
			} else {
				// 店舗が見つからない場合
				req.setAttribute("errorMessage", "店舗情報が見つかりませんでした。");
				url = "error.jsp";
			}
		} else {
			// shopIdが指定されていない場合
			req.setAttribute("errorMessage", "店舗IDが指定されていません。");
			url = "error.jsp";
		}

		// DBへデータ保存 5
		// なし

		// レスポンス値をセット 6
		// 上記で設定済み

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
package tabematch.main;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Shop;
import bean.Users;
import dao.FavoriteDAO;
import tool.Action;

public class FavoriteListAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {

		HttpSession session = req.getSession();
		Users loginUser = (Users) session.getAttribute("user");

		// エラーメッセージ用
		String errorMessage = null;

		// 1. ログイン確認
		if (loginUser == null) {
			errorMessage = "お気に入り一覧を表示するにはログインが必要です。";
			req.setAttribute("errorMessage", errorMessage);
			req.getRequestDispatcher("login.jsp").forward(req, res);
			return;
		}

		// 2. ユーザーIDの取得 (メールアドレス)
		String userId = loginUser.getUserId();

		// 3. DAOの準備
		FavoriteDAO favDao = new FavoriteDAO();

		List<Shop> favoriteShopList = null; // リストをnullで初期化

		try {

			favoriteShopList = favDao.getFavoriteShops(userId);

			// 5. 結果をリクエストスコープにセット
			req.setAttribute("favoriteShopList", favoriteShopList);

			System.out.println("★情報取ってこれてるか確認用★");
			System.out.println(favoriteShopList);

			// 6. JSPへフォワード
			req.getRequestDispatcher("favorite-list.jsp").forward(req, res);

		} catch (Exception e) {
			// DBエラーやその他の例外処理
			errorMessage = "お気に入り一覧の取得中にエラーが発生しました：" + e.getMessage();
			req.setAttribute("errorMessage", errorMessage);
			req.getRequestDispatcher("/error.jsp").forward(req, res);
		}
	}
}
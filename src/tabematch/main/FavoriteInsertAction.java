package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.FavoriteDAO;
import tool.Action;

public class FavoriteInsertAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {

		HttpSession session = req.getSession();
		Users loginUser = (Users) session.getAttribute("user");
		String shopIdStr = req.getParameter("shopId");
		// エラーメッセージ用
		String errorMessage = null;

		// 1. ログイン確認
		if (loginUser == null) {
			errorMessage = "お気に入り機能を利用するにはログインが必要です。";
			req.setAttribute("errorMessage", errorMessage);
			req.getRequestDispatcher("login.jsp").forward(req, res);
			return;
		}

		// 2. 店舗IDの検証
		if (shopIdStr == null || shopIdStr.trim().isEmpty()) {
			errorMessage = "お気に入り登録対象の店舗IDが指定されていません。";
			req.setAttribute("errorMessage", errorMessage);
			req.getRequestDispatcher("error.jsp").forward(req, res);
			return;
		}

		// 3. ユーザーIDの取得と変換
		// ★修正箇所: ユーザーID（メールアドレス）を String のまま取得・保持する
		String userId = loginUser.getUserId();

		// 4. 登録/削除ロジックの実行
		FavoriteDAO favDao = new FavoriteDAO();

		// 修正後のDAOメソッド (checkFavorite(String, String)) に合わせて呼び出す
		boolean isFavorite = favDao.checkFavorite(userId, shopIdStr);
		boolean success = false;

		if (isFavorite) {
			// 修正後のDAOメソッド (deleteFavorite(String, String)) に合わせて呼び出す
			success = favDao.deleteFavorite(userId, shopIdStr);
			if (success) {
				session.setAttribute("successMessage", "お気に入りから削除しました。");
			} else {
				session.setAttribute("errorMessage", "お気に入りの削除に失敗しました。");
			}
		} else {
			// 修正後のDAOメソッド (insertFavorite(String, String)) に合わせて呼び出す
			success = favDao.insertFavorite(userId, shopIdStr);
			if (success) {
				session.setAttribute("successMessage", "お気に入り登録しました。");
			} else {
				session.setAttribute("errorMessage", "お気に入りの登録に失敗しました。");
			}
		}

		// 5. 店舗詳細ページにリダイレクト
		res.sendRedirect("ShopDetail.action?shopId=" + shopIdStr);
	}
}
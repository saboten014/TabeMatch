package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class LoginExecuteAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		HttpSession session = req.getSession();
		UserDAO userDao = new UserDAO();

		// リクエストパラメータ―の取得 2
		String userId = req.getParameter("login");
		String password = req.getParameter("password");

		// DBからデータ取得 3
		// ビジネスロジック 4

		if (userId == null || userId.trim().isEmpty() ||
			password == null || password.trim().isEmpty()) {
			// 入力がない場合
			req.setAttribute("errorMessage", "ユーザーIDとパスワードを入力してください。");
			url = "login.jsp";
		} else {
			// ログイン認証
			Users user = userDao.login(userId, password);

			if (user != null) {
				// ログイン成功
				session.setAttribute("user", user);

				// ユーザー区分によって遷移先を変更
				String usersTypeId = user.getUsersTypeId();

				if ("1".equals(usersTypeId)) {
					// 一般ユーザー → トップページ
					url = "main/top.jsp";
				} else if ("2".equals(usersTypeId)) {
					// 店舗ユーザー → 店舗情報管理画面
					url = "shop/shop-management.jsp";
				} else if ("3".equals(usersTypeId)) {
					// 管理ユーザー → 管理画面トップページ
					url = "admin/admin-top.jsp";
				} else {
					// 想定外の区分ID
					url = "main/top.jsp";
				}
			} else {
				// ログイン失敗
				req.setAttribute("errorMessage", "ユーザーIDまたはパスワードが間違っています。");
				url = "login.jsp";
			}
		}

		// DBへデータ保存 5
		// なし

		// レスポンス値をセット 6
		// 上記で設定済み

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class RegisterExecuteAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		UserDAO userDao = new UserDAO();

		// リクエストパラメータ―の取得 2
		String userId = req.getParameter("userId");
		String password = req.getParameter("password");
		String passwordConfirm = req.getParameter("passwordConfirm");
		String userName = req.getParameter("userName");
		String allergenId = req.getParameter("allergenId");
		String usersTypeId = req.getParameter("usersTypeId");

		// DBからデータ取得 3
		// ビジネスロジック 4

		// 入力チェック
		if (userId == null || userId.trim().isEmpty() ||
			password == null || password.trim().isEmpty() ||
			passwordConfirm == null || passwordConfirm.trim().isEmpty() ||
			userName == null || userName.trim().isEmpty() ||
			allergenId == null || allergenId.trim().isEmpty() ||
			usersTypeId == null || usersTypeId.trim().isEmpty()) {
			// 必須項目が入力されていない
			req.setAttribute("errorMessage", "すべての項目を入力してください。");
			url = "register.jsp";
		}
		// パスワード確認
		else if (!password.equals(passwordConfirm)) {
			req.setAttribute("errorMessage", "パスワードが一致しません。");
			url = "register.jsp";
		}
		// ユーザーID重複チェック
		else if (userDao.getUserById(userId) != null) {
			req.setAttribute("errorMessage", "このユーザーIDは既に使用されています。");
			url = "register.jsp";
		}
		// ユーザーID長さチェック（VARCHAR(20)）
		else if (userId.length() > 20) {
			req.setAttribute("errorMessage", "ユーザーIDは20文字以内で入力してください。");
			url = "register.jsp";
		}
		// パスワード長さチェック（VARCHAR(20)）
		else if (password.length() > 20) {
			req.setAttribute("errorMessage", "パスワードは20文字以内で入力してください。");
			url = "register.jsp";
		}
		// ユーザー名長さチェック（VARCHAR(10)）
		else if (userName.length() > 10) {
			req.setAttribute("errorMessage", "ユーザー名は10文字以内で入力してください。");
			url = "register.jsp";
		}
		else {
			// ユーザー登録処理
			Users user = new Users();
			user.setUserId(userId);
			user.setPassword(password);
			user.setUserName(userName);
			user.setAllergenId(allergenId);
			user.setUsersTypeId(usersTypeId);

			// DBへデータ保存 5
			boolean result = userDao.registerUser(user);

			if (result) {
				// 登録成功
				req.setAttribute("successMessage", "ユーザー登録が完了しました。ログインしてください。");
				url = "login.jsp";
			} else {
				// 登録失敗
				req.setAttribute("errorMessage", "ユーザー登録に失敗しました。もう一度お試しください。");
				url = "register.jsp";
			}
		}

		// レスポンス値をセット 6
		// 上記で設定済み

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
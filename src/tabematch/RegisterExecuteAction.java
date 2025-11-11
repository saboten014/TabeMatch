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
		String[] allergenIds = req.getParameterValues("allergenIds"); // 複数選択対応
		String usersTypeId = req.getParameter("usersTypeId");

		// DBからデータ取得 3
		// ビジネスロジック 4

		// 入力チェック
		if (userId == null || userId.trim().isEmpty() ||
			password == null || password.trim().isEmpty() ||
			passwordConfirm == null || passwordConfirm.trim().isEmpty() ||
			userName == null || userName.trim().isEmpty() ||
			allergenIds == null || allergenIds.length == 0) {
			// 必須項目が入力されていない
			req.setAttribute("errorMessage", "すべての項目を入力してください。アレルギー情報は少なくとも1つ選択してください。");
			url = "register.jsp";
		}
		// メールアドレス形式チェック
		else if (!userId.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
			req.setAttribute("errorMessage", "正しいメールアドレス形式で入力してください。");
			url = "register.jsp";
		}
		// パスワード確認
		else if (!password.equals(passwordConfirm)) {
			req.setAttribute("errorMessage", "パスワードが一致しません。");
			url = "register.jsp";
		}
		// ユーザーID重複チェック
		else if (userDao.getUserById(userId) != null) {
			req.setAttribute("errorMessage", "このメールアドレスは既に使用されています。");
			url = "register.jsp";
		}
		// ユーザーID長さチェック（VARCHAR(50)）
		else if (userId.length() > 50) {
			req.setAttribute("errorMessage", "メールアドレスは50文字以内で入力してください。");
			url = "register.jsp";
		}
		// パスワード長さチェック（VARCHAR(225)）
		else if (password.length() > 225) {
			req.setAttribute("errorMessage", "パスワードは225文字以内で入力してください。");
			url = "register.jsp";
		}
		// ユーザー名長さチェック（VARCHAR(50)）
		else if (userName.length() > 50) {
			req.setAttribute("errorMessage", "ユーザー名は50文字以内で入力してください。");
			url = "register.jsp";
		}
		// ユーザー区分が一般ユーザー（1）でない場合は強制的に1にする
		else if (usersTypeId == null || !usersTypeId.equals("1")) {
			usersTypeId = "1";
		}
		else {
			// 複数のアレルゲンIDをカンマ区切りで結合
			String allergenIdString = String.join(",", allergenIds);

			// ユーザー登録処理
			Users user = new Users();
			user.setUserId(userId);
			user.setPassword(password);
			user.setUserName(userName);
			user.setAllergenId(allergenIdString); // カンマ区切りで保存
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
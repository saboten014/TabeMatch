package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Request;
import bean.Users;
import dao.RequestDAO;
import tool.Action;

public class AdminRequestListAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		HttpSession session = req.getSession();
		RequestDAO requestDao = new RequestDAO();

		// リクエストパラメータ―の取得 2
		// なし

		// DBからデータ取得 3
		// ログインチェック
		Users user = (Users)session.getAttribute("user");
		if (user == null || !"3".equals(user.getUsersTypeId())) {
			// 管理者でない場合はログイン画面へ
			req.setAttribute("errorMessage", "管理者権限が必要です。");
			url = "../login.jsp";
		} else {
			// 未承認リクエスト一覧を取得
			List<Request> pendingRequests = requestDao.getPendingRequests();

			// ビジネスロジック 4
			// なし

			// DBへデータ保存 5
			// なし

			// レスポンス値をセット 6
			req.setAttribute("pendingRequests", pendingRequests);
			url = "admin-request-list.jsp";
		}

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Request;
import bean.Users;
import dao.RequestDAO;
import tool.Action;
import util.EmailSender;

public class AdminRequestRejectAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		HttpSession session = req.getSession();
		RequestDAO requestDao = new RequestDAO();

		// リクエストパラメータ―の取得 2
		String requestId = req.getParameter("requestId");
		String reason = req.getParameter("reason");

		// DBからデータ取得 3
		// ログインチェック
		Users admin = (Users)session.getAttribute("user");
		if (admin == null || !"3".equals(admin.getUsersTypeId())) {
			// 管理者でない場合
			req.setAttribute("errorMessage", "管理者権限が必要です。");
			url = "../login.jsp";
		} else if (requestId == null || requestId.trim().isEmpty()) {
			// リクエストIDが指定されていない
			req.setAttribute("errorMessage", "リクエストIDが指定されていません。");
			url = "AdminRequestList.action";
		} else if (reason == null || reason.trim().isEmpty()) {
			// 却下理由が入力されていない
			req.setAttribute("errorMessage", "却下理由を入力してください。");
			url = "AdminRequestList.action";
		} else {
			// リクエスト情報取得
			Request request = requestDao.getRequestById(requestId);

			if (request == null) {
				req.setAttribute("errorMessage", "リクエストが見つかりませんでした。");
				url = "AdminRequestList.action";
			} else if (request.getCertification() != 1) {
				req.setAttribute("errorMessage", "このリクエストは既に処理済みです。");
				url = "AdminRequestList.action";
			} else {
				// ビジネスロジック 4

				// 1. リクエストを却下済みに更新
				requestDao.updateCertification(requestId, 3); // 3=却下

				// DBへデータ保存 5
				// 上記で完了

				// 2. メール送信
				String shopEmail = request.getNumber() + "@shop.tabematch.com"; // 仮のメール
				try {
					EmailSender.sendRejectionEmail(shopEmail, request.getRestaurantName(), reason);
					req.setAttribute("successMessage", "却下が完了しました。店舗にメールを送信しました。");
				} catch (Exception e) {
					e.printStackTrace();
					req.setAttribute("successMessage", "却下が完了しましたが、メール送信に失敗しました。");
				}

				// レスポンス値をセット 6
				url = "AdminRequestList.action";
			}
		}

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}
}
package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Request;
import bean.Shop;
import bean.Users;
import dao.RequestDAO;
import dao.ShopDAO;
import dao.UserDAO;
import tool.Action;
import util.EmailSender;
import util.PasswordGenerator;

public class AdminRequestApproveAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		HttpSession session = req.getSession();
		RequestDAO requestDao = new RequestDAO();
		UserDAO userDao = new UserDAO();
		ShopDAO shopDao = new ShopDAO();

		// リクエストパラメータ―の取得 2
		String requestId = req.getParameter("requestId");

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

				// 1. 仮パスワード生成
				String tempPassword = PasswordGenerator.generatePassword();

				// 2. 店舗ユーザーアカウント作成（USERSテーブル）
				// メールアドレスはnumberを使用（電話番号から変更が必要な場合は調整）
				String shopEmail = request.getNumber() + "@shop.tabematch.com"; // 仮のメール生成

				Users shopUser = new Users();
				shopUser.setUserId(shopEmail);
				shopUser.setPassword(tempPassword);
				shopUser.setUserName(request.getRestaurantName());
				shopUser.setAllergenId("001"); // デフォルトのアレルゲンID（要調整）
				shopUser.setUsersTypeId("2"); // 店舗ユーザー

				boolean userCreated = userDao.registerUser(shopUser);

				if (!userCreated) {
					req.setAttribute("errorMessage", "店舗ユーザーの作成に失敗しました。");
					url = "AdminRequestList.action";
					req.getRequestDispatcher(url).forward(req, res);
					return;
				}

				// 3. SHOPテーブルに店舗情報登録
				Shop shop = new Shop();
				shop.setShopId(PasswordGenerator.generateShopId());
				shop.setShopAddress(request.getAddress());
				shop.setShopName(request.getRestaurantName());
				shop.setShopAllergy(request.getAllergySupport());
				shop.setShopMail(shopEmail);
				shop.setShopTel(request.getNumber().replaceAll("[^0-9]", ""));
				shop.setShopReserve(request.getReservation() == 1 ? "可能" : "不可");
				shop.setShopGenre(request.getGenre());
				shop.setShopPicture(request.getPhoto());
				shop.setShopPrice(request.getPriceRange());
				shop.setShopPay(request.getPayment());
				shop.setShopSeat(extractSeatNumber(request.getSeat())); // 座席数を抽出
				shop.setShopUrl(request.getLink());

				boolean shopCreated = shopDao.insertShop(shop);

				if (!shopCreated) {
					req.setAttribute("errorMessage", "店舗情報の登録に失敗しました。");
					url = "AdminRequestList.action";
					req.getRequestDispatcher(url).forward(req, res);
					return;
				}

				// 4. リクエストを承認済みに更新
				requestDao.updateCertification(requestId, 2); // 2=承認済み

				// DBへデータ保存 5
				// 上記で完了

				// 5. メール送信
				try {
					EmailSender.sendApprovalEmail(shopEmail, request.getRestaurantName(), shopEmail, tempPassword);
					req.setAttribute("successMessage", "承認が完了しました。店舗にメールを送信しました。");
				} catch (Exception e) {
					e.printStackTrace();
					req.setAttribute("successMessage", "承認が完了しましたが、メール送信に失敗しました。");
				}

				// レスポンス値をセット 6
				url = "AdminRequestList.action";
			}
		}

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}

	// 座席情報から数字を抽出するヘルパーメソッド
	private int extractSeatNumber(String seatInfo) {
		if (seatInfo == null || seatInfo.isEmpty()) {
			return 0;
		}

		// 数字を抽出して合計
		String[] numbers = seatInfo.replaceAll("[^0-9]", " ").trim().split("\\s+");
		int total = 0;
		for (String num : numbers) {
			if (!num.isEmpty()) {
				try {
					total += Integer.parseInt(num);
				} catch (NumberFormatException e) {
					// 無視
				}
			}
		}
		return total;
	}
}
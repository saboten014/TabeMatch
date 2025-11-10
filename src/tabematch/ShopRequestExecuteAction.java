package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Request;
import dao.RequestDAO;
import tool.Action;
import util.PasswordGenerator;

public class ShopRequestExecuteAction extends Action {

	@Override
	public void execute(HttpServletRequest req, HttpServletResponse res)
			throws Exception {
		// ローカル変数の宣言 1
		String url = "";
		RequestDAO requestDao = new RequestDAO();

		// リクエストパラメータ―の取得 2
		String address = req.getParameter("address");
		String restaurantName = req.getParameter("restaurantName");
		String allergySupport = req.getParameter("allergySupport");
		String reservationStr = req.getParameter("reservation");
		String businessHours = req.getParameter("businessHours");
		String payment = req.getParameter("payment");
		String genre = req.getParameter("genre");
		String photo = req.getParameter("photo");
		String priceRange = req.getParameter("priceRange");
		String seat = req.getParameter("seat");
		String link = req.getParameter("link");
		String number = req.getParameter("number");
		String email = req.getParameter("email");
		String request_mail = req.getParameter("request_mail");

		// DBからデータ取得 3
		// なし

		// ビジネスロジック 4

		// 入力チェック
		if (address == null || address.trim().isEmpty() ||
			restaurantName == null || restaurantName.trim().isEmpty() ||
			allergySupport == null || allergySupport.trim().isEmpty() ||
			reservationStr == null || reservationStr.trim().isEmpty() ||
			businessHours == null || businessHours.trim().isEmpty() ||
			payment == null || payment.trim().isEmpty() ||
			genre == null || genre.trim().isEmpty() ||
			seat == null || seat.trim().isEmpty() ||
			number == null || number.trim().isEmpty()||
			request_mail == null || request_mail.trim().isEmpty()) {
			// 必須項目が入力されていない
			req.setAttribute("errorMessage", "必須項目をすべて入力してください。");
			url = "shop-request.jsp";
		}
		// 住所長さチェック（VARCHAR(255)）
		else if (address.length() > 255) {
			req.setAttribute("errorMessage", "住所は255文字以内で入力してください。");
			url = "shop-request.jsp";
		}
		// 店名長さチェック（VARCHAR(100)）
		else if (restaurantName.length() > 100) {
			req.setAttribute("errorMessage", "店名は100文字以内で入力してください。");
			url = "shop-request.jsp";
		}
		// 電話番号長さチェック（VARCHAR(20)）
		else if (number.length() > 20) {
			req.setAttribute("errorMessage", "電話番号は20文字以内で入力してください。");
			url = "shop-request.jsp";
		}
		else {
			// リクエスト登録処理
			Request request = new Request();
			request.setRequestId(PasswordGenerator.generateRequestId());
			request.setAddress(address);
			request.setRestaurantName(restaurantName);
			request.setAllergySupport(allergySupport);
			request.setReservation(Integer.parseInt(reservationStr));
			request.setBusinessHours(businessHours);
			request.setPayment(payment);
			request.setGenre(genre);
			request.setPhoto(photo);
			request.setPriceRange(priceRange);
			request.setSeat(seat);
			request.setLink(link);
			request.setNumber(number);
			request.setCertification(1); // 1=未承認
			request.setRequest_mail(request_mail);

			// DBへデータ保存 5
			boolean result = requestDao.insertRequest(request);

			if (result) {
				// 登録成功
				req.setAttribute("requestId", request.getRequestId());
				url = "shop-request-complete.jsp";
			} else {
				// 登録失敗
				req.setAttribute("errorMessage", "リクエストの送信に失敗しました。もう一度お試しください。");
				url = "shop-request.jsp";
			}
		}

		// レスポンス値をセット 6
		// 上記で設定済み

		// JSPへフォワード 7
		req.getRequestDispatcher(url).forward(req, res);
	}

	// バリデーション
	public static boolean validateEmail(String email) {
		if (email == null || email.trim().isEmpty()) {
			return false;
		}
		if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
			return false;
		}
		return true;
	}
}
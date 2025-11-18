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

		String url = "";
		RequestDAO requestDao = new RequestDAO();

		// リクエストパラメータ
		String address = req.getParameter("address");
		String restaurantName = req.getParameter("restaurantName");

		// チェックボックス
		String[] allergyArray = req.getParameterValues("allergyInfo");
		String allergySupport = "";
		if (allergyArray != null) {
			allergySupport = String.join(",", allergyArray);
		}

		String reservationStr = req.getParameter("reservation");
		String businessHours = req.getParameter("businessHours");
		String payment = req.getParameter("payment");
		String genre = req.getParameter("genre");
		String photo = req.getParameter("photo");
		String priceRange = req.getParameter("priceRange");
		String seat = req.getParameter("seat");
		String link = req.getParameter("link");
		String number = req.getParameter("number");
		String request_mail = req.getParameter("request_mail");

		// 入力チェック
		if (address == null || address.trim().isEmpty() ||
			restaurantName == null || restaurantName.trim().isEmpty() ||
			allergySupport == null || allergySupport.trim().isEmpty() ||
			reservationStr == null || reservationStr.trim().isEmpty() ||
			businessHours == null || businessHours.trim().isEmpty() ||
			payment == null || payment.trim().isEmpty() ||
			genre == null || genre.trim().isEmpty() ||
			seat == null || seat.trim().isEmpty() ||
			number == null || number.trim().isEmpty() ||
			request_mail == null || request_mail.trim().isEmpty()) {

			req.setAttribute("errorMessage", "必須項目をすべて入力してください。");
			url = "shop-request.jsp";
		}
		else {
			// リクエスト登録
			Request request = new Request();
			request.setRequestId(PasswordGenerator.generateRequestId());
			request.setAddress(address);
			request.setRestaurantName(restaurantName);

			// ★ 修正済み
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
			request.setCertification(1);
			request.setRequest_mail(request_mail);

			boolean result = requestDao.insertRequest(request);

			if (result) {
				req.setAttribute("requestId", request.getRequestId());
				url = "shop-request-complete.jsp";
			} else {
				req.setAttribute("errorMessage", "リクエストの送信に失敗しました。もう一度お試しください。");
				url = "shop-request.jsp";
			}
		}

		req.getRequestDispatcher(url).forward(req, res);
	}

}

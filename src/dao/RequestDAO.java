package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Request;

public class RequestDAO extends DAO {

	// リクエスト登録
	public boolean insertRequest(Request request) throws Exception {
		Connection con = getConnection();

		// INSERT文にrequest_mailカラムが含まれていることを確認
		String sql = "INSERT INTO requests (request_id, address, restaurant_name, " +
		        "allergy_support, reservation, business_hours, payment, genre, " +
		        "photo, price_range, seat, link, phone_number, certification, request_mail) " +
		        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, request.getRequestId());
		stmt.setString(2, request.getAddress());
		stmt.setString(3, request.getRestaurantName());
		stmt.setString(4, request.getAllergySupport());
		stmt.setInt(5, request.getReservation());
		stmt.setString(6, request.getBusinessHours());
		//確かめよう
		System.out.println(request.getBusinessHours());
		if (request.getBusinessHours() == null) {
		    System.out.println("ない！！！！");
		}
		stmt.setString(7, request.getPayment());
		stmt.setString(8, request.getGenre());
		stmt.setString(9, request.getPhoto());
		stmt.setString(10, request.getPriceRange());
		stmt.setString(11, request.getSeat());
		stmt.setString(12, request.getLink());
		stmt.setString(13, request.getNumber());
		stmt.setInt(14, request.getCertification());
		stmt.setString(15,request.getRequest_mail() );

		int result = stmt.executeUpdate();

		stmt.close();
		con.close();

		return result > 0;
	}

	// 全リクエストを取得（管理者用）
	public List<Request> getAllRequests() throws Exception {
		List<Request> requestList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM requests ORDER BY request_id DESC";

		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Request request = mapResultSetToRequest(rs);
			requestList.add(request);
		}

		rs.close();
		stmt.close();
		con.close();

		return requestList;
	}

	// 未承認リクエストのみ取得
	public List<Request> getPendingRequests() throws Exception {
		List<Request> requestList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM requests WHERE certification = 1 ORDER BY request_id DESC";

		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Request request = mapResultSetToRequest(rs);
			requestList.add(request);
		}

		rs.close();
		stmt.close();
		con.close();

		return requestList;
	}

	// リクエストIDでリクエストを取得
	public Request getRequestById(String requestId) throws Exception {
		Request request = null;
		Connection con = getConnection();

		String sql = "SELECT * FROM requests WHERE request_id = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, requestId);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			request = mapResultSetToRequest(rs);
		}

		rs.close();
		stmt.close();
		con.close();

		return request;
	}

	// 承認状態を更新
	public boolean updateCertification(String requestId, int certification) throws Exception {
		Connection con = getConnection();

		String sql = "UPDATE requests SET certification = ? WHERE request_id = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setInt(1, certification);
		stmt.setString(2, requestId);

		int result = stmt.executeUpdate();

		stmt.close();
		con.close();

		return result > 0;
	}

	// ResultSetからRequestオブジェクトへのマッピング
	private Request mapResultSetToRequest(ResultSet rs) throws Exception {
		Request request = new Request();
		request.setRequestId(rs.getString("request_id"));
		request.setAddress(rs.getString("address"));
		request.setRestaurantName(rs.getString("restaurant_name"));
		request.setAllergySupport(rs.getString("allergy_support"));
		request.setReservation(rs.getInt("reservation"));
		request.setBusinessHours(rs.getString("business_hours"));
		request.setPayment(rs.getString("payment"));
		request.setGenre(rs.getString("genre"));
		request.setPhoto(rs.getString("photo"));
		request.setPriceRange(rs.getString("price_range"));
		request.setSeat(rs.getString("seat"));
		request.setLink(rs.getString("link"));
		request.setNumber(rs.getString("phone_number"));
		request.setCertification(rs.getInt("certification"));
		request.setRequest_mail(rs.getString("request_mail"));
		return request;
	}
}
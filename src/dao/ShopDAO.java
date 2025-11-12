package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Shop;

public class ShopDAO extends DAO {

	// 店舗登録
	public boolean insertShop(Shop shop) throws Exception {
		Connection con = getConnection();

		String sql = "INSERT INTO shop (shop_id, password, shop_address, shop_name, shop_allergy, shop_mail, " +
			    "shop_tel, shop_reserve, shop_genre, shop_picture, shop_price, shop_pay, shop_seat, shop_url) " +
			    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, shop.getShopId());
			stmt.setString(2, shop.getPassword());
			stmt.setString(3, shop.getShopAddress());
			stmt.setString(4, shop.getShopName());
			stmt.setString(5, shop.getShopAllergy());
			stmt.setString(6, shop.getShopMail());
			stmt.setString(7, shop.getShopTel());
			stmt.setString(8, shop.getShopReserve());
			stmt.setString(9, shop.getShopGenre());
			stmt.setString(10, shop.getShopPicture());
			stmt.setString(11, shop.getShopPrice());
			stmt.setString(12, shop.getShopPay());
			stmt.setInt(13, shop.getShopSeat());
			stmt.setString(14, shop.getShopUrl());


		int result = stmt.executeUpdate();

		stmt.close();
		con.close();

		return result > 0;
	}

	// 全店舗を取得
	public List<Shop> getAllShops() throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP ORDER BY SHOP_ID";

		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// すべての条件で検索（アレルギー情報含む）
	public List<Shop> searchAll(String searchArea, String shopName, String genre,
			String priceRange, String businessHours, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? " +
				"AND SHOP_PRICE LIKE ? AND SHOP_TIME::text LIKE ? " +
				buildAllergyCondition(allergyInfo);

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, "%" + searchArea + "%");
		stmt.setString(2, "%" + shopName + "%");
		stmt.setString(3, "%" + genre + "%");
		stmt.setString(4, "%" + priceRange + "%");
		stmt.setString(5, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// アレルギー情報なしで検索
	public List<Shop> searchWithoutAllergy(String searchArea, String shopName, String genre,
			String priceRange, String businessHours) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		StringBuilder sql = new StringBuilder("SELECT * FROM SHOP WHERE 1=1");

		if (!isEmpty(searchArea)) sql.append(" AND SHOP_ADDRESS LIKE ?");
		if (!isEmpty(shopName)) sql.append(" AND SHOP_NAME LIKE ?");
		if (!isEmpty(genre)) sql.append(" AND SHOP_GENRE LIKE ?");
		if (!isEmpty(priceRange)) sql.append(" AND SHOP_PRICE LIKE ?");
		if (!isEmpty(businessHours)) sql.append(" AND SHOP_TIME LIKE ?");

		PreparedStatement stmt = con.prepareStatement(sql.toString());

		int paramIndex = 1;
		if (!isEmpty(searchArea)) stmt.setString(paramIndex++, "%" + searchArea + "%");
		if (!isEmpty(shopName)) stmt.setString(paramIndex++, "%" + shopName + "%");
		if (!isEmpty(genre)) stmt.setString(paramIndex++, "%" + genre + "%");
		if (!isEmpty(priceRange)) stmt.setString(paramIndex++, "%" + priceRange + "%");
		if (!isEmpty(businessHours)) stmt.setString(paramIndex++, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 検索エリアのみで検索（店名なし）
	public List<Shop> searchByArea(String searchArea, String genre,
			String priceRange, String businessHours, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_GENRE LIKE ? AND SHOP_PRICE LIKE ? AND SHOP_TIME::text LIKE ? " +
				buildAllergyCondition(allergyInfo);

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, "%" + searchArea + "%");
		stmt.setString(2, "%" + genre + "%");
		stmt.setString(3, "%" + priceRange + "%");
		stmt.setString(4, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 検索エリアと店名で検索（ジャンルなし）
	public List<Shop> searchByAreaAndName(String searchArea, String shopName,
			String priceRange, String businessHours, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_PRICE LIKE ? AND SHOP_TIME::text LIKE ? " +
				buildAllergyCondition(allergyInfo);

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, "%" + searchArea + "%");
		stmt.setString(2, "%" + shopName + "%");
		stmt.setString(3, "%" + priceRange + "%");
		stmt.setString(4, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 検索エリア、店名、ジャンルで検索（価格帯なし）
	public List<Shop> searchByAreaNameGenre(String searchArea, String shopName,
			String genre, String businessHours, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? AND SHOP_TIME::text LIKE ? " +
				buildAllergyCondition(allergyInfo);

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, "%" + searchArea + "%");
		stmt.setString(2, "%" + shopName + "%");
		stmt.setString(3, "%" + genre + "%");
		stmt.setString(4, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 検索エリア、店名、ジャンル、価格帯で検索（営業時間なし）
	public List<Shop> searchByAreaNameGenrePrice(String searchArea, String shopName,
			String genre, String priceRange, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? AND SHOP_PRICE LIKE ? " +
				buildAllergyCondition(allergyInfo);

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, "%" + searchArea + "%");
		stmt.setString(2, "%" + shopName + "%");
		stmt.setString(3, "%" + genre + "%");
		stmt.setString(4, "%" + priceRange + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 柔軟な検索（入力された項目のみで検索、アレルギー情報含む）
	public List<Shop> searchFlexible(String searchArea, String shopName, String genre,
			String priceRange, String businessHours, String[] allergyInfo) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		StringBuilder sql = new StringBuilder("SELECT * FROM SHOP WHERE 1=1");

		if (!isEmpty(searchArea)) sql.append(" AND SHOP_ADDRESS LIKE ?");
		if (!isEmpty(shopName)) sql.append(" AND SHOP_NAME LIKE ?");
		if (!isEmpty(genre)) sql.append(" AND SHOP_GENRE LIKE ?");
		if (!isEmpty(priceRange)) sql.append(" AND SHOP_PRICE LIKE ?");
		if (!isEmpty(businessHours)) sql.append(" AND SHOP_TIME::text LIKE ?");
		sql.append(buildAllergyCondition(allergyInfo));

		PreparedStatement stmt = con.prepareStatement(sql.toString());

		int paramIndex = 1;
		if (!isEmpty(searchArea)) stmt.setString(paramIndex++, "%" + searchArea + "%");
		if (!isEmpty(shopName)) stmt.setString(paramIndex++, "%" + shopName + "%");
		if (!isEmpty(genre)) stmt.setString(paramIndex++, "%" + genre + "%");
		if (!isEmpty(priceRange)) stmt.setString(paramIndex++, "%" + priceRange + "%");
		if (!isEmpty(businessHours)) stmt.setString(paramIndex++, "%" + businessHours + "%");

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Shop shop = mapResultSetToShop(rs);
			shopList.add(shop);
		}

		rs.close();
		stmt.close();
		con.close();

		return shopList;
	}

	// 柔軟な検索（アレルギー情報なし）
	public List<Shop> searchFlexibleWithoutAllergy(String searchArea, String shopName, String genre,
			String priceRange, String businessHours) throws Exception {
		return searchWithoutAllergy(searchArea, shopName, genre, priceRange, businessHours);
	}

	// アレルギー条件を構築するヘルパーメソッド
	private String buildAllergyCondition(String[] allergyInfo) {
		if (allergyInfo == null || allergyInfo.length == 0) {
			return "";
		}

		StringBuilder condition = new StringBuilder(" AND (");
		for (int i = 0; i < allergyInfo.length; i++) {
			if (i > 0) {
				condition.append(" OR ");
			}
			condition.append("SHOP_ALLERGY LIKE '%").append(allergyInfo[i]).append("%'");
		}
		condition.append(")");

		return condition.toString();
	}

	// 空文字チェック
	private boolean isEmpty(String value) {
		return value == null || value.trim().isEmpty();
	}

	// 店舗IDで店舗情報を取得
	public Shop getShopById(String shopId) throws Exception {
		Shop shop = null;
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ID = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, shopId);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			shop = mapResultSetToShop(rs);
		}

		rs.close();
		stmt.close();
		con.close();

		return shop;
	}

	public Shop getShopByMail(String mail) throws Exception {
	    Connection con = getConnection();
	    String sql = "SELECT * FROM shop WHERE shop_mail = ?";
	    PreparedStatement stmt = con.prepareStatement(sql);
	    stmt.setString(1, mail);
	    ResultSet rs = stmt.executeQuery();

	    Shop shop = null;
	    if (rs.next()) {
	        shop = new Shop();
	        shop.setShopId(rs.getString("shop_id"));
	        shop.setShopName(rs.getString("shop_name"));
	        shop.setShopAddress(rs.getString("shop_address"));
	        shop.setShopTel(rs.getString("shop_tel"));
	        shop.setShopUrl(rs.getString("shop_url"));
	        shop.setShopAllergy(rs.getString("shop_allergy"));
	    }

	    rs.close(); stmt.close(); con.close();
	    return shop;
	}

	public boolean updateShop(Shop shop) throws Exception {
	    Connection con = getConnection();
	    String sql = "UPDATE shop SET shop_name=?, shop_address=?, shop_tel=?, shop_url=?, shop_allergy=? WHERE shop_id=?";
	    PreparedStatement stmt = con.prepareStatement(sql);
	    stmt.setString(1, shop.getShopName());
	    stmt.setString(2, shop.getShopAddress());
	    stmt.setString(3, shop.getShopTel());
	    stmt.setString(4, shop.getShopUrl());
	    stmt.setString(5, shop.getShopAllergy());
	    stmt.setString(6, shop.getShopId());

	    int result = stmt.executeUpdate();
	    stmt.close(); con.close();
	    return result > 0;
	}


	// ResultSetからShopオブジェクトへのマッピング
	private Shop mapResultSetToShop(ResultSet rs) throws Exception {
		Shop shop = new Shop();
		shop.setShopId(rs.getString("SHOP_ID"));
		shop.setShopAddress(rs.getString("SHOP_ADDRESS"));
		shop.setShopName(rs.getString("SHOP_NAME"));
		shop.setShopAllergy(rs.getString("SHOP_ALLERGY"));
		shop.setShopMail(rs.getString("SHOP_MAIL"));
		shop.setShopTel(rs.getString("SHOP_TEL"));
		shop.setShopDate(rs.getTimestamp("SHOP_DATE"));
		shop.setShopTime(rs.getTime("SHOP_TIME"));
		shop.setShopReserve(rs.getString("SHOP_RESERVE"));
		shop.setShopGenre(rs.getString("SHOP_GENRE"));
		shop.setShopPicture(rs.getString("SHOP_PICTURE"));
		shop.setShopPrice(rs.getString("SHOP_PRICE"));
		shop.setShopPay(rs.getString("SHOP_PAY"));
		shop.setShopSeat(rs.getInt("SHOP_SEAT"));
		shop.setShopUrl(rs.getString("SHOP_URL"));
		shop.setReviewId(rs.getString("REVIEW_ID"));
		return shop;
	}
}
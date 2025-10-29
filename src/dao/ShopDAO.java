package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Shop;

public class ShopDAO extends DAO {

	// すべての条件で検索
	public List<Shop> searchAll(String searchArea, String shopName, String genre,
			String priceRange, String businessHours) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? " +
				"AND SHOP_PRICE LIKE ? AND SHOP_TIME LIKE ?";

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

	// 検索エリアのみで検索（店名なし）
	public List<Shop> searchByArea(String searchArea, String genre,
			String priceRange, String businessHours) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_GENRE LIKE ? AND SHOP_PRICE LIKE ? AND SHOP_TIME LIKE ?";

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
			String priceRange, String businessHours) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_PRICE LIKE ? AND SHOP_TIME LIKE ?";

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
			String genre, String businessHours) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? AND SHOP_TIME LIKE ?";

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
			String genre, String priceRange) throws Exception {
		List<Shop> shopList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT * FROM SHOP WHERE SHOP_ADDRESS LIKE ? " +
				"AND SHOP_NAME LIKE ? AND SHOP_GENRE LIKE ? AND SHOP_PRICE LIKE ?";

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

	// ResultSetからShopオブジェクトへのマッピング
	private Shop mapResultSetToShop(ResultSet rs) throws Exception {
		Shop shop = new Shop();
		shop.setShopId(rs.getString("SHOP_ID"));
		shop.setShopAddress(rs.getString("SHOP_ADDRESS"));
		shop.setShopName(rs.getString("SHOP_NAME"));
		shop.setShopAllergy(rs.getString("SHOP_ALLERGY"));
		shop.setShopMail(rs.getString("SHOP_MAIL"));
		shop.setShopTel(rs.getInt("SHOP_TEL"));
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
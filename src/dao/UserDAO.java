package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import bean.Users;

public class UserDAO extends DAO {

	// ログイン認証
	public Users login(String userId, String password) throws Exception {
		Users user = null;
		Connection con = getConnection();

		String sql = "SELECT user_id, password, user_name, allergen_id, users_type_id " +
				"FROM users WHERE user_id = ? AND password = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, userId);
		stmt.setString(2, password);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			user = new Users();
			user.setUserId(rs.getString("user_id"));
			user.setPassword(rs.getString("password"));
			user.setUserName(rs.getString("user_name"));
			user.setAllergenId(rs.getString("allergen_id"));
			user.setUsersTypeId(rs.getString("users_type_id"));
		}

		rs.close();
		stmt.close();
		con.close();

		return user;
	}

	// ユーザーIDで検索（重複チェック用）
	public Users getUserById(String userId) throws Exception {
		Users user = null;
		Connection con = getConnection();

		String sql = "SELECT user_id, password, user_name, allergen_id, users_type_id " +
				"FROM users WHERE user_id = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, userId);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			user = new Users();
			user.setUserId(rs.getString("user_id"));
			user.setPassword(rs.getString("password"));
			user.setUserName(rs.getString("user_name"));
			user.setAllergenId(rs.getString("allergen_id"));
			user.setUsersTypeId(rs.getString("users_type_id"));
		}

		rs.close();
		stmt.close();
		con.close();

		return user;
	}

	// 新規ユーザー登録
	// 新規ユーザー登録
	public boolean registerUser(Users user) throws Exception {
	    Connection con = getConnection();

	    String sql = "INSERT INTO users (user_id, password, user_name, allergen_id, users_type_id) " +
	                 "VALUES (?, ?, ?, ?, ?)";

	    PreparedStatement stmt = con.prepareStatement(sql);
	    stmt.setString(1, user.getUserId());
	    stmt.setString(2, user.getPassword());
	    stmt.setString(3, user.getUserName());

	    String allergenCsv = user.getAllergenId();

	    if (allergenCsv != null && !allergenCsv.isEmpty()) {
	        // カンマ区切りを配列に変換
	        String[] allergenArray = allergenCsv.split(",");

	        // PostgreSQL用の配列オブジェクトを作成
	        java.sql.Array sqlArray = con.createArrayOf("varchar", allergenArray);
	        stmt.setArray(4, sqlArray);
	    } else {
	        // 空ならNULLをセット
	        stmt.setNull(4, java.sql.Types.ARRAY);
	    }

	    stmt.setString(5, user.getUsersTypeId());

	    int result = stmt.executeUpdate();

	    stmt.close();
	    con.close();

	    return result > 0;
	}

	public boolean updateUser(Users user) throws Exception {
	    Connection con = getConnection();

	    String sql = "UPDATE users SET password = ?, user_name = ?, allergen_id = ? WHERE user_id = ?";
	    PreparedStatement stmt = con.prepareStatement(sql);
	    stmt.setString(1, user.getPassword());
	    stmt.setString(2, user.getUserName());

	    if (user.getAllergenId() != null && !user.getAllergenId().isEmpty()) {
	        String[] allergenArray = user.getAllergenId().split(",");
	        java.sql.Array sqlArray = con.createArrayOf("varchar", allergenArray);
	        stmt.setArray(3, sqlArray);
	    } else {
	        stmt.setNull(3, java.sql.Types.ARRAY);
	    }

	    stmt.setString(4, user.getUserId());

	    int result = stmt.executeUpdate();

	    stmt.close();
	    con.close();

	    return result > 0;
	}



}
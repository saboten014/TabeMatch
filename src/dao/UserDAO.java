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

		String sql = "SELECT USER_ID, PASSWORD, USER_NAME, ALLERGEN_ID, USERS_TYPE_ID " +
				"FROM USER WHERE USER_ID = ? AND PASSWORD = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, userId);
		stmt.setString(2, password);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			user = new Users();
			user.setUserId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("PASSWORD"));
			user.setUserName(rs.getString("USER_NAME"));
			user.setAllergenId(rs.getString("ALLERGEN_ID"));
			user.setUsersTypeId(rs.getString("USERS_TYPE_ID"));
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

		String sql = "SELECT USER_ID, PASSWORD, USER_NAME, ALLERGEN_ID, USERS_TYPE_ID " +
				"FROM USER WHERE USER_ID = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, userId);

		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			user = new Users();
			user.setUserId(rs.getString("USER_ID"));
			user.setPassword(rs.getString("PASSWORD"));
			user.setUserName(rs.getString("USER_NAME"));
			user.setAllergenId(rs.getString("ALLERGEN_ID"));
			user.setUsersTypeId(rs.getString("USERS_TYPE_ID"));
		}

		rs.close();
		stmt.close();
		con.close();

		return user;
	}

	// 新規ユーザー登録
	public boolean registerUser(Users user) throws Exception {
		Connection con = getConnection();

		String sql = "INSERT INTO USER (USER_ID, PASSWORD, USER_NAME, ALLERGEN_ID, USERS_TYPE_ID) " +
				"VALUES (?, ?, ?, ?, ?)";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, user.getUserId());
		stmt.setString(2, user.getPassword());
		stmt.setString(3, user.getUserName());
		stmt.setString(4, user.getAllergenId());
		stmt.setString(5, user.getUsersTypeId());

		int result = stmt.executeUpdate();

		stmt.close();
		con.close();

		return result > 0;
	}
}
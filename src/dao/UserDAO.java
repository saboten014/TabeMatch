package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Users;

public class UserDAO extends DAO {

	// ログイン認証
	public Users login(String userId, String password) throws Exception {
		Users user = null;
		Connection con = getConnection();

		String sql = "SELECT user_id, password, user_name, allergen_id, users_type_id, created_at "
				+ "FROM users WHERE user_id = ? AND password = ?";

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
			// ★追加：登録日(created_at)
			user.setCreatedAt(rs.getTimestamp("created_at"));
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

		String sql = "SELECT user_id, password, user_name, allergen_id, users_type_id, created_at "
				+ "FROM users WHERE user_id = ?";

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
			// ★追加：登録日(created_at)
			user.setCreatedAt(rs.getTimestamp("created_at"));
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
	    	// ★修正ポイント：NULL ではなく空配列 {} を入れる
	        java.sql.Array emptyArray = con.createArrayOf("varchar", new String[]{});
	        stmt.setArray(4, emptyArray);
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

	//パスワードの変更用
	public int updatePassword(String userId, String newHashedPassword) throws Exception {
        Connection con = null;
        PreparedStatement st = null;
        int line = 0;

        try {
            con = getConnection();

            // パスワードを更新するSQL文
            // ★実際には、newHashedPasswordは安全なハッシュ関数で生成された文字列であることを前提とします
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";

            st = con.prepareStatement(sql);
            st.setString(1, newHashedPassword);
            st.setString(2, userId);

            line = st.executeUpdate();

        } catch (Exception e) {
            // エラー処理（ログ出力など）
            throw e;
        } finally {
            // リソースのクローズ処理
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return line;
    }

	// ============================================================
	// ★追加：一般ユーザ一覧（管理者用）
	// ============================================================
	public List<Users> getGeneralUserList() throws Exception {

		List<Users> list = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT user_id, user_name, created_at FROM users WHERE users_type_id = '1' ORDER BY created_at DESC";

		PreparedStatement stmt = con.prepareStatement(sql);

		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Users user = new Users();
			user.setUserId(rs.getString("user_id"));
			user.setUserName(rs.getString("user_name"));

			// ★追加
			user.setCreatedAt(rs.getTimestamp("created_at"));

			list.add(user);
		}

		rs.close();
		stmt.close();
		con.close();

		return list;
	}

		// ============================================================
		// ★追加：一般ユーザ詳細取得
		// ============================================================
		public Users getGeneralUserDetail(String userId) throws Exception {

			Users user = null;
			Connection con = getConnection();

			String sql = "SELECT user_id, user_name, created_at FROM users WHERE user_id = ? AND users_type_id = '1'";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, userId);

			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				user = new Users();
				user.setUserId(rs.getString("user_id"));
				user.setUserName(rs.getString("user_name"));

				// ★追加
				user.setCreatedAt(rs.getTimestamp("created_at"));
			}

			rs.close();
			stmt.close();
			con.close();

			return user;
		}

		// ============================================================
		// ★追加：一般ユーザ削除（物理削除）
		// ============================================================
		public boolean deleteUser(String userId) throws Exception {

			Connection con = getConnection();

			String sql = "DELETE FROM users WHERE user_id = ? AND users_type_id = '1'";

			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, userId);

			int result = stmt.executeUpdate();

			stmt.close();
			con.close();

			return result > 0;
		}

		// ============================================================
		// ★追加：フィルタ + ページネーション対応 一般ユーザ一覧
		// ============================================================
		public List<Users> getGeneralUserList(String initial, int offset, int limit) throws Exception {

		    List<Users> list = new ArrayList<>();
		    Connection con = getConnection();

		    // ★ポイント
		    // initial が null ⇒ フィルタなし
		    // A-Z ⇒ user_name ILIKE 'A%'
		    // ア/カ/サ… ⇒ user_name LIKE 'ア%' （日本語は ILIKE 不要）
		    // 文字コードの違いにも対応できる安全設計

		    StringBuilder sql = new StringBuilder();
		    sql.append("SELECT user_id, user_name, created_at ");
		    sql.append("FROM users WHERE users_type_id = '1' ");

		    // ★フィルタあり
		    if (initial != null && !initial.isEmpty()) {
		        // A～Z（アルファベット）
		        if (initial.matches("[A-Z]")) {
		            sql.append("AND user_name ILIKE ? ");
		        }
		        // 五十音
		        else {
		            sql.append("AND user_name LIKE ? ");
		        }
		    }

		    sql.append("ORDER BY created_at DESC ");
		    sql.append("LIMIT ? OFFSET ? ");

		    PreparedStatement stmt = con.prepareStatement(sql.toString());

		    int idx = 1;

		    if (initial != null && !initial.isEmpty()) {
		        stmt.setString(idx++, initial + "%");  // 頭文字一致
		    }

		    stmt.setInt(idx++, limit);
		    stmt.setInt(idx++, offset);

		    ResultSet rs = stmt.executeQuery();

		    while (rs.next()) {
		        Users user = new Users();
		        user.setUserId(rs.getString("user_id"));
		        user.setUserName(rs.getString("user_name"));
		        user.setCreatedAt(rs.getTimestamp("created_at"));
		        list.add(user);
		    }

		    rs.close();
		    stmt.close();
		    con.close();

		    return list;
		}


		// ============================================================
		// ★追加：件数カウント（ページネーション用）
		// ============================================================
		public int getGeneralUserCount(String initial) throws Exception {

		    Connection con = getConnection();

		    StringBuilder sql = new StringBuilder();
		    sql.append("SELECT COUNT(*) FROM users WHERE users_type_id = '1' ");

		    if (initial != null && !initial.isEmpty()) {
		        // 英字 or 日本語
		        if (initial.matches("[A-Z]")) {
		            sql.append("AND user_name ILIKE ? ");
		        } else {
		            sql.append("AND user_name LIKE ? ");
		        }
		    }

		    PreparedStatement stmt = con.prepareStatement(sql.toString());

		    if (initial != null && !initial.isEmpty()) {
		        stmt.setString(1, initial + "%");
		    }

		    ResultSet rs = stmt.executeQuery();
		    rs.next();
		    int count = rs.getInt(1);

		    rs.close();
		    stmt.close();
		    con.close();

		    return count;
		}


}
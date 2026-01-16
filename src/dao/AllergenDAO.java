package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Allergen;

public class AllergenDAO extends DAO {

	// 全てのアレルゲン情報を取得
	public List<Allergen> getAllAllergens() throws Exception {
		List<Allergen> allergenList = new ArrayList<>();
		Connection con = getConnection();

		String sql = "SELECT ALLERGEN_ID, ALLERGEN_NAME FROM ALLERGEN ORDER BY ALLERGEN_ID";

		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			Allergen allergen = new Allergen();
			allergen.setAllergenId(rs.getString("ALLERGEN_ID"));
			allergen.setAllergenName(rs.getString("ALLERGEN_NAME"));
			allergenList.add(allergen);
		}

		rs.close();
		stmt.close();
		con.close();

		return allergenList;
	}

	// アレルゲンIDでアレルゲン情報を取得
	public Allergen getAllergenById(String allergenId) throws Exception {
		Allergen allergen = null;
		Connection con = getConnection();

		String sql = "SELECT * FROM ALLERGEN WHERE ALLERGEN_ID = ?";

		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1, allergenId);
		ResultSet rs = stmt.executeQuery();

		if (rs.next()) {
			allergen = new Allergen();
			allergen.setAllergenId(rs.getString("ALLERGEN_ID"));
			allergen.setAllergenName(rs.getString("ALLERGEN_NAME"));
		}

		rs.close();
		stmt.close();
		con.close();

		return allergen;
	}

	//ユーザごとのアレルギーを検索
	public List<Allergen> getAllergensByUserId(String userId) throws Exception {
	    List<Allergen> list = new ArrayList<>();
	    Connection con = getConnection();

	    // SQL: 配列に含まれるIDをすべてJOINして取得
	    String sql = "SELECT a.ALLERGEN_ID, a.ALLERGEN_NAME " +
	                 "FROM USERS u " +
	                 "JOIN ALLERGEN a ON a.ALLERGEN_ID = ANY(u.ALLERGEN_ID) " +
	                 "WHERE u.USER_ID = ?";

	    PreparedStatement stmt = con.prepareStatement(sql);
	    stmt.setString(1, userId);
	    ResultSet rs = stmt.executeQuery();

	    while (rs.next()) {
	        Allergen a = new Allergen();
	        a.setAllergenId(rs.getString("ALLERGEN_ID"));
	        a.setAllergenName(rs.getString("ALLERGEN_NAME"));
	        list.add(a);
	    }

	    rs.close();
	    stmt.close();
	    con.close();
	    return list;
	}

}
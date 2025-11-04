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
}
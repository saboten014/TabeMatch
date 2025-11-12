package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.News;

public class NewsDAO extends DAO{

//必要なのは一覧表示用の取得（タイトル、日付、本文ちょっと）メソッド
//詳細までフルで表示する（ALL）メソッド
//IDで取得するやつか？？

	//DB登録（書き込み用）メソッド
	public boolean insertNews(News news) throws Exception {
		Connection con = getConnection();

		//INSERT文
		String sql = "INSERT INTO NOTICES (news_id, news_title, news_text, delivery_date, " +
				"edit_date, role) VALUES (?, ?, ?, ?, ?, ?)";

		PreparedStatement ps = con.prepareStatement(sql);
		ps.setString(1, news.getNewsId());
		ps.setString(2, news.getNewsTitle());
		ps.setString(3, news.getNewsText());
		ps.setTimestamp(4, news.getDeliveryDate());
		ps.setTimestamp(5, news.getEditDate());
		ps.setString(6, news.getRole());

		int result = ps.executeUpdate();

		ps.close();
		con.close();

		return result > 0;
	}

	// お知らせ取得用メソッド
	public List<News> all() throws Exception {
	    List<News> list = new ArrayList<>();

	    // try-with-resources を使用して、リソースの自動クローズを保証
	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement("select news_id, news_title, "
	         		+ "news_text, delivery_date, edit_date, role"
	         		+ "from NOTICES order by delivery desc");
	         ResultSet rs = st.executeQuery()) {

	        while (rs.next()) {
	            News n = new News();
	            // データをBeanにセット
	            n.setNewsId(rs.getString("news_id"));
	            n.setNewsTitle(rs.getString("news_title"));
	            n.setNewsText(rs.getString("news_text"));
	            n.setDeliveryDate(rs.getTimestamp("delivery_date"));
	            n.setEditDate(rs.getTimestamp("edit_date"));
	            n.setRole(rs.getString("role"));

	            list.add(n);
	        }

	    } // catchブロックやfinallyブロックなしで、con, st, rs が自動的にクローズされる

	    return list;
	}

}

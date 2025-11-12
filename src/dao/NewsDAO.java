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

	    // SQLを修正：カラムリストの末尾とFROMの間にスペースを追加。ソートキーを delivery_date に修正。
	    String sql = "select news_id, news_title, news_text, delivery_date, edit_date, role "
	               + "from notices order by delivery_date desc";

	    // try-with-resources を使用して、リソースの自動クローズを保証
	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement(sql);
	         ResultSet rs = st.executeQuery()) {

	        while (rs.next()) {
	            News n = new News();
	            // データをBeanにセット (列名は画像と一致しており、これで正しいです)
	            n.setNewsId(rs.getString("news_id"));
	            n.setNewsTitle(rs.getString("news_title"));
	            n.setNewsText(rs.getString("news_text"));
	            n.setDeliveryDate(rs.getTimestamp("delivery_date"));
	            n.setEditDate(rs.getTimestamp("edit_date"));
	            n.setRole(rs.getString("role"));

	            list.add(n);
	        }

	    }

	    return list;
	}

	// NewsDAO.java に以下のメソッドを追加してください

	// お知らせをIDで取得するメソッド
	public News findById(String newsId) throws Exception {
	    News news = null;

	    // SQLクエリ：指定されたnews_idを持つレコードを検索
	    String sql = "SELECT news_id, news_title, news_text, delivery_date, edit_date, role "
	               + "FROM notices WHERE news_id = ?";

	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement(sql)) {

	        // プレースホルダにnewsIdをセット
	        st.setString(1, newsId);

	        try (ResultSet rs = st.executeQuery()) {
	            if (rs.next()) {
	                news = new News();
	                // データをBeanにセット (all()メソッドと同じマッピング)
	                news.setNewsId(rs.getString("news_id"));
	                news.setNewsTitle(rs.getString("news_title"));
	                news.setNewsText(rs.getString("news_text"));
	                news.setDeliveryDate(rs.getTimestamp("delivery_date"));
	                news.setEditDate(rs.getTimestamp("edit_date"));
	                news.setRole(rs.getString("role"));
	            }
	        } // rsが自動的にクローズされる

	    } // con, stが自動的にクローズされる

	    return news;
	}

}

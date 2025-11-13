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

	// お知らせを登録するメソッド
	public boolean insert(News news) throws Exception {
	    int result = 0;


	    String sql = "INSERT INTO notices (news_title, news_text, delivery_date) VALUES (?, ?, CURRENT_TIMESTAMP)";

	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement(sql)) {

	        // プレースホルダに値をセット
	        st.setString(1, news.getNewsTitle());
	        st.setString(2, news.getNewsText());

	        // 実行
	        result = st.executeUpdate();

	    } // con, stが自動的にクローズされる

	    // 登録された行数が1であれば成功
	    return result == 1;
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
	            n.setNewsId(rs.getInt("news_id"));
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

	// お知らせをIDで取得するメソッド
	public News findById(int newsId) throws Exception {
	    News news = null;
	    String sql = "SELECT news_id, news_title, news_text, delivery_date FROM notices WHERE news_id = ?";

	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement(sql)) {

	        // プレースホルダにint型のIDをセット
	        st.setInt(1, newsId);

	        try (ResultSet rs = st.executeQuery()) {
	            if (rs.next()) {
	                news = new News();
	                // DBの型に合わせて int 型で取得
	                news.setNewsId(rs.getInt("news_id"));
	                news.setNewsTitle(rs.getString("news_title"));
	                news.setNewsText(rs.getString("news_text"));
	                // Timestamp 型で取得
	                news.setDeliveryDate(rs.getTimestamp("delivery_date"));
	            }
	        }
	    }
	    return news;
	}


	// お知らせを削除するメソッド
	// int型のIDを受け取るように変更
	public boolean delete(int newsId) throws Exception {
	    int result = 0;

	    // SQLクエリ：指定されたIDの行を削除
	    String sql = "DELETE FROM notices WHERE news_id = ?";

	    try (Connection con = getConnection();
	         PreparedStatement st = con.prepareStatement(sql)) {

	        // プレースホルダにint型のIDをセット
	        st.setInt(1, newsId);

	        // 実行
	        result = st.executeUpdate();

	    }

	    // 削除された行数が1であれば成功
	    return result == 1;
	}

}

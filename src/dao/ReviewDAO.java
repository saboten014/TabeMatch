package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Review;

public class ReviewDAO extends DAO {

    // 口コミ登録
    public boolean insertReview(Review review) throws Exception {

        String sql = "INSERT INTO review (review_id, user_id, shop_id, title, body, rating, created_at, updated_at, delete_flg) "
                   + "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '0')";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, review.getReviewIdString());   // ★varchar(20)
            stmt.setString(2, review.getUserIdString());     // ★varchar(20)
            stmt.setString(3, review.getShopIdString());     // ★varchar(30)
            stmt.setString(4, review.getTitle());            // ★title
            stmt.setString(5, review.getBody());             // ★body
            stmt.setInt(6, review.getRating());

            int result = stmt.executeUpdate();
            return result > 0;
        }
    }


 // 店舗IDを元に口コミ一覧取得（ユーザー名も取得するように修正）
    public List<Review> getReviewsByShopId(String shopId) throws Exception {

        // ★SQLを修正：reviewテーブル(r)とusersテーブル(u)を結合
        String sql = "SELECT r.*, u.user_name " +
                     "FROM review r " +
                     "JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.shop_id = ? AND r.delete_flg = '0' " +
                     "ORDER BY r.created_at DESC";

        List<Review> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, shopId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();

                    r.setReviewIdString(rs.getString("review_id"));
                    r.setUserIdString(rs.getString("user_id"));
                    r.setShopIdString(rs.getString("shop_id"));
                    r.setTitle(rs.getString("title"));
                    r.setBody(rs.getString("body"));
                    r.setRating(rs.getInt("rating"));

                    // ★ここでusersテーブルから取得したuser_nameをセット
                    // ※ReviewクラスにuserNameフィールドとsetterがある前提です
                    r.setUserName(rs.getString("user_name"));

                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                    list.add(r);
                }
            }
        }
        return list;
    }
}

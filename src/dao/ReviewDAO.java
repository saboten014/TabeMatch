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


    // 店舗IDを元に口コミ一覧取得
    public List<Review> getReviewsByShopId(String shopId) throws Exception {

        String sql = "SELECT * FROM review WHERE shop_id = ? AND delete_flg = '0' ORDER BY created_at DESC";

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
                    r.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                    list.add(r);
                }
            }
        }
        return list;
    }
}

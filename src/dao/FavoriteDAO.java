package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

// ユーザーIDはメールアドレス(String)、店舗IDは "SHOP..." の文字列(String)と仮定して修正します。
public class FavoriteDAO extends DAO {

    // 1. お気に入り登録状態の確認 (引数 userId を String に修正)
    public boolean checkFavorite(String userId, String shopId) throws Exception { // ★ userId を String に変更 ★
        boolean isFavorite = false;
        // fav_user_id のDBの型は VARCHAR/TEXT になっている必要があります。
        String sql = "SELECT COUNT(*) FROM favorite WHERE fav_user_id = ? AND fav_shop_id = ?";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, userId); // ★ setInt から setString に変更 ★
            stmt.setString(2, shopId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    if (rs.getInt(1) > 0) {
                        isFavorite = true;
                    }
                }
            }
        }
        return isFavorite;
    }

    // 2. お気に入りへの登録 (引数 userId を String に修正)
    public boolean insertFavorite(String userId, String shopId) throws Exception { // ★ userId を String に変更 ★
        int result = 0;
        String sql = "INSERT INTO favorite (fav_user_id, fav_shop_id) VALUES (?, ?)";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, userId); // ★ setInt から setString に変更 ★
            stmt.setString(2, shopId);

            result = stmt.executeUpdate();

        }
        return result > 0;
    }

    // 3. お気に入りからの削除 (引数 userId を String に修正)
    public boolean deleteFavorite(String userId, String shopId) throws Exception { // ★ userId を String に変更 ★
        int result = 0;
        String sql = "DELETE FROM favorite WHERE fav_user_id = ? AND fav_shop_id = ?";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, userId); // ★ setInt から setString に変更 ★
            stmt.setString(2, shopId);

            result = stmt.executeUpdate();

        }
        return result > 0;
    }

    //4.登録済みお気に入り店舗一覧取得
    public List<String> getFavoriteShopIdsByUserId(String userId) throws Exception {
        List<String> shopIdList = new ArrayList<>();
        // fav_shop_id は favorite テーブルの店舗IDカラム
        String sql = "SELECT fav_shop_id FROM favorite WHERE fav_user_id = ?";

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    shopIdList.add(rs.getString("fav_shop_id"));
                }
            }
        }
        return shopIdList;
    }
}
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import bean.Shop;

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
        public List<Shop> getFavoriteShops(String userId) throws Exception {
            List<Shop> favoriteShops = new ArrayList<>();
            Connection con = getConnection();

            // ★★★ SQL文を修正: テーブル名 'favorite', カラム名 'fav_user_id', 'fav_shop_id' に合わせる ★★★
            String sql = "SELECT s.* FROM shop s "
                       + "INNER JOIN favorite f ON s.shop_id = f.fav_shop_id " // fav_shop_idを使用
                       + "WHERE f.fav_user_id = ?"; // fav_user_idを使用

            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, userId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Shop shop = new Shop();
                // Shop Beanのプロパティに合わせて値をセット
                // (shopsテーブルのカラム名が以前の想定通りであることを前提としています)
                shop.setShopId(rs.getString("shop_id"));
                shop.setShopName(rs.getString("shop_name"));
                shop.setShopAddress(rs.getString("shop_address"));
                shop.setShopAllergy("shop_allergy");

                favoriteShops.add(shop);
            }

            rs.close();
            stmt.close();
            con.close();

            return favoriteShops;
        }
}
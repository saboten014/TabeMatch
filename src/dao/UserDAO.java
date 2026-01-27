package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import bean.Users;

public class UserDAO extends DAO {

    // ======================================================
    // ★ カナ検索用：行ごとの先頭文字マップ
    // ======================================================
    private static final Map<String, String[]> KANA_MAP = new HashMap<>();
    static {
        KANA_MAP.put("ア", new String[]{"ア","イ","ウ","エ","オ"});
        KANA_MAP.put("カ", new String[]{"カ","キ","ク","ケ","コ"});
        KANA_MAP.put("サ", new String[]{"サ","シ","ス","セ","ソ"});
        KANA_MAP.put("タ", new String[]{"タ","チ","ツ","テ","ト"});
        KANA_MAP.put("ナ", new String[]{"ナ","ニ","ヌ","ネ","ノ"});
        KANA_MAP.put("ハ", new String[]{"ハ","ヒ","フ","ヘ","ホ"});
        KANA_MAP.put("マ", new String[]{"マ","ミ","ム","メ","モ"});
        KANA_MAP.put("ヤ", new String[]{"ヤ","ユ","ヨ"});
        KANA_MAP.put("ラ", new String[]{"ラ","リ","ル","レ","ロ"});
        KANA_MAP.put("ワ", new String[]{"ワ","ヲ","ン"});
    }

    // ======================================================
    // ログイン認証
    // ======================================================
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
            user.setCreatedAt(rs.getTimestamp("created_at"));
        }

        rs.close();
        stmt.close();
        con.close();

        return user;
    }

    // ======================================================
    // ユーザーIDで検索
    // ======================================================
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
            user.setCreatedAt(rs.getTimestamp("created_at"));
        }

        rs.close();
        stmt.close();
        con.close();

        return user;
    }

    // ======================================================
    // 新規ユーザー登録
    // ======================================================
    public boolean registerUser(Users user) throws Exception {
        Connection con = getConnection();

        String sql = "INSERT INTO users (user_id, password, user_name, allergen_id, users_type_id) "
                + "VALUES (?, ?, ?, ?, ?)";

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, user.getUserId());
        stmt.setString(2, user.getPassword());
        stmt.setString(3, user.getUserName());

        String allergenCsv = user.getAllergenId();

        if (allergenCsv != null && !allergenCsv.isEmpty()) {
            String[] allergenArray = allergenCsv.split(",");
            java.sql.Array sqlArray = con.createArrayOf("varchar", allergenArray);
            stmt.setArray(4, sqlArray);
        } else {
            java.sql.Array emptyArray = con.createArrayOf("varchar", new String[]{});
            stmt.setArray(4, emptyArray);
        }

        stmt.setString(5, user.getUsersTypeId());

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ======================================================
    // ユーザー更新（メールアドレス変更対応版）
    // ======================================================
    /**
     * ユーザー情報を更新します（メールアドレスの変更に対応）
     * @param user 更新後のユーザー情報（新しいメールアドレスを含む）
     * @param oldUserId 更新前のメールアドレス（WHERE句で使用）
     * @return 更新成功時true、失敗時false
     * @throws Exception データベースエラー
     */
    public boolean updateUser(Users user, String oldUserId) throws Exception {
        Connection con = getConnection();

        // ★ user_idも更新対象に追加！
        String sql = "UPDATE users SET user_id = ?, password = ?, user_name = ?, allergen_id = ?::character(3)[] WHERE user_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);

        stmt.setString(1, user.getUserId());  // 新しいメールアドレス
        stmt.setString(2, user.getPassword());
        stmt.setString(3, user.getUserName());

        if (user.getAllergenId() != null && !user.getAllergenId().isEmpty()) {
            String cleanId = user.getAllergenId().replace("{", "").replace("}", "");
            String[] allergenArray = cleanId.split(",");

            java.sql.Array sqlArray = con.createArrayOf("bpchar", allergenArray);
            stmt.setArray(4, sqlArray);
        } else {
            java.sql.Array emptyArray = con.createArrayOf("bpchar", new String[0]);
            stmt.setArray(4, emptyArray);
        }

        stmt.setString(5, oldUserId);  // ★ WHERE句には古いメールアドレスを使用

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ======================================================
    // パスワード更新
    // ======================================================
    public int updatePassword(String userId, String newHashedPassword) throws Exception {

        Connection con = getConnection();

        String sql = "UPDATE users SET password = ? WHERE user_id = ?";

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, newHashedPassword);
        stmt.setString(2, userId);

        int line = stmt.executeUpdate();

        stmt.close();
        con.close();

        return line;
    }

    // ======================================================
    // 一般ユーザ（フィルタなし）
    // ======================================================
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
            user.setCreatedAt(rs.getTimestamp("created_at"));
            list.add(user);
        }

        rs.close();
        stmt.close();
        con.close();

        return list;
    }

    // ======================================================
    // 一般ユーザ詳細
    // ======================================================
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
            user.setCreatedAt(rs.getTimestamp("created_at"));
        }

        rs.close();
        stmt.close();
        con.close();

        return user;
    }

    // ======================================================
    // 一般ユーザ削除
    // ======================================================
    public boolean deleteGeneralUser(String userId) throws Exception {
        Connection con = getConnection();
        String sql = "DELETE FROM users WHERE user_id = ? AND users_type_id = '1'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userId);

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ======================================================
    // 一般ユーザ一覧（フィルタ + ページネーション）
    // ======================================================
    public List<Users> getGeneralUserList(String initial, int offset, int limit) throws Exception {

        List<Users> list = new ArrayList<>();
        Connection con = getConnection();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT user_id, user_name, created_at FROM users WHERE users_type_id = '1' ");

        if (initial != null && !initial.isEmpty()) {

            if (KANA_MAP.containsKey(initial)) {
                sql.append("AND (");
                for (int i = 0; i < KANA_MAP.get(initial).length; i++) {
                    sql.append("user_name LIKE ? ");
                    if (i < KANA_MAP.get(initial).length - 1) sql.append("OR ");
                }
                sql.append(") ");
            } else if (initial.matches("[A-Z]")) {
                sql.append("AND user_name ILIKE ? ");
            }
        }

        sql.append("ORDER BY user_name ASC ");
        sql.append("LIMIT ? OFFSET ? ");

        PreparedStatement stmt = con.prepareStatement(sql.toString());

        int idx = 1;

        if (initial != null && !initial.isEmpty()) {
            if (KANA_MAP.containsKey(initial)) {
                for (String kana : KANA_MAP.get(initial)) {
                    stmt.setString(idx++, kana + "%");
                }
            } else if (initial.matches("[A-Z]")) {
                stmt.setString(idx++, initial + "%");
            }
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

    // ======================================================
    // 一般ユーザ総数
    // ======================================================
    public int getGeneralUserCount(String initial) throws Exception {
        Connection con = getConnection();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM users WHERE users_type_id = '1' ");

        if (initial != null && !initial.isEmpty()) {

            if (KANA_MAP.containsKey(initial)) {
                sql.append("AND (");
                for (int i = 0; i < KANA_MAP.get(initial).length; i++) {
                    sql.append("user_name LIKE ? ");
                    if (i < KANA_MAP.get(initial).length - 1) sql.append("OR ");
                }
                sql.append(") ");
            } else if (initial.matches("[A-Z]")) {
                sql.append("AND user_name ILIKE ? ");
            }
        }

        PreparedStatement stmt = con.prepareStatement(sql.toString());

        int idx = 1;

        if (initial != null && !initial.isEmpty()) {
            if (KANA_MAP.containsKey(initial)) {
                for (String kana : KANA_MAP.get(initial)) {
                    stmt.setString(idx++, kana + "%");
                }
            } else if (initial.matches("[A-Z]")) {
                stmt.setString(idx++, initial + "%");
            }
        }

        ResultSet rs = stmt.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        rs.close();
        stmt.close();
        con.close();

        return count;
    }

    // ======================================================
    // 管理者一覧（フィルタ + ページネーション）
    // ======================================================
    public List<Users> getAdminList(String initial, int offset, int limit) throws Exception {

        List<Users> list = new ArrayList<>();
        Connection con = getConnection();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT user_id, user_name, created_at FROM users WHERE users_type_id = '3' ");

        if (initial != null && !initial.isEmpty()) {

            if (KANA_MAP.containsKey(initial)) {
                sql.append("AND (");
                for (int i = 0; i < KANA_MAP.get(initial).length; i++) {
                    sql.append("user_name LIKE ? ");
                    if (i < KANA_MAP.get(initial).length - 1) sql.append("OR ");
                }
                sql.append(") ");
            } else if (initial.matches("[A-Z]")) {
                sql.append("AND user_name ILIKE ? ");
            }
        }

        sql.append("ORDER BY user_name ASC ");
        sql.append("LIMIT ? OFFSET ? ");

        PreparedStatement stmt = con.prepareStatement(sql.toString());

        int idx = 1;

        if (initial != null && !initial.isEmpty()) {
            if (KANA_MAP.containsKey(initial)) {
                for (String kana : KANA_MAP.get(initial)) {
                    stmt.setString(idx++, kana + "%");
                }
            } else if (initial.matches("[A-Z]")) {
                stmt.setString(idx++, initial + "%");
            }
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

    // ======================================================
    // 管理者総数
    // ======================================================
    public int getAdminCount(String initial) throws Exception {
        Connection con = getConnection();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM users WHERE users_type_id = '3' ");

        if (initial != null && !initial.isEmpty()) {

            if (KANA_MAP.containsKey(initial)) {
                sql.append("AND (");
                for (int i = 0; i < KANA_MAP.get(initial).length; i++) {
                    sql.append("user_name LIKE ? ");
                    if (i < KANA_MAP.get(initial).length - 1) sql.append("OR ");
                }
                sql.append(") ");
            } else if (initial.matches("[A-Z]")) {
                sql.append("AND user_name ILIKE ? ");
            }
        }

        PreparedStatement stmt = con.prepareStatement(sql.toString());

        int idx = 1;

        if (initial != null && !initial.isEmpty()) {
            if (KANA_MAP.containsKey(initial)) {
                for (String kana : KANA_MAP.get(initial)) {
                    stmt.setString(idx++, kana + "%");
                }
            } else if (initial.matches("[A-Z]")) {
                stmt.setString(idx++, initial + "%");
            }
        }

        ResultSet rs = stmt.executeQuery();
        rs.next();
        int cnt = rs.getInt(1);

        rs.close();
        stmt.close();
        con.close();

        return cnt;
    }

    // ======================================================
    // 管理者詳細
    // ======================================================
    public Users getAdminDetail(String userId) throws Exception {
        Users user = null;
        Connection con = getConnection();

        String sql = "SELECT user_id, user_name, created_at FROM users WHERE user_id = ? AND users_type_id = '3'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userId);

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            user = new Users();
            user.setUserId(rs.getString("user_id"));
            user.setUserName(rs.getString("user_name"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
        }

        rs.close();
        stmt.close();
        con.close();

        return user;
    }

    // ======================================================
    // 管理者削除
    // ======================================================
    public boolean deleteAdmin(String userId) throws Exception {
        Connection con = getConnection();
        String sql = "DELETE FROM users WHERE user_id = ? AND users_type_id = '3'";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userId);

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

 // ======================================================
    // メールアドレスの重複チェック
    // ======================================================
    public boolean isEmailExists(String email) throws Exception {
        boolean exists = false;
        Connection con = getConnection();

        String sql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, email);

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            if (rs.getInt(1) > 0) {
                exists = true;
            }
        }

        rs.close();
        stmt.close();
        con.close();

        return exists;
    }

    // ======================================================
    // アカウント情報の統合更新（IDとパスワード）
    // ======================================================
    public int updateUserInfo(String oldId, String newId, String newPass) throws Exception {
        Connection con = getConnection();
        // オートコミットをオフにして、2つのテーブル更新をひとまとめにする
        con.setAutoCommit(false);

        try {
            // 1. shopテーブルのメアド（shop_mail）を更新
            String sqlShop = "UPDATE shop SET shop_mail = ? WHERE shop_mail = ?";
            PreparedStatement stShop = con.prepareStatement(sqlShop);
            stShop.setString(1, newId);  // 新しいメアド
            stShop.setString(2, oldId);  // 現在のメアド
            stShop.executeUpdate();
            stShop.close();

            // 2. usersテーブルのメアドとパスワードを更新
            String sqlUser = "UPDATE users SET user_id = ?, password = ? WHERE user_id = ?";
            PreparedStatement stUser = con.prepareStatement(sqlUser);
            stUser.setString(1, newId);
            stUser.setString(2, newPass);
            stUser.setString(3, oldId);
            int line = stUser.executeUpdate();
            stUser.close();

            // 両方成功したら確定！
            con.commit();
            return line;

        } catch (Exception e) {
            // どこかでエラーが出たら、ここまでの処理をすべてキャンセルして元に戻す
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }

}
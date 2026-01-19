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
    // ユーザー更新
    // ======================================================
    public boolean updateUser(Users user) throws Exception {
        Connection con = getConnection();

        // PostgreSQL側で明示的にキャスト (::character(3)[]) を行うとより確実です
        String sql = "UPDATE users SET password = ?, user_name = ?, allergen_id = ?::character(3)[] WHERE user_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);

        stmt.setString(1, user.getPassword());
        stmt.setString(2, user.getUserName());

        if (user.getAllergenId() != null && !user.getAllergenId().isEmpty()) {
            String cleanId = user.getAllergenId().replace("{", "").replace("}", "");
            String[] allergenArray = cleanId.split(",");

            // "character" ではなく "bpchar" を指定する
            java.sql.Array sqlArray = con.createArrayOf("bpchar", allergenArray);
            stmt.setArray(3, sqlArray);
        } else {
            // こちらも同様に "bpchar"
            java.sql.Array emptyArray = con.createArrayOf("bpchar", new String[0]);
            stmt.setArray(3, emptyArray);
        }

        stmt.setString(4, user.getUserId());

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
    public boolean deleteUser(String userId) throws Exception {

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
    // 一般ユーザ一覧（フィルタあり + ページネーション）
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
    // 一般ユーザ数
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

}

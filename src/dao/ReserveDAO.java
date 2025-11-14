package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import bean.Reserve;

public class ReserveDAO extends DAO {

    // 予約登録（承認待ちで登録）
    public boolean createReservation(Reserve reserve) throws Exception {
        Connection con = getConnection();

        String sql = "INSERT INTO reserve (reserve_id, user_id, shop_id, reserve_date, reserve_time, "
                   + "reserve_count, reserve_allergy, reserve_seat, reserve_note, reserve_send, reserve_status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, 1)";
        PreparedStatement stmt = con.prepareStatement(sql);

        // UUIDを自動生成してreserve_idに設定
        String uuid = UUID.randomUUID().toString();
        stmt.setString(1, uuid);
        stmt.setString(2, reserve.getUserId());
        stmt.setString(3, reserve.getShopId());
        stmt.setDate(4, reserve.getVisitDate());
        stmt.setTime(5, reserve.getVisitTime());
        stmt.setInt(6, reserve.getNumOfPeople());
        stmt.setString(7, reserve.getAllergyNotes());
        stmt.setString(8, "未指定"); // NOT NULL制約対応
        stmt.setString(9, reserve.getMessage());

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ユーザーごとの予約一覧取得
    public List<Reserve> findByUser(String userId) throws Exception {
        List<Reserve> list = new ArrayList<>();
        Connection con = getConnection();

        String sql = "SELECT r.reserve_id, r.user_id, r.shop_id, r.reserve_date, r.reserve_time, "
                   + "r.reserve_count, r.reserve_allergy, r.reserve_note, r.reserve_send, "
                   + "r.reserve_status, s.shop_name "
                   + "FROM reserve r JOIN shop s ON r.shop_id = s.shop_id "
                   + "WHERE r.user_id = ? ORDER BY r.reserve_date, r.reserve_time";

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            list.add(mapReserve(rs));
        }

        rs.close();
        stmt.close();
        con.close();

        return list;
    }

    // 店舗ごとの予約一覧取得
    public List<Reserve> findByShop(String shopId) throws Exception {
        List<Reserve> list = new ArrayList<>();
        Connection con = getConnection();

        String sql = "SELECT r.reserve_id, r.user_id, r.shop_id, r.reserve_date, r.reserve_time, "
                   + "r.reserve_count, r.reserve_allergy, r.reserve_note, r.reserve_send, "
                   + "r.reserve_status, s.shop_name "
                   + "FROM reserve r JOIN shop s ON r.shop_id = s.shop_id "
                   + "WHERE r.shop_id = ? ORDER BY r.reserve_date, r.reserve_time";

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, shopId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            list.add(mapReserve(rs));
        }

        rs.close();
        stmt.close();
        con.close();

        return list;
    }

    // ステータス更新（店舗側から承認・拒否などを変更する用）
    public boolean updateReserveStatus(String reserveId, int status) throws Exception {
        Connection con = getConnection();
        String sql = "UPDATE reserve SET reserve_status = ? WHERE reserve_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, status);
        stmt.setString(2, reserveId);

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ResultSet → Reserve オブジェクトへ変換
    private Reserve mapReserve(ResultSet rs) throws Exception {
        Reserve reserve = new Reserve();

        reserve.setReserveId(0);
        reserve.setUserId(rs.getString("user_id"));
        reserve.setShopId(rs.getString("shop_id"));
        reserve.setVisitDate(rs.getDate("reserve_date"));
        reserve.setVisitTime(rs.getTime("reserve_time"));
        reserve.setNumOfPeople(rs.getInt("reserve_count"));
        reserve.setAllergyNotes(rs.getString("reserve_allergy"));
        reserve.setMessage(rs.getString("reserve_note"));
        reserve.setStatus(String.valueOf(rs.getTimestamp("reserve_send"))); // 送信日時をstatusに保持
        reserve.setReserveStatus(rs.getInt("reserve_status"));
        reserve.setShopName(rs.getString("shop_name"));

        return reserve;
    }
}

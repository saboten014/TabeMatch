package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import bean.Reserve;

public class ReserveDAO extends DAO {

    // 予約登録（create）
    public boolean createReservation(Reserve reserve) throws Exception {
        Connection con = getConnection();

        // reserve テーブルに合わせて修正
        String sql = "INSERT INTO reserve (reserve_id, user_id, shop_id, reserve_date, reserve_time, "
                   + "reserve_count, reserve_allergy, reserve_seat, reserve_note, reserve_send) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        PreparedStatement stmt = con.prepareStatement(sql);

        // reserve_id は varchar(30) 型なので String 扱いが安全
        stmt.setString(1, String.valueOf(reserve.getReserveId()));
        stmt.setString(2, reserve.getUserId());
        stmt.setString(3, reserve.getShopId());
        stmt.setDate(4, reserve.getVisitDate());
        stmt.setTime(5, reserve.getVisitTime());
        stmt.setInt(6, reserve.getNumOfPeople());
        stmt.setString(7, reserve.getAllergyNotes());
        stmt.setString(8, "未指定"); // reserve_seat は NOT NULL のため仮値
        stmt.setString(9, reserve.getMessage());

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ユーザーIDで予約を取得
    public List<Reserve> findByUser(String userId) throws Exception {
        List<Reserve> list = new ArrayList<>();
        Connection con = getConnection();

        String sql = "SELECT r.reserve_id, r.user_id, r.shop_id, r.reserve_date, r.reserve_time, "
                   + "r.reserve_count, r.reserve_allergy, r.reserve_note, r.reserve_send, s.shop_name "
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

    // 店舗IDで予約を取得
    public List<Reserve> findByShop(String shopId) throws Exception {
        List<Reserve> list = new ArrayList<>();
        Connection con = getConnection();

        String sql = "SELECT r.reserve_id, r.user_id, r.shop_id, r.reserve_date, r.reserve_time, "
                   + "r.reserve_count, r.reserve_allergy, r.reserve_note, r.reserve_send, s.shop_name "
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

    // （任意）予約ステータス更新 → 今回は reserve_send を更新対象にする例
    public boolean updateSendTime(String reserveId) throws Exception {
        Connection con = getConnection();
        String sql = "UPDATE reserve SET reserve_send = CURRENT_TIMESTAMP WHERE reserve_id = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, reserveId);

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        return result > 0;
    }

    // ResultSet → Reserve オブジェクトへマッピング
    private Reserve mapReserve(ResultSet rs) throws Exception {
        Reserve reserve = new Reserve();

        reserve.setReserveId(Integer.parseInt(rs.getString("reserve_id"))); // reserve_id は varchar(30)
        reserve.setUserId(rs.getString("user_id"));
        reserve.setShopId(rs.getString("shop_id"));
        Date visitDate = rs.getDate("reserve_date");
        Time visitTime = rs.getTime("reserve_time");
        reserve.setVisitDate(visitDate);
        reserve.setVisitTime(visitTime);
        reserve.setNumOfPeople(rs.getInt("reserve_count"));
        reserve.setAllergyNotes(rs.getString("reserve_allergy"));
        reserve.setMessage(rs.getString("reserve_note"));
        reserve.setStatus(String.valueOf(rs.getTimestamp("reserve_send"))); // 仮：送信日時を status に格納
        reserve.setShopName(rs.getString("shop_name"));

        return reserve;
    }
}

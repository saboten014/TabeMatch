package tabematch.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.DAO;
import tool.Action;

public class AdminShopEditRequestApproveAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();

        // 1. 管理者権限チェック
        Users admin = (Users) session.getAttribute("user");
        if (admin == null || !"3".equals(admin.getUsersTypeId())) {
            session.setAttribute("errorMessage", "管理者権限が必要です。");
            res.sendRedirect(req.getContextPath() + "/tabematch/login.jsp");
            return;
        }

        // 2. リクエストIDを取得
        String requestId = req.getParameter("requestId");

        if (requestId == null || requestId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "リクエストIDが指定されていません。");
            res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
            return;
        }

        DAO dao = new DAO();
        Connection con = dao.getConnection();

        try {
            // トランザクション開始
            con.setAutoCommit(false);

            // 3. 編集リクエスト情報を取得
            String selectSql = "SELECT * FROM shop_edit_requests WHERE request_id = ? AND status = 1";
            PreparedStatement selectStmt = con.prepareStatement(selectSql);
            selectStmt.setString(1, requestId);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                session.setAttribute("errorMessage", "該当するリクエストが見つかりません。");
                rs.close();
                selectStmt.close();
                con.rollback();
                con.close();
                res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
                return;
            }

            // リクエストデータを取得
            String shopId = rs.getString("shop_id");
            String shopName = rs.getString("shop_name");
            String shopAddress = rs.getString("shop_address");
            String shopTel = rs.getString("shop_tel");
            String shopUrl = rs.getString("shop_url");
            String shopTime = rs.getString("shop_time");
            String shopAllergy = rs.getString("shop_allergy");
            String shopGenre = rs.getString("shop_genre");
            String shopPrice = rs.getString("shop_price");
            String shopPay = rs.getString("shop_pay");
            Integer shopSeat = rs.getInt("shop_seat");
            String shopReserve = rs.getString("shop_reserve");

            rs.close();
            selectStmt.close();

         // 4. shop テーブルを更新
            String updateShopSql = "UPDATE shop SET " +
                                   "shop_name = ?, shop_address = ?, shop_tel = ?, " +
                                   "shop_url = ?, shop_allergy = ?, shop_genre = ?, " +
                                   "shop_price = ?, shop_pay = ?, shop_seat = ?, " +
                                   "shop_reserve = ?, shop_time = ? " +
                                   "WHERE shop_id = ?";

            PreparedStatement updateShopStmt = con.prepareStatement(updateShopSql);
            updateShopStmt.setString(1, shopName);
            updateShopStmt.setString(2, shopAddress);
            updateShopStmt.setString(3, shopTel);
            updateShopStmt.setString(4, shopUrl);
            updateShopStmt.setString(5, shopAllergy);
            updateShopStmt.setString(6, shopGenre);
            updateShopStmt.setString(7, shopPrice);
            updateShopStmt.setString(8, shopPay);
            updateShopStmt.setInt(9, shopSeat);
            updateShopStmt.setString(10, shopReserve);
            updateShopStmt.setString(11, shopTime);
            updateShopStmt.setString(12, shopId);

            int updateResult = updateShopStmt.executeUpdate();
            updateShopStmt.close();

            if (updateResult == 0) {
                session.setAttribute("errorMessage", "店舗情報の更新に失敗しました。");
                con.rollback();
                con.close();
                res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
                return;
            }

            // 5. リクエストのステータスを承認済み(2)に変更
            String updateRequestSql = "UPDATE shop_edit_requests SET status = 2 WHERE request_id = ?";
            PreparedStatement updateRequestStmt = con.prepareStatement(updateRequestSql);
            updateRequestStmt.setString(1, requestId);
            updateRequestStmt.executeUpdate();
            updateRequestStmt.close();

            // コミット
            con.commit();

            session.setAttribute("successMessage", "編集リクエストを承認し、店舗情報を更新しました。");

        } catch (Exception e) {
            // エラー時はロールバック
            if (con != null) {
                con.rollback();
            }
            e.printStackTrace();
            session.setAttribute("errorMessage", "処理中にエラーが発生しました：" + e.getMessage());
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }

        res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
    }
}
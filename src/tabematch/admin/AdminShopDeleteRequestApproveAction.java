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

public class AdminShopDeleteRequestApproveAction extends Action {

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
            res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopDeleteRequestList.action");
            return;
        }

        DAO dao = new DAO();
        Connection con = dao.getConnection();

        try {
            // トランザクション開始
            con.setAutoCommit(false);

            // 3. 削除リクエスト情報を取得
            String selectSql = "SELECT shop_id FROM shop_delete_requests WHERE request_id = ? AND status = 1";
            PreparedStatement selectStmt = con.prepareStatement(selectSql);
            selectStmt.setString(1, requestId);
            ResultSet rs = selectStmt.executeQuery();

            if (!rs.next()) {
                session.setAttribute("errorMessage", "該当するリクエストが見つかりません。");
                rs.close();
                selectStmt.close();
                con.rollback();
                con.close();
                res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopDeleteRequestList.action");
                return;
            }

            String shopId = rs.getString("shop_id");
            rs.close();
            selectStmt.close();

            // 4. 店舗のメールアドレスを取得（ユーザーアカウント削除用）
            String getMailSql = "SELECT shop_mail FROM shop WHERE shop_id = ?";
            PreparedStatement getMailStmt = con.prepareStatement(getMailSql);
            getMailStmt.setString(1, shopId);
            ResultSet mailRs = getMailStmt.executeQuery();

            String shopMail = null;
            if (mailRs.next()) {
                shopMail = mailRs.getString("shop_mail");
            }
            mailRs.close();
            getMailStmt.close();

            // 5. 関連データを削除（外部キー制約の順序に注意）

            // レビューコメント削除（review_comment → review）
            String deleteCommentSql = "DELETE FROM review_comment WHERE review_id IN " +
                                     "(SELECT review_id FROM review WHERE shop_id = ?)";
            PreparedStatement deleteCommentStmt = con.prepareStatement(deleteCommentSql);
            deleteCommentStmt.setString(1, shopId);
            deleteCommentStmt.executeUpdate();
            deleteCommentStmt.close();

            // レビューいいね削除（review_like → review）
            String deleteLikeSql = "DELETE FROM review_like WHERE review_id IN " +
                                  "(SELECT review_id FROM review WHERE shop_id = ?)";
            PreparedStatement deleteLikeStmt = con.prepareStatement(deleteLikeSql);
            deleteLikeStmt.setString(1, shopId);
            deleteLikeStmt.executeUpdate();
            deleteLikeStmt.close();

            // レビュー写真削除（review_photo → review）
            String deletePhotoSql = "DELETE FROM review_photo WHERE review_id IN " +
                                   "(SELECT review_id FROM review WHERE shop_id = ?)";
            PreparedStatement deletePhotoStmt = con.prepareStatement(deletePhotoSql);
            deletePhotoStmt.setString(1, shopId);
            deletePhotoStmt.executeUpdate();
            deletePhotoStmt.close();

            // レビュー削除
            String deleteReviewSql = "DELETE FROM review WHERE shop_id = ?";
            PreparedStatement deleteReviewStmt = con.prepareStatement(deleteReviewSql);
            deleteReviewStmt.setString(1, shopId);
            deleteReviewStmt.executeUpdate();
            deleteReviewStmt.close();

            // 予約削除
            String deleteReserveSql = "DELETE FROM reserve WHERE shop_id = ?";
            PreparedStatement deleteReserveStmt = con.prepareStatement(deleteReserveSql);
            deleteReserveStmt.setString(1, shopId);
            deleteReserveStmt.executeUpdate();
            deleteReserveStmt.close();

            // お気に入り削除
            String deleteFavoriteSql = "DELETE FROM favorite WHERE fav_shop_id = ?";
            PreparedStatement deleteFavoriteStmt = con.prepareStatement(deleteFavoriteSql);
            deleteFavoriteStmt.setString(1, shopId);
            deleteFavoriteStmt.executeUpdate();
            deleteFavoriteStmt.close();

            // 店舗編集リクエスト削除
            String deleteEditReqSql = "DELETE FROM shop_edit_requests WHERE shop_id = ?";
            PreparedStatement deleteEditReqStmt = con.prepareStatement(deleteEditReqSql);
            deleteEditReqStmt.setString(1, shopId);
            deleteEditReqStmt.executeUpdate();
            deleteEditReqStmt.close();

            // 店舗削除リクエスト削除（このリクエストも含めて全部削除）
            String deleteDelReqSql = "DELETE FROM shop_delete_requests WHERE shop_id = ?";
            PreparedStatement deleteDelReqStmt = con.prepareStatement(deleteDelReqSql);
            deleteDelReqStmt.setString(1, shopId);
            deleteDelReqStmt.executeUpdate();
            deleteDelReqStmt.close();

            // 6. shopテーブルから削除
            String deleteShopSql = "DELETE FROM shop WHERE shop_id = ?";
            PreparedStatement deleteShopStmt = con.prepareStatement(deleteShopSql);
            deleteShopStmt.setString(1, shopId);
            int shopDeleteResult = deleteShopStmt.executeUpdate();
            deleteShopStmt.close();

            if (shopDeleteResult == 0) {
                session.setAttribute("errorMessage", "店舗の削除に失敗しました。");
                con.rollback();
                con.close();
                res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopDeleteRequestList.action");
                return;
            }

            // 7. usersテーブルから店舗ユーザーアカウントを削除
            if (shopMail != null) {
                String deleteUserSql = "DELETE FROM users WHERE user_id = ? AND users_type_id = '2'";
                PreparedStatement deleteUserStmt = con.prepareStatement(deleteUserSql);
                deleteUserStmt.setString(1, shopMail);
                deleteUserStmt.executeUpdate();
                deleteUserStmt.close();
            }

            // コミット
            con.commit();

            session.setAttribute("successMessage", "削除リクエストを承認し、店舗とアカウントを削除しました。");

        } catch (Exception e) {
            // エラー時はロールバック
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace();
            session.setAttribute("errorMessage", "処理中にエラーが発生しました：" + e.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }

        res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopDeleteRequestList.action");
    }
}
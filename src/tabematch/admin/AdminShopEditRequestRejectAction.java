package tabematch.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.DAO;
import tool.Action;

public class AdminShopEditRequestRejectAction extends Action {

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

        // 2. パラメータ取得
        String requestId = req.getParameter("requestId");
        String rejectReason = req.getParameter("rejectReason");

        if (requestId == null || requestId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "リクエストIDが指定されていません。");
            res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
            return;
        }

        if (rejectReason == null || rejectReason.trim().isEmpty()) {
            session.setAttribute("errorMessage", "却下理由を入力してください。");
            res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
            return;
        }

        // 3. リクエストのステータスを却下(3)に変更
        DAO dao = new DAO();
        Connection con = dao.getConnection();

        String sql = "UPDATE shop_edit_requests SET status = 3 WHERE request_id = ? AND status = 1";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, requestId);

        int result = stmt.executeUpdate();

        stmt.close();
        con.close();

        if (result > 0) {
            session.setAttribute("successMessage", "編集リクエストを却下しました。");
            // TODO: ここでメール通知を送信する処理を追加
        } else {
            session.setAttribute("errorMessage", "リクエストの却下に失敗しました。");
        }

        res.sendRedirect(req.getContextPath() + "/tabematch/admin/AdminShopEditRequestList.action");
    }
}
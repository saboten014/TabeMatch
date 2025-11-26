package tabematch.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.DAO;
import tool.Action;

public class AdminShopDeleteRequestListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();
        String url = "";

        // 1. 管理者権限チェック
        Users admin = (Users) session.getAttribute("user");
        if (admin == null || !"3".equals(admin.getUsersTypeId())) {
            req.setAttribute("errorMessage", "管理者権限が必要です。");
            url = "/tabematch/login.jsp";
            req.getRequestDispatcher(url).forward(req, res);
            return;
        }

        // 2. DBから削除リクエスト一覧を取得（status=1:申請中のみ）
        DAO dao = new DAO();
        Connection con = dao.getConnection();

        String sql = "SELECT dr.*, s.shop_name, s.shop_address, s.shop_tel, s.shop_mail " +
                     "FROM shop_delete_requests dr " +
                     "INNER JOIN shop s ON dr.shop_id = s.shop_id " +
                     "WHERE dr.status = 1 " +
                     "ORDER BY dr.created_at DESC";

        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        List<Map<String, Object>> deleteRequestList = new ArrayList<>();

        while (rs.next()) {
            Map<String, Object> request = new HashMap<>();
            request.put("requestId", rs.getString("request_id"));
            request.put("shopId", rs.getString("shop_id"));
            request.put("shopName", rs.getString("shop_name"));
            request.put("shopAddress", rs.getString("shop_address"));
            request.put("shopTel", rs.getString("shop_tel"));
            request.put("shopMail", rs.getString("shop_mail"));
            request.put("deleteReason", rs.getString("delete_reason"));
            request.put("createdAt", rs.getTimestamp("created_at"));

            deleteRequestList.add(request);
        }

        rs.close();
        stmt.close();
        con.close();

        // 3. JSPにデータを渡す
        req.setAttribute("deleteRequestList", deleteRequestList);
        url = "/tabematch/admin/admin-shop-delete-request-list.jsp";

        req.getRequestDispatcher(url).forward(req, res);
    }
}
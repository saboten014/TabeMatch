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

public class AdminShopEditRequestListAction extends Action {

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

        // 2. DBから編集リクエスト一覧を取得（status=1:申請中のみ）
        DAO dao = new DAO();
        Connection con = dao.getConnection();

        String sql = "SELECT er.*, s.shop_name as current_shop_name " +
                     "FROM shop_edit_requests er " +
                     "INNER JOIN shop s ON er.shop_id = s.shop_id " +
                     "WHERE er.status = 1 " +
                     "ORDER BY er.created_at DESC";

        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        List<Map<String, Object>> editRequestList = new ArrayList<>();

        while (rs.next()) {
            Map<String, Object> request = new HashMap<>();
            request.put("requestId", rs.getString("request_id"));
            request.put("shopId", rs.getString("shop_id"));
            request.put("currentShopName", rs.getString("current_shop_name"));
            request.put("newShopName", rs.getString("shop_name"));
            request.put("shopAddress", rs.getString("shop_address"));
            request.put("shopTel", rs.getString("shop_tel"));
            request.put("shopUrl", rs.getString("shop_url"));
            request.put("shopAllergy", rs.getString("shop_allergy"));
            request.put("shopGenre", rs.getString("shop_genre"));
            request.put("shopPrice", rs.getString("shop_price"));
            request.put("shopPay", rs.getString("shop_pay"));
            request.put("shopSeat", rs.getInt("shop_seat"));
            request.put("shopReserve", rs.getString("shop_reserve"));
            request.put("requestNote", rs.getString("request_note"));
            request.put("createdAt", rs.getTimestamp("created_at"));

            editRequestList.add(request);
        }

        rs.close();
        stmt.close();
        con.close();

        // 3. JSPにデータを渡す
        req.setAttribute("editRequestList", editRequestList);
        url = "/tabematch/admin/admin-shop-edit-request-list.jsp";

        req.getRequestDispatcher(url).forward(req, res);
    }
}
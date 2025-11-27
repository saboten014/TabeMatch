package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminAdminDetailAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String userId = req.getParameter("userId");

        UserDAO dao = new UserDAO();
        Users admin = dao.getAdminDetail(userId);

        if (admin == null) {
            req.setAttribute("errorMessage", "該当管理者が見つかりません。");
            req.getRequestDispatcher("../../error.jsp").forward(req, res);
            return;
        }

        // セッションからログイン中の管理者IDを取得しておく（削除ボタンの制御で利用可）
        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");
        String loginUserId = (loginUser != null) ? loginUser.getUserId() : null;

        req.setAttribute("admin", admin);
        req.setAttribute("loginUserId", loginUserId);

        req.getRequestDispatcher("/tabematch/admin/admin-admin-detail.jsp").forward(req, res);
    }
}

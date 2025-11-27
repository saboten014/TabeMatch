package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminAdminDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String targetUserId = req.getParameter("userId");

        HttpSession session = req.getSession();
        Users loginUser = (Users) session.getAttribute("user");

        // 権限チェック（管理者であること）
        if (loginUser == null || !"3".equals(loginUser.getUsersTypeId())) {
            req.setAttribute("errorMessage", "権限がありません。");
            req.getRequestDispatcher("../../error.jsp").forward(req, res);
            return;
        }

        // 自分自身は削除不可（要件 D）
        if (loginUser.getUserId().equals(targetUserId)) {
            req.setAttribute("errorMessage", "自分自身の管理者アカウントは削除できません。");
            req.getRequestDispatcher("/tabematch/admin/admin-admin-delete-complete.jsp").forward(req, res);
            return;
        }

        UserDAO dao = new UserDAO();

        // 最後の管理者を削除しない（要件 D）
        int totalAdmins = dao.getAdminCount(null);
        if (totalAdmins <= 1) {
            req.setAttribute("errorMessage", "最後の管理者は削除できません。");
            req.getRequestDispatcher("/tabematch/admin/admin-admin-delete-complete.jsp").forward(req, res);
            return;
        }

        boolean result = dao.deleteAdmin(targetUserId);
        if (result) {
            req.setAttribute("successMessage", "管理者アカウントを削除しました。");
        } else {
            req.setAttribute("errorMessage", "削除に失敗しました。");
        }

        req.getRequestDispatcher("/tabematch/admin/admin-admin-delete-complete.jsp").forward(req, res);
    }
}

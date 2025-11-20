package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.UserDAO;
import tool.Action;

public class AdminUserDeleteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String userId = req.getParameter("userId");

        UserDAO dao = new UserDAO();
        boolean result = dao.deleteUser(userId);

        if (result) {
            req.setAttribute("successMessage", "ユーザーを削除しました。");
        } else {
            req.setAttribute("errorMessage", "削除に失敗しました。");
        }

        req.getRequestDispatcher("admin-user-delete-complete.jsp").forward(req, res);
    }
}

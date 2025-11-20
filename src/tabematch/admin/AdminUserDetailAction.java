package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminUserDetailAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String userId = req.getParameter("userId");

        UserDAO dao = new UserDAO();
        Users user = dao.getGeneralUserDetail(userId);

        if (user == null) {
            req.setAttribute("errorMessage", "該当ユーザーが見つかりません。");
            req.getRequestDispatcher("../../error.jsp").forward(req, res);
            return;
        }

        req.setAttribute("user", user);

        req.getRequestDispatcher("admin-user-detail.jsp").forward(req, res);
    }
}

package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminUserDeleteConfirmAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String userId = req.getParameter("userId");

        req.setAttribute("userId", userId);

        req.getRequestDispatcher("admin-user-delete-confirm.jsp").forward(req, res);
    }
}

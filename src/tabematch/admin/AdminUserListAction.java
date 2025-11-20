package tabematch.admin;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminUserListAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserDAO dao = new UserDAO();
        List<Users> list = dao.getGeneralUserList();

        req.setAttribute("userList", list);

        req.getRequestDispatcher("admin-user-list.jsp").forward(req, res);
    }
}

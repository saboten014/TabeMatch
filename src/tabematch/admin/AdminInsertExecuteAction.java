package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class AdminInsertExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 入力値を取得
        String userId = req.getParameter("userId");
        String password = req.getParameter("password");
        String userName = req.getParameter("userName");

        // ★管理者ユーザーを生成（usersTypeId = 3）
        Users admin = new Users();
        admin.setUserId(userId);
        admin.setPassword(password);
        admin.setUserName(userName);
        admin.setUsersTypeId("3");  // ★管理者
        admin.setAllergenId(null);  // ★アレルギー情報は常に空扱い

        UserDAO dao = new UserDAO();
        boolean result = dao.registerUser(admin);

        if (result) {
            req.setAttribute("message", "管理者アカウントを登録しました。");
        } else {
            req.setAttribute("message", "登録に失敗しました。");
        }

        // 完了画面へ遷移
        req.getRequestDispatcher("admin-insert-complete.jsp")
           .forward(req, res);
    }
}

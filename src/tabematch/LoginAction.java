package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import tool.Action;

public class LoginAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // セッションを取得
        HttpSession session = req.getSession(false);

        // すでにログインしている場合は、そのユーザーの種別に応じてリダイレクト
        if (session != null && session.getAttribute("user") != null) {
            Users user = (Users) session.getAttribute("user");
            String usersTypeId = user.getUsersTypeId();

            if ("1".equals(usersTypeId)) {
                // 一般ユーザー → 検索ページへ
                res.sendRedirect(req.getContextPath() + "/tabematch/main/search.jsp");
                return;
            } else if ("2".equals(usersTypeId)) {
                // 店舗ユーザー → 店舗管理画面へ
                res.sendRedirect(req.getContextPath() + "");
                return;
            } else if ("3".equals(usersTypeId)) {
                // 管理ユーザー → 管理者ホームへ
                res.sendRedirect(req.getContextPath() + "/tabematch/main/admin_home.jsp");
                return;
            }
        }

        // ここまで来たら未ログインなので、ログイン画面を表示
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }
}

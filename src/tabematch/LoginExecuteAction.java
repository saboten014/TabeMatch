package tabematch;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.Users;
import dao.UserDAO;
import tool.Action;

public class LoginExecuteAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        HttpSession session = req.getSession();
        UserDAO userDao = new UserDAO();

        // リクエストパラメータ―の取得
        String userId = req.getParameter("login");
        String password = req.getParameter("password");

        if (userId == null || userId.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            // 入力がない場合 → forwardでOK（エラー表示）
            req.setAttribute("errorMessage", "ユーザーIDとパスワードを入力してください。");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // ログイン認証
        Users user = userDao.login(userId, password);

        if (user != null) {
            // ログイン成功
            session.setAttribute("user", user);

            // ユーザー区分によって遷移先を変更（redirectに変更）
            String usersTypeId = user.getUsersTypeId();

            if ("1".equals(usersTypeId)) {
                // 一般ユーザー → 検索画面
                res.sendRedirect(req.getContextPath() + "/tabematch/main/search.jsp");
            }else if ("2".equals(usersTypeId)) {
                // 店舗ユーザー → 店舗情報管理画面
                res.sendRedirect(req.getContextPath() + "/tabematch/shop/ShopManagement.action");
            } else if ("3".equals(usersTypeId)) {
                // 管理ユーザー → 管理画面トップページ
                res.sendRedirect(req.getContextPath() + "/tabematch/main/admin_home.jsp");
            } else {
                // 想定外の区分ID
                res.sendRedirect(req.getContextPath() + "/tabematch/main/top.jsp");
            }
        } else {
            // ログイン失敗 → forwardでOK（エラー表示）
            req.setAttribute("errorMessage", "メールアドレスまたはパスワードが間違っています。");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
    }
}
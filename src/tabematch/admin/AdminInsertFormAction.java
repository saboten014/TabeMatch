package tabematch.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tool.Action;

public class AdminInsertFormAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // ★管理者アカウント登録フォームへ遷移
        req.getRequestDispatcher("../admin/admin-insert-form.jsp")
           .forward(req, res);
    }
}
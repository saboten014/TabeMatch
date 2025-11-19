package tabematch.main;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import tool.Action;

public class LogoutAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {
        // ローカル変数
        String url = "";

        // セッション取得
        HttpSession session = req.getSession(false); // すでにある場合のみ取得

        // セッション破棄
        if (session != null && session.getAttribute("user") != null) {
            session.invalidate();
        }

        // ログアウト完了画面へ
        url = "logout.jsp";
        req.getRequestDispatcher(url).forward(req, res);
    }
}

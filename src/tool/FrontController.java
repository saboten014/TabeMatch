package tool;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "*.action" })
public class FrontController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            // パスを取得
            String path = req.getServletPath().substring(1); // e.g. tabematch/main/UserProfileView.action

            // ".action" → "Action" に置換してクラス名化
            String name = path.replace(".action", "Action").replace('/', '.');
            // e.g. tabematch.main.UserProfileViewAction

            // アクションクラスを生成して実行
            Action action = (Action) Class.forName(name).getDeclaredConstructor().newInstance();
            action.execute(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.getRequestDispatcher("/error.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }
}

package tool;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // 追加
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = { "*.action" })
// ★このアノテーションを追加することで、ファイルの受け取りが許可されます
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,      // 1ファイル最大5MB
    maxRequestSize = 1024 * 1024 * 10   // リクエスト全体最大10MB
)
public class FrontController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            // パスを取得
            String path = req.getServletPath().substring(1);

            // ".action" → "Action" に置換してクラス名化
            String name = path.replace(".action", "Action").replace('/', '.');

            // アクションクラスを生成して実行
            Action action = (Action) Class.forName(name).getDeclaredConstructor().newInstance();
            action.execute(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            // エラー時もエラー内容がわかるようにスタックトレースを表示
            req.getRequestDispatcher("/error.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }
}
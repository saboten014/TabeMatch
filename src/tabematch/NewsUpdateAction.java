package tabematch;

import java.sql.Timestamp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import bean.News;
import bean.Users;
import dao.NewsDAO;
import tool.Action;

public class NewsUpdateAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession();

        // 1. 管理者権限チェック（セキュリティのため再確認）
        Users user = (Users)session.getAttribute("user");
        if (user == null || !"3".equals(user.getUsersTypeId())) {
            session.setAttribute("errorMessage", "管理者権限が必要です。");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2. パラメータの取得とBeanへのセット
        News news = new News();
        NewsDAO dao = new NewsDAO();
        String newsIdStr = req.getParameter("news_id");

        // IDの存在チェック
        if (newsIdStr == null || newsIdStr.isEmpty()) {
             session.setAttribute("message", "更新対象のIDが指定されていません。");
             res.sendRedirect(req.getContextPath() + "/tabematch/News.action");
             return;
        }

        try {
            // IDは整数型に変換
            news.setNewsId(Integer.parseInt(newsIdStr));

            // その他のパラメータを取得
            news.setNewsTitle(req.getParameter("news_title"));
            news.setNewsText(req.getParameter("news_text"));
            news.setRole(req.getParameter("role"));

            // 3. 編集日を現在時刻に設定
            news.setEditDate(new Timestamp(System.currentTimeMillis()));

            // 4. DAOで更新処理を実行
            boolean success = dao.update(news);

            // 5. 結果に基づいてメッセージをセット
            if (success) {
                session.setAttribute("message", "お知らせが正常に更新されました。");
            } else {
                session.setAttribute("message", "お知らせの更新に失敗しました。");
            }

        } catch (NumberFormatException e) {
            // IDが数値でない場合の例外処理
            session.setAttribute("message", "お知らせIDの形式が不正です。");
        } catch (Exception e) {
            // その他のデータベース例外処理
            session.setAttribute("message", "データベースエラーにより更新に失敗しました。");
        }

        // 6. 処理後、一覧画面にリダイレクト
        res.sendRedirect(req.getContextPath() + "/tabematch/News.action");
    }
}
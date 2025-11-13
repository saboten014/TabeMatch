package tabematch;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.News;
import dao.NewsDAO;
import tool.Action;

public class NewsDetailAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 1. リクエストパラメータ（news_id）の取得
        String newsIdStr = req.getParameter("news_id"); // Stringとして取得
        int newsId = 0; // 整数型IDを保持

        if (newsIdStr == null || newsIdStr.isEmpty()) {
            req.setAttribute("error_message", "表示するお知らせが指定されていません。");
            RequestDispatcher dispatcher = req.getRequestDispatcher("error.jsp"); // パスは適切に修正してください
            dispatcher.forward(req, res);
            return;
        }

        try {
            // ★Stringからintへの変換
            newsId = Integer.parseInt(newsIdStr);
        } catch (NumberFormatException e) {
            // 数値に変換できなかった場合もエラー処理
            req.setAttribute("error_message", "不正なID形式が指定されました。");
            RequestDispatcher dispatcher = req.getRequestDispatcher("error.jsp"); // パスは適切に修正してください
            dispatcher.forward(req, res);
            return;
        }

        // 2. DAOを使ってデータ（News Bean）を取得
        NewsDAO newsDao = new NewsDAO();
        // ★DAOのメソッドには int型のIDを渡す
        News news = newsDao.findById(newsId);

        if (news == null) {
            req.setAttribute("error_message", "指定されたID (" + newsId + ") のお知らせは見つかりませんでした。");
            RequestDispatcher dispatcher = req.getRequestDispatcher("error.jsp"); // パスは適切に修正してください
            dispatcher.forward(req, res);
            return;
        }

        // 3. 取得したデータをリクエストスコープにセット
        req.setAttribute("news_detail", news);

        // 4. 詳細表示用JSPへフォワード
        // パスは適切に修正してください (例: /tabematch/main/news_detail.jsp)
        RequestDispatcher dispatcher = req.getRequestDispatcher("/tabematch/main/news_detail.jsp");
        dispatcher.forward(req, res);
    }
}
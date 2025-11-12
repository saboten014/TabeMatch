package tabematch;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.News;
import dao.NewsDAO;
import tool.Action; // tool.Action を継承

public class NewsDetailAction extends Action {

    @Override
    public void execute(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        // 1. リクエストパラメータ（news_id）の取得
        // news_list.jspで設定したパラメータ名 'news_id' を使用
        String newsId = req.getParameter("news_id");

        if (newsId == null || newsId.isEmpty()) {
            // IDがない場合はエラー処理または一覧へリダイレクト
            // 今回はシンプルにエラーメッセージをセット
            req.setAttribute("error_message", "表示するお知らせが指定されていません。");
            RequestDispatcher dispatcher = req.getRequestDispatcher("error.jsp");
            dispatcher.forward(req, res);
            return;
        }

        // 2. DAOを使ってデータ（News Bean）を取得
        NewsDAO newsDao = new NewsDAO();
        News news = newsDao.findById(newsId); // ★DAOにこのメソッドを追加する必要があります

        if (news == null) {
            // 該当するお知らせがない場合のエラー処理
            req.setAttribute("error_message", "指定されたIDのお知らせは見つかりませんでした。");
            RequestDispatcher dispatcher = req.getRequestDispatcher("error.jsp");
            dispatcher.forward(req, res);
            return;
        }

        // 3. 取得したデータをリクエストスコープにセット
        // 詳細JSPで利用するためにデータをセット
        req.setAttribute("news_detail", news);

        // 4. 詳細表示用JSPへフォワード
        RequestDispatcher dispatcher = req.getRequestDispatcher("main/news_detail.jsp");
        dispatcher.forward(req, res);
    }
}